// Implementação do repositório em memória (in-memory).
// Armazena as assinaturas em uma lista Dart simples — sem banco de dados.
// Isso é suficiente para a disciplina e facilita muito os testes.

import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

/// Implementação concreta do [SubscriptionRepository] usando uma lista em memória.
///
/// Os dados são perdidos ao fechar o app (sem persistência), o que é aceitável
/// para fins de demonstração e testes unitários.
class InMemorySubscriptionRepository implements SubscriptionRepository {
  /// Lista interna que armazena as assinaturas.
  /// É privada para evitar acesso externo direto (encapsulamento).
  final List<Subscription> _subscriptions = [];

  /// Retorna uma cópia da lista para evitar mutação externa (imutabilidade).
  @override
  List<Subscription> getAll() => List.unmodifiable(_subscriptions);

  /// Adiciona uma nova assinatura à lista e a retorna.
  @override
  Subscription add(Subscription subscription) {
    _subscriptions.add(subscription);
    return subscription;
  }

  /// Atualiza uma assinatura existente encontrada pelo [id].
  /// Substitui o item na mesma posição para preservar a ordem.
  @override
  Subscription update(Subscription subscription) {
    final index = _findIndexById(subscription.id);
    _subscriptions[index] = subscription;
    return subscription;
  }

  /// Remove a assinatura com o [id] informado.
  @override
  void delete(String id) {
    final index = _findIndexById(id);
    _subscriptions.removeAt(index);
  }

  /// Soma os valores mensais de todas as assinaturas.
  /// Usa [fold] para reduzir a lista a um único valor acumulado.
  @override
  double getTotalMonthlyPrice() {
    return _subscriptions.fold(
      0.0,
      (total, subscription) => total + subscription.monthlyPrice,
    );
  }

  /// Método auxiliar privado: encontra o índice de uma assinatura pelo [id].
  /// Lança [SubscriptionNotFoundException] se não encontrar.
  int _findIndexById(String id) {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index == -1) {
      throw SubscriptionNotFoundException(id);
    }
    return index;
  }
}
