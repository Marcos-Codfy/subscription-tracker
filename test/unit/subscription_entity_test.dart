// Testes unitários da entidade Subscription.
// Garante que a entidade de domínio se comporta corretamente.

import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_tracker/features/subscriptions/domain/entities/subscription.dart';

void main() {
  // Assinatura base usada nos testes
  final baseSubscription = Subscription(
    id: 'abc-123',
    name: 'Netflix',
    monthlyPrice: 39.90,
    category: SubscriptionCategory.streaming,
    createdAt: DateTime(2026, 5, 1),
  );

  group('Subscription Entity', () {
    // ── copyWith ───────────────────────────────────────────────────────────
    group('copyWith()', () {
      test('deve criar cópia com nome alterado mantendo os demais campos', () {
        final copy = baseSubscription.copyWith(name: 'Netflix Premium');

        expect(copy.name, equals('Netflix Premium'));
        expect(copy.id, equals(baseSubscription.id)); // não mudou
        expect(copy.monthlyPrice,
            equals(baseSubscription.monthlyPrice)); // não mudou
        expect(copy.category, equals(baseSubscription.category)); // não mudou
      });

      test('deve criar cópia com preço alterado', () {
        final copy = baseSubscription.copyWith(monthlyPrice: 55.90);

        expect(copy.monthlyPrice, equals(55.90));
        expect(copy.name, equals('Netflix')); // não mudou
      });

      test('copyWith sem argumentos deve retornar objeto idêntico', () {
        final copy = baseSubscription.copyWith();

        expect(copy.id, equals(baseSubscription.id));
        expect(copy.name, equals(baseSubscription.name));
        expect(copy.monthlyPrice, equals(baseSubscription.monthlyPrice));
      });
    });

    // ── Igualdade ──────────────────────────────────────────────────────────
    group('Equality (==)', () {
      test('duas assinaturas com mesmo id devem ser iguais', () {
        final sub1 = baseSubscription;
        final sub2 = baseSubscription.copyWith(name: 'Outro Nome');

        // Mesmo id → são iguais (independente dos outros campos)
        expect(sub1, equals(sub2));
      });

      test('assinaturas com ids diferentes não devem ser iguais', () {
        final sub1 = baseSubscription;
        final sub2 = baseSubscription.copyWith(id: 'outro-id');

        expect(sub1, isNot(equals(sub2)));
      });
    });

    // ── hashCode ───────────────────────────────────────────────────────────
    test('hashCode deve ser baseado no id', () {
      final sub1 = baseSubscription;
      final sub2 = baseSubscription.copyWith(name: 'Diferente');

      expect(sub1.hashCode, equals(sub2.hashCode));
    });

    // ── toString ───────────────────────────────────────────────────────────
    test('toString deve conter id, name e monthlyPrice', () {
      final str = baseSubscription.toString();

      expect(str, contains('abc-123'));
      expect(str, contains('Netflix'));
      expect(str, contains('39.9'));
    });

    // ── SubscriptionCategory.displayName ──────────────────────────────────
    group('SubscriptionCategory.displayName', () {
      test('cada categoria deve ter um nome de exibição não vazio', () {
        for (final category in SubscriptionCategory.values) {
          expect(category.displayName, isNotEmpty,
              reason: 'Categoria ${category.name} sem displayName');
        }
      });

      test('streaming deve exibir "Streaming"', () {
        expect(SubscriptionCategory.streaming.displayName, equals('Streaming'));
      });

      test('music deve exibir "Música"', () {
        expect(SubscriptionCategory.music.displayName, equals('Música'));
      });
    });
  });
}
