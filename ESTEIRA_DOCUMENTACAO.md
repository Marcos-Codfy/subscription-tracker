# Documentação da Esteira de CI/CD — Subscription Tracker

**Disciplina:** Teste e Qualidade de Software  
**Aluno:** Marcos  
**Projeto:** Subscription Tracker — Gerenciador de Assinaturas Mensais  
**Tecnologia:** Flutter / Dart  
**Ferramenta de CI/CD:** GitHub Actions  

---

## O que é esse projeto?

O Subscription Tracker é um aplicativo mobile desenvolvido em Flutter que permite ao usuário cadastrar seus serviços de assinatura mensal (como Netflix, Spotify, Academia), informando o nome e o valor de cada um. O app exibe automaticamente o total gasto por mês no topo da tela.

O projeto foi desenvolvido aplicando conceitos de **Clean Architecture**, **Design Patterns** e **qualidade de software**, com foco especial em testes automatizados usando a metodologia **BDD** e uma **esteira de CI/CD** configurada no GitHub Actions.

---

## O que é BDD e por que usei?

**BDD (Behavior Driven Development)** significa Desenvolvimento Guiado pelo Comportamento. É uma forma de escrever testes que qualquer pessoa consegue entender, não só programadores.

Em vez de escrever testes técnicos difíceis de ler, o BDD usa uma linguagem chamada **Gherkin**, com três palavras-chave principais:

- **Given (Dado que):** qual é a situação inicial
- **When (Quando):** qual ação o usuário realiza
- **Then (Então):** qual é o resultado esperado

### Exemplo real do meu projeto:

```gherkin
Scenario: Adicionar a primeira assinatura e ver o total atualizado
  Given a lista de assinaturas está vazia
  When o usuário adiciona "Netflix" com o valor "40.00"
  Then o valor total gasto por mês deve ser "R$ 40,00"
  And a lista deve conter "1" assinatura
```

Isso é muito mais fácil de entender do que um teste técnico puro. Qualquer pessoa consegue ler e entender o que o sistema deve fazer.

Usei BDD porque ele obriga você a pensar no **comportamento do sistema antes de escrever o código**, o que reduz bugs e garante que o que foi desenvolvido realmente atende ao esperado.

No projeto escrevi **5 cenários BDD** que cobrem os principais fluxos:
1. Adicionar a primeira assinatura
2. Somar múltiplas assinaturas
3. Remover uma assinatura e ver o total atualizado
4. Lista vazia com total zero
5. Rejeitar assinatura com nome vazio (validação)

---

## O que é a Esteira de CI/CD?

**CI/CD** significa:
- **CI (Continuous Integration):** toda vez que eu faço um `git push`, o GitHub executa os testes automaticamente para garantir que nada foi quebrado.
- **CD (Continuous Delivery):** o software está sempre pronto para ser entregue, pois é verificado a cada mudança.

Resumindo: a esteira é um **robô automático** que fica de olho no meu repositório. Toda vez que eu envio código novo, ele roda todos os testes, verifica a qualidade do código e confirma se a cobertura de testes está acima de 75%. Se algo estiver errado, ele avisa imediatamente com um ❌ vermelho.

---

## Como a Esteira foi Criada

A esteira foi criada usando o **GitHub Actions**, que é a ferramenta de CI/CD nativa do GitHub. Para ativá-la, basta criar um arquivo `.yml` dentro da pasta `.github/workflows/` no repositório.

O arquivo da minha esteira se chama `flutter_ci.yml` e fica em:

```
.github/
  workflows/
    flutter_ci.yml
```

O GitHub detecta esse arquivo automaticamente e executa tudo que está dentro dele sempre que eu faço um push.

---

## Quando a Esteira É Executada

```yaml
on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]
```

Configurei para rodar em dois momentos:
- Quando faço **push** para as branches `main` ou `master`
- Quando abro um **Pull Request** nessas branches

Isso garante que nenhum código com problema entre na branch principal.

---

## Onde a Esteira Roda

