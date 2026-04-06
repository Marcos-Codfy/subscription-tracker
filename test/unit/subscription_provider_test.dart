// Testes unitários do SubscriptionProvider (camada de apresentação).
// Verifica que o gerenciador de estado reage corretamente às operações.

import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_tracker/features/subscriptions/domain/entities/subscription.dart';
import 'package:subscription_tracker/features/subscriptions/presentation/providers/subscription_provider.dart';

void main() {
  late SubscriptionProvider provider;

  setUp(() {
    // Cria um provider novo a cada teste para garantir isolamento
    provider = SubscriptionProvider();
  });

  group('SubscriptionProvider', () {
    // ── Estado inicial ─────────────────────────────────────────────────────
    test('deve iniciar com lista vazia e total zero', () {
      expect(provider.subscriptions, isEmpty);
      expect(provider.totalMonthlyPrice, equals(0.0));
      expect(provider.isEmpty, isTrue);
      expect(provider.status, equals(SubscriptionStatus.idle));
    });

    // ── Adicionar assinatura ───────────────────────────────────────────────
    test('deve adicionar assinatura e atualizar o estado', () {
      provider.addSubscription(
        name: 'Netflix',
        monthlyPrice: 39.90,
        category: SubscriptionCategory.streaming,
      );

      expect(provider.subscriptions.length, equals(1));
      expect(provider.subscriptions.first.name, equals('Netflix'));
      expect(provider.totalMonthlyPrice, closeTo(39.90, 0.01));
      expect(provider.isEmpty, isFalse);
      expect(provider.status, equals(SubscriptionStatus.success));
    });

    test('deve definir status de erro ao tentar adicionar com nome vazio', () {
      provider.addSubscription(
        name: '',
        monthlyPrice: 39.90,
        category: SubscriptionCategory.streaming,
      );

      expect(provider.status, equals(SubscriptionStatus.error));
      expect(provider.errorMessage, isNotNull);
      expect(provider.subscriptions, isEmpty);
    });

    // ── Deletar assinatura ─────────────────────────────────────────────────
    test('deve deletar assinatura e atualizar o estado', () {
      // Arrange: adiciona antes de deletar
      provider.addSubscription(
        name: 'Netflix',
        monthlyPrice: 39.90,
        category: SubscriptionCategory.streaming,
      );
      final id = provider.subscriptions.first.id;

      // Act
      provider.deleteSubscription(id);

      // Assert
      expect(provider.subscriptions, isEmpty);
      expect(provider.totalMonthlyPrice, equals(0.0));
    });

    // ── Atualizar assinatura ───────────────────────────────────────────────
    test('deve atualizar assinatura e recalcular o total', () {
      // Arrange
      provider.addSubscription(
        name: 'Netflix',
        monthlyPrice: 39.90,
        category: SubscriptionCategory.streaming,
      );
      final original = provider.subscriptions.first;

      // Act
      provider.updateSubscription(
        original.copyWith(name: 'Netflix Premium', monthlyPrice: 55.90),
      );

      // Assert
      expect(provider.subscriptions.first.name, equals('Netflix Premium'));
      expect(provider.totalMonthlyPrice, closeTo(55.90, 0.01));
    });

    // ── Reset de status ────────────────────────────────────────────────────
    test('deve resetar o status para idle após resetStatus()', () {
      provider.addSubscription(
        name: 'Netflix',
        monthlyPrice: 39.90,
        category: SubscriptionCategory.streaming,
      );
      expect(provider.status, equals(SubscriptionStatus.success));

      provider.resetStatus();
      expect(provider.status, equals(SubscriptionStatus.idle));
      expect(provider.errorMessage, isNull);
    });

    // ── Total com múltiplas assinaturas ────────────────────────────────────
    test('deve calcular total correto com múltiplas assinaturas', () {
      provider.addSubscription(
        name: 'Netflix',
        monthlyPrice: 40.00,
        category: SubscriptionCategory.streaming,
      );
      provider.addSubscription(
        name: 'Spotify',
        monthlyPrice: 21.90,
        category: SubscriptionCategory.music,
      );
      provider.addSubscription(
        name: 'Academia',
        monthlyPrice: 99.90,
        category: SubscriptionCategory.fitness,
      );

      // 40 + 21.90 + 99.90 = 161.80
      expect(provider.totalMonthlyPrice, closeTo(161.80, 0.01));
      expect(provider.subscriptions.length, equals(3));
    });
  });
}
