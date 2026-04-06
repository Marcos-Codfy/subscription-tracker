// Tela principal do aplicativo — exibe o header com total mensal,
// a lista de assinaturas e o botão para adicionar nova.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/total_header_widget.dart';
import '../widgets/subscription_list_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'add_subscription_page.dart';

/// Página inicial que orquestra todos os widgets da tela principal.
///
/// Usa [Consumer] para reagir às mudanças do [SubscriptionProvider].
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── App Bar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'My ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
              TextSpan(
                text: 'Subscriptions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Ícone de carrinho no canto superior direito (visual, como no design)
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D27),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 22),
              onPressed: () {},
              tooltip: 'Carrinho',
            ),
          ),
        ],
      ),

      // ── Corpo Principal ───────────────────────────────────────────────────
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, _) {
          // Exibe feedback de erro via SnackBar quando necessário
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.status == SubscriptionStatus.error &&
                provider.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provider.errorMessage!)),
              );
              provider.resetStatus();
            }
          });

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Espaço superior
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // Header com o total mensal e resumo
              SliverToBoxAdapter(
                child: TotalHeaderWidget(
                  totalMonthly: provider.totalMonthlyPrice,
                  count: provider.subscriptions.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Título da seção de lista
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Active Plans',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge com o número de assinaturas
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2979FF).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${provider.subscriptions.length}',
                          style: const TextStyle(
                            color: Color(0xFF2979FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Lista ou estado vazio
              if (provider.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(),
                )
              else
                SubscriptionListWidget(
                  subscriptions: provider.subscriptions,
                  onDelete: provider.deleteSubscription,
                ),

              // Espaço para o FAB não cobrir o último item
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),

      // ── Botão de Adicionar ────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddPage(context),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Plan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2979FF),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_rounded),
            label: 'Saved',
          ),
        ],
      ),
    );
  }

  /// Navega para a tela de adicionar assinatura.
  void _navigateToAddPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const AddSubscriptionPage(),
        // Animação de slide de baixo para cima — estilo moderno
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
