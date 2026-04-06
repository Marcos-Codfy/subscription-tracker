// Entidade de domínio que representa uma assinatura de serviço.
// Segue o padrão de Clean Architecture: a entidade é pura, sem dependência de frameworks.

/// Representa uma assinatura mensal de um serviço (ex: Netflix, Spotify).
///
/// É uma classe imutável — para alterar, use o método [copyWith].
/// Isso evita mutações acidentais e facilita os testes unitários.
class Subscription {
  /// Identificador único gerado automaticamente
  final String id;

  /// Nome do serviço de assinatura (ex: "Netflix")
  final String name;

  /// Valor mensal em reais
  final double monthlyPrice;

  /// Categoria do serviço para exibir o ícone correto
  final SubscriptionCategory category;

  /// Data em que a assinatura foi cadastrada
  final DateTime createdAt;

  /// Construtor principal — todos os campos são obrigatórios.
  const Subscription({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.category,
    required this.createdAt,
  });

  /// Cria uma cópia da assinatura com campos opcionalmente sobrescritos.
  /// Padrão imutável — nunca modifica a instância original.
  Subscription copyWith({
    String? id,
    String? name,
    double? monthlyPrice,
    SubscriptionCategory? category,
    DateTime? createdAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Igualdade baseada no [id] — duas assinaturas são iguais se têm o mesmo id.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Subscription(id: $id, name: $name, monthlyPrice: $monthlyPrice)';
}

/// Enum que categoriza o tipo de serviço para exibição de ícone e cor.
/// Usando enum com propriedades para evitar switch/case espalhados pelo código.
enum SubscriptionCategory {
  streaming,
  music,
  gaming,
  fitness,
  productivity,
  other;

  /// Retorna o nome legível da categoria em português
  String get displayName {
    switch (this) {
      case SubscriptionCategory.streaming:
        return 'Streaming';
      case SubscriptionCategory.music:
        return 'Música';
      case SubscriptionCategory.gaming:
        return 'Games';
      case SubscriptionCategory.fitness:
        return 'Fitness';
      case SubscriptionCategory.productivity:
        return 'Produtividade';
      case SubscriptionCategory.other:
        return 'Outros';
    }
  }
}
