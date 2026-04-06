// Widget do header de total mensal.
// Exibe o valor total gasto por mês com card gradiente azul — inspirado no design de referência.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget de cabeçalho que exibe o total mensal de assinaturas.
///
/// Usa um card com gradiente azul para destaque visual, seguindo
/// o padrão de design da imagem de referência.
class TotalHeaderWidget extends StatelessWidget {
  /// Valor total mensal a ser exibido
  final double totalMonthly;

  /// Número total de assinaturas ativas
  final int count;

  const TotalHeaderWidget({
    super.key,
    required this.totalMonthly,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // Formatador de moeda brasileira
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Gradiente azul de destaque — igual ao design de referência
        gradient: AppTheme.blueGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rótulo superior
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MONTHLY TOTAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
              // Badge com o número de planos ativos
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count ${count == 1 ? 'plan' : 'plans'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Valor total em destaque
          Text(
            key: const Key('totalPriceText'),
            currencyFormatter.format(totalMonthly),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'per month',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 16),

          // Divisor sutil
          Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),

          const SizedBox(height: 16),

          // Estimativa anual
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white70,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'Annual: ${currencyFormatter.format(totalMonthly * 12)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
