// Testes unitários dos Use Cases de assinaturas.
//
// O que são testes unitários?
// São testes que verificam uma UNIDADE isolada de código (função, classe, método).
// Não dependem de UI, banco de dados ou internet — são rápidos e confiáveis.
//
// Estrutura AAA (Arrange, Act, Assert):
// - Arrange (Preparar): configura o estado inicial necessário
// - Act    (Agir):     executa a ação que será testada
// - Assert (Verificar): confirma que o resultado é o esperado

import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_tracker/features/subscriptions/domain/entities/subscription.dart';
import 'package:subscription_tracker/features/subscriptions/domain/usecases/subscription_usecases.dart';
import 'package:subscription_tracker/features/subscriptions/data/repositories/in_memory_subscription_repository.dart';

void main() {
  // ── Configuração comum ──────────────────────────────────────────────────────
  //
  // setUp() é chamado antes de CADA teste — garante isolamento entre testes.
  // Cada teste começa com um repositório limpo e use cases novos.

  late InMemorySubscriptionRepository repository;
  late AddSubscriptionUseCase addUseCase;
  late GetAllSubscriptionsUseCase getAllUseCase;
  late GetTotalMonthlyPriceUseCase getTotalUseCase;
  late DeleteSubscriptionUseCase deleteUseCase;
  late UpdateSubscriptionUseCase updateUseCase;

  setUp(() {
    repository = InMemorySubscriptionRepository();
    addUseCase = AddSubscriptionUseCase(repository);
    getAllUseCase = GetAllSubscriptionsUseCase(repository);
    getTotalUseCase = GetTotalMonthlyPriceUseCase(repository);
    deleteUseCase = DeleteSubscriptionUseCase(repository);
    updateUseCase = UpdateSubscriptionUseCase(repository);
  });

  // ════════════════════════════════════════════════════════════════════════════
  // GRUPO: AddSubscriptionUseCase
  // ════════════════════════════════════════════════════════════════════════════
  group('AddSubscriptionUseCase', () {
    test(
      'deve adicionar uma assinatura válida e retorná-la com ID gerado',
      () {
        // Arrange: nenhum preparo necessário — repositório já está vazio

        // Act: executa o caso de uso com dados válidos
        final result = addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 39.90,
          category: SubscriptionCategory.streaming,
        );

        // Assert: verifica as propriedades da assinatura criada
        expect(result.name, equals('Netflix'));
        expect(result.monthlyPrice, equals(39.90));
        expect(result.category, equals(SubscriptionCategory.streaming));
        // O ID não deve ser vazio — foi gerado automaticamente
        expect(result.id, isNotEmpty);
      },
    );

    test(
      'deve lançar ArgumentError quando o nome é vazio',
      () {
        // Act + Assert: espera que a execução lance uma exceção do tipo ArgumentError
        expect(
          () => addUseCase.execute(
            name: '',
            monthlyPrice: 39.90,
            category: SubscriptionCategory.streaming,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'deve lançar ArgumentError quando o nome contém apenas espaços',
      () {
        expect(
          () => addUseCase.execute(
            name: '   ',
            monthlyPrice: 39.90,
            category: SubscriptionCategory.streaming,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'deve lançar ArgumentError quando o preço é zero',
      () {
        expect(
          () => addUseCase.execute(
            name: 'Netflix',
            monthlyPrice: 0,
            category: SubscriptionCategory.streaming,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'deve lançar ArgumentError quando o preço é negativo',
      () {
        expect(
          () => addUseCase.execute(
            name: 'Netflix',
            monthlyPrice: -10.0,
            category: SubscriptionCategory.streaming,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'deve remover espaços extras do nome antes de salvar',
      () {
        // Arrange: nome com espaços nas bordas
        final result = addUseCase.execute(
          name: '  Spotify  ',
          monthlyPrice: 21.90,
          category: SubscriptionCategory.music,
        );

        // Assert: nome foi trimado corretamente
        expect(result.name, equals('Spotify'));
      },
    );

    test(
      'deve adicionar múltiplas assinaturas sem conflito de IDs',
      () {
        // Arrange + Act: adiciona duas assinaturas
        final sub1 = addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 39.90,
          category: SubscriptionCategory.streaming,
        );
        final sub2 = addUseCase.execute(
          name: 'Spotify',
          monthlyPrice: 21.90,
          category: SubscriptionCategory.music,
        );

        // Assert: IDs são diferentes
        expect(sub1.id, isNot(equals(sub2.id)));
        // Repositório deve ter 2 itens
        expect(getAllUseCase.execute().length, equals(2));
      },
    );
  });

  // ════════════════════════════════════════════════════════════════════════════
  // GRUPO: GetTotalMonthlyPriceUseCase
  // ════════════════════════════════════════════════════════════════════════════
  group('GetTotalMonthlyPriceUseCase', () {
    test(
      'deve retornar zero quando não há assinaturas',
      () {
        // Act + Assert
        expect(getTotalUseCase.execute(), equals(0.0));
      },
    );

    test(
      'deve retornar o valor correto com uma assinatura',
      () {
        // Arrange
        addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 40.00,
          category: SubscriptionCategory.streaming,
        );

        // Act + Assert
        expect(getTotalUseCase.execute(), equals(40.00));
      },
    );

    test(
      'deve somar corretamente múltiplas assinaturas',
      () {
        // Arrange: adiciona Netflix (40) + Spotify (21.90) + Academia (99.90)
        addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 40.00,
          category: SubscriptionCategory.streaming,
        );
        addUseCase.execute(
          name: 'Spotify',
          monthlyPrice: 21.90,
          category: SubscriptionCategory.music,
        );
        addUseCase.execute(
          name: 'Academia',
          monthlyPrice: 99.90,
          category: SubscriptionCategory.fitness,
        );

        // Act + Assert: 40 + 21.90 + 99.90 = 161.80
        expect(getTotalUseCase.execute(), closeTo(161.80, 0.01));
        // closeTo() é usado para comparar doubles sem problemas de precisão
      },
    );
  });

  // ════════════════════════════════════════════════════════════════════════════
  // GRUPO: DeleteSubscriptionUseCase
  // ════════════════════════════════════════════════════════════════════════════
  group('DeleteSubscriptionUseCase', () {
    test(
      'deve remover a assinatura pelo id',
      () {
        // Arrange
        final sub = addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 39.90,
          category: SubscriptionCategory.streaming,
        );

        // Act
        deleteUseCase.execute(sub.id);

        // Assert: lista deve estar vazia após a remoção
        expect(getAllUseCase.execute(), isEmpty);
      },
    );

    test(
      'deve atualizar o total após remover uma assinatura',
      () {
        // Arrange: adiciona dois serviços
        final netflix = addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 40.00,
          category: SubscriptionCategory.streaming,
        );
        addUseCase.execute(
          name: 'Spotify',
          monthlyPrice: 21.90,
          category: SubscriptionCategory.music,
        );

        // Act: remove o Netflix
        deleteUseCase.execute(netflix.id);

        // Assert: total agora deve ser apenas o Spotify
        expect(getTotalUseCase.execute(), closeTo(21.90, 0.01));
      },
    );
  });

  // ════════════════════════════════════════════════════════════════════════════
  // GRUPO: UpdateSubscriptionUseCase
  // ════════════════════════════════════════════════════════════════════════════
  group('UpdateSubscriptionUseCase', () {
    test(
      'deve atualizar o nome e preço de uma assinatura existente',
      () {
        // Arrange
        final original = addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 39.90,
          category: SubscriptionCategory.streaming,
        );

        // Act: atualiza usando copyWith para não mudar o ID
        final updated = updateUseCase.execute(
          original.copyWith(name: 'Netflix Premium', monthlyPrice: 55.90),
        );

        // Assert
        expect(updated.name, equals('Netflix Premium'));
        expect(updated.monthlyPrice, equals(55.90));
        expect(updated.id, equals(original.id)); // ID não muda
      },
    );

    test(
      'deve lançar ArgumentError ao atualizar com nome vazio',
      () {
        // Arrange
        final sub = addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 39.90,
          category: SubscriptionCategory.streaming,
        );

        // Act + Assert
        expect(
          () => updateUseCase.execute(sub.copyWith(name: '')),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  // ════════════════════════════════════════════════════════════════════════════
  // GRUPO: GetAllSubscriptionsUseCase
  // ════════════════════════════════════════════════════════════════════════════
  group('GetAllSubscriptionsUseCase', () {
    test(
      'deve retornar lista vazia quando não há assinaturas',
      () {
        expect(getAllUseCase.execute(), isEmpty);
      },
    );

    test(
      'deve retornar a lista ordenada alfabeticamente',
      () {
        // Arrange: adiciona em ordem inversa
        addUseCase.execute(
          name: 'Spotify',
          monthlyPrice: 21.90,
          category: SubscriptionCategory.music,
        );
        addUseCase.execute(
          name: 'Academia',
          monthlyPrice: 99.90,
          category: SubscriptionCategory.fitness,
        );
        addUseCase.execute(
          name: 'Netflix',
          monthlyPrice: 39.90,
          category: SubscriptionCategory.streaming,
        );

        // Act
        final result = getAllUseCase.execute();

        // Assert: deve estar em ordem A → N → S
        expect(result[0].name, equals('Academia'));
        expect(result[1].name, equals('Netflix'));
        expect(result[2].name, equals('Spotify'));
      },
    );
  });
}
