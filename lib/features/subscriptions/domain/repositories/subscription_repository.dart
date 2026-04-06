// Contrato (interface) do repositório de assinaturas.
// Define O QUE o repositório deve fazer, sem dizer COMO.
// Isso permite trocar a implementação (memória, banco de dados, API) sem mudar a lógica de negócio.

import '../entities/subscription.dart';

/// Contrato abstrato para operações de assinaturas.
///
/// Ao programar para interfaces (não implementações), seguimos o princípio
/// de Inversão de Dependência (o D do SOLID).
abstract class SubscriptionRepository {
  /// Retorna todas as assinaturas cadastradas
  List<Subscription> getAll();

  /// Adiciona uma nova assinatura e a retorna com ID gerado
  Subscription add(Subscription subscription);

  /// Atualiza uma assinatura existente pelo [id].
  /// Lança [SubscriptionNotFoundException] se não encontrar.
  Subscription update(Subscription subscription);

  /// Remove uma assinatura pelo [id].
  /// Lança [SubscriptionNotFoundException] se não encontrar.
  void delete(String id);

  /// Calcula o total mensal somando todas as assinaturas
  double getTotalMonthlyPrice();
}

/// Exceção lançada quando uma assinatura não é encontrada pelo id
class SubscriptionNotFoundException implements Exception {
  final String id;

  const SubscriptionNotFoundException(this.id);

  @override
  String toString() => 'SubscriptionNotFoundException: id=$id não encontrado';
}
