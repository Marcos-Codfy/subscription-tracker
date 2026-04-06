// Casos de uso (Use Cases) da feature de assinaturas.
// Cada use case representa UMA ação do usuário — princípio de Single Responsibility.
// Eles orquestram as regras de negócio e dependem apenas do repositório abstrato.

import 'package:uuid/uuid.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

// Instância única do gerador de IDs únicos (UUID v4)
const _uuid = Uuid();

// ── Use Case: Adicionar Assinatura ────────────────────────────────────────────

/// Caso de uso responsável por adicionar uma nova assinatura.
///
/// Regras de negócio aplicadas:
/// - O nome não pode ser vazio
/// - O preço deve ser maior que zero
class AddSubscriptionUseCase {
  final SubscriptionRepository _repository;

  /// Injeta o repositório via construtor — Dependency Injection
  const AddSubscriptionUseCase(this._repository);

  /// Executa a adição de uma nova assinatura.
  ///
  /// Parâmetros:
  /// - [name]: nome do serviço (obrigatório, não vazio)
  /// - [monthlyPrice]: valor mensal (deve ser > 0)
  /// - [category]: categoria do serviço
  ///
  /// Retorna a [Subscription] criada com ID gerado automaticamente.
  /// Lança [ArgumentError] se as validações falharem.
  Subscription execute({
    required String name,
    required double monthlyPrice,
    required SubscriptionCategory category,
  }) {
    // Validação: nome não pode ser vazio
    if (name.trim().isEmpty) {
      throw ArgumentError('O nome da assinatura não pode ser vazio.');
    }

    // Validação: preço deve ser positivo
    if (monthlyPrice <= 0) {
      throw ArgumentError('O valor mensal deve ser maior que zero.');
    }

    // Cria a entidade com ID único gerado pelo UUID
    final subscription = Subscription(
      id: _uuid.v4(),
      name: name.trim(),
      monthlyPrice: monthlyPrice,
      category: category,
      createdAt: DateTime.now(),
    );

    return _repository.add(subscription);
  }
}

// ── Use Case: Buscar Todas as Assinaturas ─────────────────────────────────────

/// Caso de uso para recuperar todas as assinaturas cadastradas.
class GetAllSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  const GetAllSubscriptionsUseCase(this._repository);

  /// Retorna a lista de todas as assinaturas, ordenadas por nome.
  List<Subscription> execute() {
    final subscriptions = _repository.getAll();

    // Cria uma cópia mutável da lista antes de ordenar
    final sortedList = subscriptions.toList();

    // Ordena alfabeticamente para melhor UX
    sortedList.sort((a, b) => a.name.compareTo(b.name));

    return sortedList;
  }
}

// ── Use Case: Calcular Total Mensal ──────────────────────────────────────────

/// Caso de uso para calcular o total mensal de todas as assinaturas.
class GetTotalMonthlyPriceUseCase {
  final SubscriptionRepository _repository;

  const GetTotalMonthlyPriceUseCase(this._repository);

  /// Retorna o valor total mensal em reais.
  double execute() => _repository.getTotalMonthlyPrice();
}

// ── Use Case: Deletar Assinatura ─────────────────────────────────────────────

/// Caso de uso para remover uma assinatura pelo seu ID.
class DeleteSubscriptionUseCase {
  final SubscriptionRepository _repository;

  const DeleteSubscriptionUseCase(this._repository);

  /// Remove a assinatura com o [id] fornecido.
  /// Lança [SubscriptionNotFoundException] se não existir.
  void execute(String id) => _repository.delete(id);
}

// ── Use Case: Atualizar Assinatura ───────────────────────────────────────────

/// Caso de uso para atualizar os dados de uma assinatura existente.
class UpdateSubscriptionUseCase {
  final SubscriptionRepository _repository;

  const UpdateSubscriptionUseCase(this._repository);

  /// Atualiza a [subscription] no repositório.
  /// Lança [ArgumentError] se os dados forem inválidos.
  /// Lança [SubscriptionNotFoundException] se não existir.
  Subscription execute(Subscription subscription) {
    if (subscription.name.trim().isEmpty) {
      throw ArgumentError('O nome da assinatura não pode ser vazio.');
    }
    if (subscription.monthlyPrice <= 0) {
      throw ArgumentError('O valor mensal deve ser maior que zero.');
    }
    return _repository.update(subscription);
  }
}
