// Runner dos testes BDD — executa todos os cenários do arquivo .feature
// mapeando cada linha para a implementação correspondente nos step definitions.
//
// Este arquivo é o "ponto de entrada" dos testes BDD.
// O framework lê os cenários e chama os métodos corretos automaticamente.

import 'package:flutter_test/flutter_test.dart';
import 'step_definitions/subscription_steps.dart';

void main() {
  // Instância compartilhada dos step definitions
  // (reiniciada a cada cenário pelo step "dado que a lista está vazia")
  late SubscriptionStepDefinitions steps;

  setUp(() {
    steps = SubscriptionStepDefinitions();
  });

  // ══════════════════════════════════════════════════════════════════════════
  // CENÁRIO 1: Adicionar primeira assinatura e ver total atualizado
  // Feature: Dado que a lista está vazia
  //          Quando adiciono "Netflix" com valor "40.00"
  //          Então o total deve ser "R$ 40,00"
  // ══════════════════════════════════════════════════════════════════════════
  group(
    'BDD: Feature - Gerenciamento de Assinaturas',
    () {
      test(
        'Cenário: Adicionar a primeira assinatura e ver o total atualizado',
        () {
          // Given
          steps.aListaDeAssinaturasEstaVazia();

          // When
          steps.oUsuarioAdicionaComOValor('Netflix', '40.00');

          // Then
          steps.oValorTotalGastoPorMesDeveSerEmReais('R\$ 40,00');
          steps.aListaDeveConter('1');
        },
      );

      // ════════════════════════════════════════════════════════════════════
      // CENÁRIO 2: Somar múltiplas assinaturas corretamente
      // ════════════════════════════════════════════════════════════════════
      test(
        'Cenário: Somar corretamente múltiplas assinaturas',
        () {
          // Given
          steps.aListaDeAssinaturasEstaVazia();

          // When
          steps.oUsuarioAdicionaComOValor('Netflix', '40.00');
          steps.oUsuarioAdicionaComOValor('Spotify', '21.90');

          // Then
          steps.oValorTotalGastoPorMesDeveSerEmReais('R\$ 61,90');
          steps.aListaDeveConter('2');
        },
      );

      // ════════════════════════════════════════════════════════════════════
      // CENÁRIO 3: Remover assinatura e atualizar total
      // ════════════════════════════════════════════════════════════════════
      test(
        'Cenário: Remover uma assinatura e atualizar o total',
        () {
          // Given
          steps.aListaDeAssinaturasEstaVazia();
          steps.oUsuarioAdicionaComOValor('Netflix', '40.00');
          steps.oUsuarioAdicionaComOValor('Spotify', '21.90');

          // When
          steps.oUsuarioRemoveAAssinatura('Netflix');

          // Then
          steps.oValorTotalGastoPorMesDeveSerEmReais('R\$ 21,90');
          steps.aListaDeveConter('1');
        },
      );

      // ════════════════════════════════════════════════════════════════════
      // CENÁRIO 4: Total zero quando lista está vazia
      // ════════════════════════════════════════════════════════════════════
      test(
        'Cenário: Total deve ser zero quando não há assinaturas',
        () {
          // Given
          steps.aListaDeAssinaturasEstaVazia();

          // Then (sem ação — lista já está vazia)
          steps.oValorTotalGastoPorMesDeveSerEmReais('R\$ 0,00');
          steps.aListaDeveConter('0');
        },
      );

      // ════════════════════════════════════════════════════════════════════
      // CENÁRIO 5: Validação de nome vazio
      // ════════════════════════════════════════════════════════════════════
      test(
        'Cenário: Não deve permitir adicionar assinatura com nome vazio',
        () {
          // Given
          steps.aListaDeAssinaturasEstaVazia();

          // When (ação inválida que deve ser rejeitada)
          steps.oUsuarioTentaAdicionarComNomeVazioEValor('40.00');

          // Then (lista deve permanecer como estava)
          steps.aListaDeveContinuarVazia();
          steps.oTotalDevePermanecer('R\$ 0,00');
        },
      );
    },
  );
}