```yaml
runs-on: ubuntu-latest
```

A esteira roda em um servidor **Ubuntu Linux** fornecido pelo próprio GitHub gratuitamente. Esse servidor é temporário — existe só durante a execução e é destruído depois. Ele não tem nada instalado, por isso precisamos instalar o Flutter manualmente em um dos steps.

---

## Os Steps da Esteira — Explicados Um a Um

A esteira tem **12 steps** que rodam em sequência. Se qualquer step falhar, os próximos são cancelados e o resultado aparece como ❌ no GitHub.

---

### Step 1 — Baixar o código do repositório

```yaml
- name: 📥 Checkout repository
  uses: actions/checkout@v4
```

**O que faz:** Baixa o código do meu repositório para dentro do servidor Ubuntu do GitHub.

**Por que é necessário:** O servidor começa completamente vazio. Sem esse step, ele não teria nenhum arquivo do projeto para trabalhar.

**`actions/checkout@v4`** é uma "Action" pronta, mantida pela própria equipe do GitHub. O `@v4` indica a versão que estou usando.

---

### Step 2 — Instalar o Flutter

```yaml
- name: 🐦 Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.x'
    channel: 'stable'
    cache: true
```

**O que faz:** Instala o Flutter no servidor Ubuntu.

**Por que é necessário:** O servidor não tem o Flutter instalado. Sem ele, nenhum comando `flutter` funciona.

**`subosito/flutter-action@v2`** é uma Action criada pela comunidade que automatiza toda a instalação do Flutter. Sem ela, teríamos que escrever dezenas de linhas de comandos shell para instalar manualmente.

**`channel: 'stable'`** garante que usamos a versão estável do Flutter, não versões beta ou dev que podem ter bugs.

**`cache: true`** salva o Flutter instalado para reutilizar nos próximos pushes. Isso reduz o tempo de execução de ~3 minutos para ~30 segundos.

---

### Step 3 — Ver a versão do Flutter instalado

```yaml
- name: 🔍 Flutter version info
  run: flutter --version
```

**O que faz:** Imprime no log qual versão do Flutter foi instalada.

**Por que é necessário:** Serve para debug. Se algo der errado depois, consigo ver exatamente qual versão estava sendo usada.

---

### Step 4 — Instalar as dependências do projeto

```yaml
- name: 📦 Install dependencies
  run: flutter pub get
```

**O que faz:** Baixa todos os pacotes listados no `pubspec.yaml` (provider, uuid, intl etc.).

**Por que é necessário:** É o equivalente ao `npm install` do JavaScript. Sem isso, o código não compila porque as bibliotecas externas não estão presentes no servidor.

---

### Step 5 — Analisar o código (Lint)

```yaml
- name: 🔬 Analyze code (lint)
  run: flutter analyze --fatal-infos
```

**O que faz:** Analisa o código estaticamente em busca de erros, variáveis não usadas, más práticas e violações de estilo.

**Por que é necessário:** O analisador do Dart encontra problemas **sem precisar executar o código**. Ele pega erros de tipo, imports desnecessários e código morto antes mesmo de rodar qualquer teste.

**`--fatal-infos`** faz a esteira falhar mesmo para avisos informativos (não só erros). Isso força um padrão de código mais rigoroso.

---

### Step 6 — Verificar a formatação do código

```yaml
- name: 🎨 Check code formatting
  run: dart format --output=none --set-exit-if-changed .
```

**O que faz:** Verifica se todo o código está formatado de acordo com o padrão oficial do Dart.

**Por que é necessário:** Times que não seguem um padrão de formatação perdem tempo discutindo estilo em code reviews. Com esse step, se qualquer arquivo não estiver formatado, a esteira falha e obriga o desenvolvedor a rodar `dart format .` antes de fazer push.

**`--set-exit-if-changed`** retorna um código de erro se encontrar algum arquivo fora do padrão, o que faz o step falhar automaticamente.

---

### Step 7 — Rodar todos os testes com cobertura

