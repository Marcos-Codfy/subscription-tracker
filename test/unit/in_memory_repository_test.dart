// Testes unitários do repositório em memória.
// Verifica que a camada de dados funciona corretamente de forma isolada.

import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_tracker/features/subscriptions/domain/entities/subscription.dart';
import 'package:subscription_tracker/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:subscription_tracker/features/subscriptions/data/repositories/in_memory_subscription_repository.dart';

void main() {
  late InMemorySubscriptionRepository repository;

  // Assinatura de teste reutilizável
  final testSubscription = Subscription(
    id: 'test-id-001',
    name: 'Netflix',
    monthlyPrice: 39.90,
    category: SubscriptionCategory.streaming,
    createdAt: DateTime(2026, 5, 1),
  );

  setUp(() {
    repository = InMemorySubscriptionRepository();
  });

  group('InMemorySubscriptionRepository', () {
    // ── Testes de Add ──────────────────────────────────────────────────────
    group('add()', () {
      test('deve adicionar uma assinatura e retorná-la', () {
        // Act
        final result = repository.add(testSubscription);

        // Assert
        expect(result, equals(testSubscription));
        expect(repository.getAll().length, equals(1));
      });

      test('deve permitir adicionar múltiplas assinaturas', () {
        // Arrange
        final sub2 =
            testSubscription.copyWith(id: 'test-id-002', name: 'Spotify');

        // Act
        repository.add(testSubscription);
        repository.add(sub2);

        // Assert
        expect(repository.getAll().length, equals(2));
      });
    });

    // ── Testes de GetAll ───────────────────────────────────────────────────
    group('getAll()', () {
      test('deve retornar lista vazia inicialmente', () {
        expect(repository.getAll(), isEmpty);
      });

      test('deve retornar lista imutável (não permite modificação externa)',
          () {
        repository.add(testSubscription);

        // Tenta modificar a lista retornada
        final list = repository.getAll();
        expect(
            () => (list as dynamic).add(testSubscription), throwsA(anything));
      });
    });

    // ── Testes de Delete ───────────────────────────────────────────────────
    group('delete()', () {
      test('deve remover a assinatura pelo id', () {
        // Arrange
        repository.add(testSubscription);

        // Act
        repository.delete(testSubscription.id);

        // Assert
        expect(repository.getAll(), isEmpty);
      });

      test('deve lançar SubscriptionNotFoundException para id inexistente', () {
        expect(
          () => repository.delete('id-que-nao-existe'),
          throwsA(isA<SubscriptionNotFoundException>()),
        );
      });
    });

    // ── Testes de Update ───────────────────────────────────────────────────
    group('update()', () {
      test('deve atualizar os dados de uma assinatura existente', () {
        // Arrange
        repository.add(testSubscription);
        final updated = testSubscription.copyWith(
            name: 'Netflix Premium', monthlyPrice: 55.90);

        // Act
        repository.update(updated);

        // Assert: busca pelo mesmo ID e verifica os dados atualizados
        final result =
            repository.getAll().firstWhere((s) => s.id == testSubscription.id);
        expect(result.name, equals('Netflix Premium'));
        expect(result.monthlyPrice, equals(55.90));
      });

      test('deve lançar SubscriptionNotFoundException para id inexistente', () {
        final nonExistent = testSubscription.copyWith(id: 'nao-existe');

        expect(
          () => repository.update(nonExistent),
          throwsA(isA<SubscriptionNotFoundException>()),
        );
      });
    });

    // ── Testes de GetTotal ─────────────────────────────────────────────────
    group('getTotalMonthlyPrice()', () {
      test('deve retornar 0.0 quando não há assinaturas', () {
        expect(repository.getTotalMonthlyPrice(), equals(0.0));
      });

      test('deve somar corretamente os valores de todas as assinaturas', () {
        // Arrange: 39.90 + 21.90 = 61.80
        repository.add(testSubscription); // 39.90
        repository.add(testSubscription.copyWith(
          id: 'test-id-002',
          name: 'Spotify',
          monthlyPrice: 21.90,
        ));

        // Act + Assert
        expect(repository.getTotalMonthlyPrice(), closeTo(61.80, 0.01));
      });

      test('deve recalcular o total após remoção', () {
        // Arrange
        repository.add(testSubscription); // 39.90
        final sub2 = testSubscription.copyWith(
            id: 'test-id-002', name: 'Spotify', monthlyPrice: 21.90);
        repository.add(sub2);

        // Act: remove o Netflix
        repository.delete(testSubscription.id);

        // Assert: deve restar apenas o Spotify
        expect(repository.getTotalMonthlyPrice(), closeTo(21.90, 0.01));
      });
    });
  });
}
