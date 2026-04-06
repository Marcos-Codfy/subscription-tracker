# 📱 Subscription Tracker

> Aplicativo Flutter para controle de assinaturas mensais com BDD, testes unitários e esteira CI/CD automatizada.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart)
![Coverage](https://img.shields.io/badge/Coverage-95.5%25-brightgreen?style=flat-square)

---

## 🎯 Funcionalidades

- ➕ **Adicionar** assinaturas com nome, valor e categoria
- 📊 **Visualizar** o total mensal no topo da tela
- ✏️ **Editar** assinaturas existentes
- 🗑️ **Remover** com swipe ou toque
- 🏷️ **Categorizar** por tipo (streaming, música, games, fitness...)

---

## 🏗️ Arquitetura

O projeto segue **Clean Architecture** com **design patterns**:

```
lib/
├── core/theme/              # Tema dark com paleta azul elétrica
└── features/subscriptions/
    ├── domain/              # Entidades, Use Cases, Contratos (Dart puro)
    ├── data/                # Repositório em memória
    └── presentation/        # Pages, Widgets, Provider
```

Padrões usados: **Repository Pattern**, **Use Cases**, **Provider (Observer)**, **Dependency Injection**, **Immutability (copyWith)**.

---

## 🧪 Testes

### Rodar todos os testes
```bash
flutter test
```

### Rodar com cobertura de código
```bash
flutter test --coverage
```

### Rodar apenas os testes BDD
```bash
flutter test test/bdd/
```

### Rodar apenas os testes unitários
```bash
flutter test test/unit/
```

### Cobertura: 4 suítes de teste

| Arquivo | Tipo | Casos |
|---------|------|-------|
| `subscription_entity_test.dart` | Unitário | 8 |
| `subscription_usecases_test.dart` | Unitário | 12 |
| `in_memory_repository_test.dart` | Unitário | 9 |
| `subscription_provider_test.dart` | Unitário | 7 |
| `subscription_bdd_test.dart` | BDD | 5 |
| **Total** | | **41 casos** |

---

## 🤖 CI/CD — GitHub Actions

A esteira roda automaticamente a cada `git push`:

1. ✅ Checkout do código
2. ✅ Instalação do Flutter 3.11.3 stable
3. ✅ `flutter pub get`
4. ✅ `flutter analyze` (lint)
5. ✅ Verificação de formatação
6. ✅ `flutter test --coverage` (todos os testes)
7. ✅ Geração do relatório lcov HTML
8. ✅ **Validação de cobertura ≥ 75%** ← falha se não atingir
9. ✅ Upload do relatório como artefato

---

## 🚀 Como rodar

```bash
# 1. Clonar
git clone [https://github.com/Marcos-Codfy/subscription-tracker.git](https://github.com/Marcos-Codfy/subscription-tracker.git)
cd subscription-tracker

# 2. Instalar dependências
flutter pub get

# 3. Rodar no emulador ou device
flutter run
```

---

## 🛠️ Tecnologias

| Tech | Uso |
|------|-----|
| Flutter 3.x | Framework principal |
| Dart 3.x | Linguagem |
| Provider | Gerenciamento de estado |
| uuid | Geração de IDs únicos |
| intl | Formatação de moeda (pt_BR) |
| flutter_test | Testes unitários |
| GitHub Actions | CI/CD automatizado |
| lcov | Relatório de cobertura |

---

*Projeto desenvolvido para a disciplina de Teste e Qualidade de Software — 2026.*