```yaml
- name: 🧪 Run all tests with coverage
  run: flutter test --coverage
```

**O que faz:** Executa todos os arquivos de teste da pasta `test/` e gera o arquivo `coverage/lcov.info`.

**Por que é necessário:** É o passo mais importante da esteira. Roda os 41 casos de teste (unitários + BDD) e registra quais linhas do código foram executadas durante os testes.

**`--coverage`** ativa a geração do arquivo `lcov.info`, que é um arquivo de texto padrão da indústria que registra a cobertura linha por linha.

---

### Step 8 — Instalar o lcov

```yaml
- name: 🛠️ Install lcov
  run: sudo apt-get install -y lcov
```

**O que faz:** Instala a ferramenta `lcov` no servidor Ubuntu.

**Por que é necessário:** O `lcov` é uma ferramenta open-source que processa o arquivo `lcov.info` gerado pelo Flutter. Com ele consigo gerar relatórios HTML coloridos e extrair o percentual de cobertura.

---

### Step 9 — Filtrar arquivos gerados da cobertura

```yaml
- name: 🧹 Filter generated files from coverage
  run: |
    lcov --remove coverage/lcov.info \
      'lib/main.dart' \
      '*.g.dart' \
      '*/generated/*' \
      --output-file coverage/lcov_filtered.info \
      --ignore-errors unused
```

**O que faz:** Remove certos arquivos do relatório de cobertura antes de calcular o percentual.

**Por que é necessário:** Alguns arquivos não devem ser contados na cobertura porque são difíceis ou impossíveis de testar em ambiente de CI:
- `lib/main.dart`: é o ponto de entrada do app, que inicializa a UI. Impossível de testar unitariamente.
- `*.g.dart`: arquivos gerados automaticamente por ferramentas (não código escrito por mim).

Se não filtrarmos, o percentual de cobertura seria injustamente baixo por causa de arquivos que não controlamos.

---

### Step 10 — Gerar relatório HTML de cobertura

```yaml
- name: 📊 Generate HTML coverage report
  run: genhtml coverage/lcov_filtered.info --output-directory coverage/html
```

**O que faz:** Converte o `lcov_filtered.info` em um site HTML com todas as linhas do código coloridas em verde (coberta) ou vermelho (não coberta).

**Por que é necessário:** O arquivo `.info` é texto puro, impossível de ler visualmente. O `genhtml` transforma isso em páginas HTML navegáveis onde consigo ver exatamente quais linhas precisam de mais testes.

---

### Step 11 — Validar que a cobertura está acima de 75%

```yaml
- name: ✅ Validate coverage threshold (≥75%)
  run: |
    COVERAGE=$(lcov --summary coverage/lcov_filtered.info 2>&1 \
      | grep "lines" \
      | grep -oP '\d+\.\d+(?=%)' \
      | head -1)

    python3 -c "
    coverage = float('${COVERAGE}')
    if coverage < 75.0:
        print(f'❌ FALHOU: {coverage}% < 75%')
        exit(1)
    else:
        print(f'✅ PASSOU: {coverage}% >= 75%')
    "
```

**O que faz:** Extrai o percentual de cobertura do relatório e verifica se está acima de 75%. Se estiver abaixo, o step falha com `exit(1)`, o que faz toda a esteira falhar com ❌.

**Por que é necessário:** Sem essa verificação, a cobertura seria apenas informativa. Com ela, a esteira **bloqueia** qualquer código que reduza a cobertura abaixo do mínimo aceitável. É a garantia automatizada de qualidade.

**Como funciona tecnicamente:**
1. `lcov --summary` imprime um resumo com as métricas
2. `grep "lines"` pega apenas a linha de cobertura de código
3. `grep -oP '\d+\.\d+(?=%)'` extrai só o número (ex: `82.5`)
4. `python3` compara com `75.0` e retorna erro se for menor

---

### Step 12 — Salvar o relatório como artefato

