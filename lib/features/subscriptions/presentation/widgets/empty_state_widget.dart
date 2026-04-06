// Widget de estado vazio — exibido quando não há assinaturas cadastradas.
// Orienta o usuário a adicionar a primeira assinatura.

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget exibido quando a lista de assinaturas está vazia.
///
/// Segue boas práticas de UX: sempre explica ao usuário o que fazer
/// quando não há conteúdo para exibir.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone ilustrativo com fundo gradiente
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.blueGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentBlue.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.subscriptions_outlined,
                color: Colors.white,
                size: 44,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'No Subscriptions Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Tap the button below to add your\nfirst subscription plan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 28),

            // Dica visual com seta apontando para baixo
            Icon(
              Icons.arrow_downward_rounded,
              color: AppTheme.accentBlue.withValues(alpha: 0.6),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
