// Widget da lista de assinaturas com suporte a swipe para deletar.
// Usa SliverList para integração perfeita com CustomScrollView.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/subscription.dart';
import '../../../../core/theme/app_theme.dart';
import '../pages/add_subscription_page.dart';

/// Widget que exibe a lista de assinaturas em formato de cards.
///
/// Suporta:
/// - Swipe para esquerda para deletar
/// - Tap para editar
/// - Animação de remoção
class SubscriptionListWidget extends StatelessWidget {
  /// Lista de assinaturas para exibir
  final List<Subscription> subscriptions;

  /// Callback chamado ao confirmar a exclusão de uma assinatura
  final void Function(String id) onDelete;

  const SubscriptionListWidget({
    super.key,
    required this.subscriptions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final subscription = subscriptions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: _SubscriptionCard(
              subscription: subscription,
              onDelete: () => _confirmDelete(context, subscription),
              onEdit: () => _navigateToEdit(context, subscription),
            ),
          );
        },
        childCount: subscriptions.length,
      ),
    );
  }

  /// Exibe o diálogo de confirmação antes de deletar
  Future<void> _confirmDelete(
      BuildContext context, Subscription subscription) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Plan',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          'Remove "${subscription.name}" from your subscriptions?',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete(subscription.id);
    }
  }

  /// Navega para a tela de edição da assinatura
  void _navigateToEdit(BuildContext context, Subscription subscription) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            AddSubscriptionPage(subscription: subscription),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

// ── Card Individual de Assinatura ─────────────────────────────────────────────

/// Card visual de uma assinatura individual.
///
/// Usa [Dismissible] para suporte ao gesto de swipe para deletar.
class _SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _SubscriptionCard({
    required this.subscription,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return Dismissible(
      key: Key('subscription_${subscription.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        // Retorna false para o Dismissible não remover — o provider cuida disso
        return false;
      },
      // Background vermelho que aparece ao fazer swipe
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: AppTheme.errorColor),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.textDisabled.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Ícone da categoria com fundo colorido
              _buildCategoryIcon(),
              const SizedBox(width: 16),

              // Nome e categoria
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subscription.category.displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Valor mensal
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormatter.format(subscription.monthlyPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Text(
                    '/month',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o ícone da categoria com fundo colorido por tipo
  Widget _buildCategoryIcon() {
    final (icon, color) = _getCategoryStyle(subscription.category);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  /// Retorna o par (ícone, cor) de acordo com a categoria
  (IconData, Color) _getCategoryStyle(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.streaming:
        return (Icons.play_circle_outline_rounded, AppTheme.accentBlue);
      case SubscriptionCategory.music:
        return (Icons.music_note_rounded, const Color(0xFF1DB954));
      case SubscriptionCategory.gaming:
        return (Icons.sports_esports_rounded, AppTheme.accentPurple);
      case SubscriptionCategory.fitness:
        return (Icons.fitness_center_rounded, const Color(0xFFFF6B35));
      case SubscriptionCategory.productivity:
        return (Icons.work_outline_rounded, AppTheme.accentCyan);
      case SubscriptionCategory.other:
        return (Icons.category_outlined, AppTheme.textSecondary);
    }
  }
}
