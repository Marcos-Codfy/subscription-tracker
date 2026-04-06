// Provider de estado da feature de assinaturas.
// Usa o padrão Provider + ChangeNotifier para gerenciamento de estado reativo.
// É a camada que conecta a UI com os casos de uso do domínio.

import 'package:flutter/foundation.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/subscription_usecases.dart';
import '../../data/repositories/in_memory_subscription_repository.dart';

/// Estados possíveis da UI para gerenciar feedback visual ao usuário.
enum SubscriptionStatus {
  /// Estado inicial, nenhuma operação em andamento
  idle,

  /// Operação bem-sucedida
  success,

  /// Ocorreu um erro
  error,
}

/// Provider central que gerencia o estado de todas as assinaturas.
///
/// Usa [ChangeNotifier] para notificar a UI de qualquer mudança de estado.
/// Instancia e orquestra todos os [use cases] internamente.
class SubscriptionProvider extends ChangeNotifier {
  // ── Repositório e Use Cases ────────────────────────────────────────────────

  /// Repositório em memória — a única implementação usada por enquanto
  final _repository = InMemorySubscriptionRepository();

  // Use cases inicializados com o repositório injetado
  late final AddSubscriptionUseCase _addUseCase;
  late final GetAllSubscriptionsUseCase _getAllUseCase;
  late final GetTotalMonthlyPriceUseCase _getTotalUseCase;
  late final DeleteSubscriptionUseCase _deleteUseCase;
  late final UpdateSubscriptionUseCase _updateUseCase;

  // ── Estado ─────────────────────────────────────────────────────────────────

  /// Lista de assinaturas exibida na UI
  List<Subscription> _subscriptions = [];

  /// Status atual da última operação
  SubscriptionStatus _status = SubscriptionStatus.idle;

  /// Mensagem de erro para exibir na UI (null se não há erro)
  String? _errorMessage;

  // ── Getters Públicos ───────────────────────────────────────────────────────

  /// Retorna a lista de assinaturas (somente leitura)
  List<Subscription> get subscriptions => _subscriptions;

  /// Retorna o status atual
  SubscriptionStatus get status => _status;

  /// Retorna a mensagem de erro (ou null)
  String? get errorMessage => _errorMessage;

  /// Retorna o total mensal calculado
  double get totalMonthlyPrice => _getTotalUseCase.execute();

  /// Retorna true se não há assinaturas cadastradas
  bool get isEmpty => _subscriptions.isEmpty;

  // ── Construtor ─────────────────────────────────────────────────────────────

  SubscriptionProvider() {
    // Inicializa os use cases injetando o repositório
    _addUseCase = AddSubscriptionUseCase(_repository);
    _getAllUseCase = GetAllSubscriptionsUseCase(_repository);
    _getTotalUseCase = GetTotalMonthlyPriceUseCase(_repository);
    _deleteUseCase = DeleteSubscriptionUseCase(_repository);
    _updateUseCase = UpdateSubscriptionUseCase(_repository);

    // Carrega a lista inicial (vazia ao iniciar)
    _loadSubscriptions();
  }

  // ── Métodos Públicos (chamados pela UI) ────────────────────────────────────

  /// Adiciona uma nova assinatura com os dados fornecidos.
  /// Notifica a UI após a operação.
  void addSubscription({
    required String name,
    required double monthlyPrice,
    required SubscriptionCategory category,
  }) {
    try {
      _addUseCase.execute(
        name: name,
        monthlyPrice: monthlyPrice,
        category: category,
      );
      _loadSubscriptions();
      _setStatus(SubscriptionStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Remove a assinatura pelo [id].
  void deleteSubscription(String id) {
    try {
      _deleteUseCase.execute(id);
      _loadSubscriptions();
      _setStatus(SubscriptionStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Atualiza os dados de uma assinatura existente.
  void updateSubscription(Subscription subscription) {
    try {
      _updateUseCase.execute(subscription);
      _loadSubscriptions();
      _setStatus(SubscriptionStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Reseta o status para [idle] após a UI processar o feedback.
  void resetStatus() {
    _status = SubscriptionStatus.idle;
    _errorMessage = null;
    // Não chama notifyListeners() para evitar rebuild desnecessário
  }

  // ── Métodos Privados ───────────────────────────────────────────────────────

  /// Recarrega a lista do repositório e notifica os ouvintes.
  void _loadSubscriptions() {
    _subscriptions = List.of(_getAllUseCase.execute());
    notifyListeners();
  }

  /// Define o status de sucesso e notifica a UI.
  void _setStatus(SubscriptionStatus status) {
    _status = status;
    _errorMessage = null;
    notifyListeners();
  }

  /// Define o status de erro com mensagem e notifica a UI.
  void _setError(String message) {
    _status = SubscriptionStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
