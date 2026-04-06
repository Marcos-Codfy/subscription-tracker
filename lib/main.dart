// Ponto de entrada principal do aplicativo Flutter.
// Inicializa o tema dark com a paleta de cores do design e injeta o provider de estado.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/subscriptions/presentation/providers/subscription_provider.dart';
import 'features/subscriptions/presentation/pages/home_page.dart';

void main() {
  runApp(const SubscriptionTrackerApp());
}

/// Widget raiz do aplicativo.
/// Configura o [MultiProvider] para injeção de dependência e o [MaterialApp] com tema dark.
class SubscriptionTrackerApp extends StatelessWidget {
  const SubscriptionTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Registra todos os providers de estado da aplicação
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: MaterialApp(
        title: 'Subscription Tracker',
        debugShowCheckedModeBanner: false,
        // Aplica o tema dark customizado baseado no design da imagem
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