```yaml
- name: 📁 Upload coverage report artifact
  uses: actions/upload-artifact@v4
  if: always()
  with:
    name: coverage-report
    path: coverage/html/
    retention-days: 30
```

**O que faz:** Salva o relatório HTML gerado como um "artefato" disponível para download na aba Actions do GitHub.

**Por que é necessário:** Sem isso, o relatório seria gerado no servidor temporário e destruído ao final da execução. Com o artefato, qualquer pessoa pode baixar e abrir o HTML localmente para ver a cobertura visual.

**`if: always()`** garante que o artefato é salvo **mesmo se os testes falharam**, o que é útil para debugar o que deu errado.

**`retention-days: 30`** mantém o artefato disponível por 30 dias antes de ser deletado automaticamente.

---

### Step 13 — Publicar resumo no GitHub

```yaml
- name: 📝 Publish coverage summary
  if: always()
  run: |
    echo "## 📊 Test Coverage Report" >> $GITHUB_STEP_SUMMARY
    ...
```

**O que faz:** Escreve um resumo formatado diretamente na página de resultado do workflow no GitHub.

**Por que é necessário:** Em vez de precisar abrir os logs técnicos, o resumo aparece de forma visual e amigável na página principal do workflow, mostrando as métricas de cobertura de forma clara.

---

## Resumo Visual da Esteira

```
git push
    │
    ▼
GitHub detecta o push
    │
    ▼
┌──────────────────────────────────────────┐
│  Servidor Ubuntu temporário do GitHub    │
│                                          │
│  1.  Baixa o código do repositório       │
│  2.  Instala o Flutter 3.x stable        │
│  3.  Mostra a versão instalada           │
│  4.  flutter pub get                     │
│  5.  flutter analyze (lint)              │
│  6.  dart format --check                 │
│  7.  flutter test --coverage  ← TESTES   │
│  8.  Instala o lcov                      │
│  9.  Filtra arquivos gerados             │
│  10. Gera relatório HTML                 │
│  11. Valida cobertura >= 75%  ← CRÍTICO  │
│  12. Salva relatório (artefato)          │
│  13. Publica resumo no GitHub            │
└──────────────────────────────────────────┘
    │
    ▼
✅ Verde = tudo passou
❌ Vermelho = algo falhou (bloqueia o merge)
```

---

## Estrutura de Testes do Projeto

O projeto possui **41 casos de teste** divididos em duas categorias:

### Testes Unitários (36 casos)

Testes unitários verificam uma unidade isolada do código — uma função, método ou classe — sem depender de banco de dados, internet ou interface gráfica. São rápidos e confiáveis.

| Arquivo | O que testa | Casos |
|---------|-------------|-------|
| `subscription_entity_test.dart` | Entidade Subscription: copyWith, igualdade, hashCode | 8 |
| `subscription_usecases_test.dart` | 5 Use Cases: validações, soma, remoção, atualização | 12 |
| `in_memory_repository_test.dart` | Repositório: CRUD completo, exceções | 9 |
| `subscription_provider_test.dart` | Provider: estado reativo, erros, reset | 7 |

### Testes BDD (5 cenários)

Testes escritos em linguagem Gherkin (Given/When/Then) que descrevem o comportamento do sistema do ponto de vista do usuário.

| Cenário | Descrição |
|---------|-----------|
| 1 | Adicionar primeira assinatura e ver total |
| 2 | Somar múltiplas assinaturas corretamente |
| 3 | Remover assinatura e atualizar total |
| 4 | Lista vazia exibe total zero |
| 5 | Rejeitar assinatura com nome vazio |

---

## Resultado da Esteira

Após o `git push`, acesse a aba **Actions** no repositório do GitHub para ver:

- ✅ Todos os steps verdes = código aprovado
- ❌ Algum step vermelho = problema identificado automaticamente

O relatório de cobertura fica disponível para download na seção **Artifacts** de cada execução.

---

*Documentação produzida como parte da entrega da disciplina de Teste e Qualidade de Software — 2026.*
