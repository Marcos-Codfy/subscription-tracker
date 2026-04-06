// Step Definitions — implementações Dart dos passos Gherkin do arquivo .feature
//
// Cada método aqui corresponde a uma linha do arquivo .feature.
// O framework BDD faz o mapeamento automático pelo texto do método.
//
// IMPORTANTE: Como o bdd_widget_test opera no nível de teste de unidade
// para nossa lógica de negócio, usamos o provider diretamente aqui.

import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_tracker/features/subscriptions/domain/entities/subscription.dart';
import 'package:subscription_tracker/features/subscriptions/domain/usecases/subscription_usecases.dart';
import 'package:subscription_tracker/features/subscriptions/data/repositories/in_memory_subscription_repository.dart';

/// Classe que implementa os passos (steps) dos cenários BDD.
///
/// Cada método público corresponde exatamente a um passo no arquivo .feature.
/// Isso mantém os testes legíveis e próximos da especificação de negócio.
class SubscriptionStepDefinitions {
  late InMemorySubscriptionRepository _repository;
  late AddSubscriptionUseCase _addUseCase;
  late GetAllSubscriptionsUseCase _getAllUseCase;
  late GetTotalMonthlyPriceUseCase _getTotalUseCase;
  late DeleteSubscriptionUseCase _deleteUseCase;

  // Captura a exceção lançada para validar cenários de erro
  dynamic _lastException;

  /// [Given] Inicializa o contexto com repositório vazio
  void aListaDeAssinaturasEstaVazia() {
    _repository = InMemorySubscriptionRepository();
    _addUseCase = AddSubscriptionUseCase(_repository);
    _getAllUseCase = GetAllSubscriptionsUseCase(_repository);
    _getTotalUseCase = GetTotalMonthlyPriceUseCase(_repository);
    _deleteUseCase = DeleteSubscriptionUseCase(_repository);
    _lastException = null;
  }

  /// [When] Adiciona uma assinatura com nome e valor fornecidos
  void oUsuarioAdicionaComOValor(String name, String price) {
    final monthlyPrice = double.parse(price);
    _addUseCase.execute(
      name: name,
      monthlyPrice: monthlyPrice,
      category: SubscriptionCategory.streaming,
    );
  }

  /// [When] Tenta adicionar com nome vazio — captura o erro sem lançar
  void oUsuarioTentaAdicionarComNomeVazioEValor(String price) {
    try {
      _addUseCase.execute(
        name: '',
        monthlyPrice: double.parse(price),
        category: SubscriptionCategory.other,
      );
    } on ArgumentError catch (e) {
      _lastException = e;
    }
  }

  /// [When] Remove a assinatura pelo nome
  void oUsuarioRemoveAAssinatura(String name) {
    final subscriptions = _getAllUseCase.execute();
    final subscription = subscriptions.firstWhere(
      (s) => s.name == name,
      orElse: () => throw Exception('Assinatura "$name" não encontrada'),
    );
    _deleteUseCase.execute(subscription.id);
  }

  /// [Then] Verifica o total mensal esperado (formato "R$ 40,00")
  void oValorTotalGastoPorMesDeveSerEmReais(String expectedFormatted) {
    final total = _getTotalUseCase.execute();
    // Converte o valor esperado removendo "R$ " e substituindo "," por "."
    final expectedValue = double.parse(
      expectedFormatted
          .replaceAll('R\$ ', '')
          .replaceAll('.', '')
          .replaceAll(',', '.'),
    );
    expect(total, closeTo(expectedValue, 0.01));
  }

  /// [Then] Alias para verificação do total (usado em cenários de erro)
  void oTotalDevePermanecer(String expectedFormatted) {
    oValorTotalGastoPorMesDeveSerEmReais(expectedFormatted);
  }

  /// [Then] Verifica o número de assinaturas na lista
  void aListaDeveConter(String countStr) {
    final count = int.parse(countStr);
    expect(_getAllUseCase.execute().length, equals(count));
  }

  /// [Then] Verifica que a lista permanece vazia (cenários de erro)
  void aListaDeveContinuarVazia() {
    expect(_getAllUseCase.execute(), isEmpty);
  }

  /// Verifica que um erro foi capturado (para cenários de validação)
  void umErroDeveTerSidoLancado() {
    expect(_lastException, isNotNull);
  }
}
