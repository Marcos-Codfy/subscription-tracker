// Tela de adição de nova assinatura.
// Contém o formulário com validação e os campos de entrada.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/subscription.dart';
import '../providers/subscription_provider.dart';
import '../../../../core/theme/app_theme.dart';

/// Tela de formulário para adicionar ou editar uma assinatura.
///
/// Recebe uma [subscription] opcional — se fornecida, entra em modo de edição.
class AddSubscriptionPage extends StatefulWidget {
  /// Assinatura para editar (null = modo de criação)
  final Subscription? subscription;

  const AddSubscriptionPage({super.key, this.subscription});

  /// Retorna true se estamos editando uma assinatura existente
  bool get isEditing => subscription != null;

  @override
  State<AddSubscriptionPage> createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  // Chave global do formulário para validação
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para os campos
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  // Categoria selecionada pelo usuário
  late SubscriptionCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Pré-preenche os campos se estiver editando
    _nameController = TextEditingController(
      text: widget.subscription?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.subscription?.monthlyPrice.toStringAsFixed(2) ?? '',
    );
    _selectedCategory =
        widget.subscription?.category ?? SubscriptionCategory.streaming;
  }

  @override
  void dispose() {
    // Libera os controladores para evitar memory leak
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Plan' : 'Add New Plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Campo: Nome do Serviço ──────────────────────────────────
              _buildSectionLabel('Service Name'),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('nameField'),
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'ex: Netflix, Spotify...',
                  prefixIcon: Icon(Icons.subscriptions_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome do serviço';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ── Campo: Valor Mensal ─────────────────────────────────────
              _buildSectionLabel('Monthly Price (R\$)'),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('priceField'),
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Permite apenas números e ponto/vírgula decimal
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  hintText: 'ex: 39.90',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o valor mensal';
                  }
                  // Normaliza vírgula para ponto antes de parsear
                  final normalized = value.replaceAll(',', '.');
                  final price = double.tryParse(normalized);
                  if (price == null || price <= 0) {
                    return 'Digite um valor válido maior que zero';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ── Seletor de Categoria ────────────────────────────────────
              _buildSectionLabel('Category'),
              const SizedBox(height: 12),
              _buildCategorySelector(),

              const SizedBox(height: 40),

              // ── Botão de Salvar ─────────────────────────────────────────
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o rótulo de seção padronizado
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  /// Constrói o seletor visual de categorias em grade
  Widget _buildCategorySelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: SubscriptionCategory.values.length,
      itemBuilder: (context, index) {
        final category = SubscriptionCategory.values[index];
        final isSelected = category == _selectedCategory;

        return GestureDetector(
          key: Key('category_${category.name}'),
          onTap: () => setState(() => _selectedCategory = category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: isSelected ? AppTheme.blueGradient : null,
              color: isSelected ? null : AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : AppTheme.textDisabled.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  category.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Constrói o botão de salvar com estilo gradiente
  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppTheme.blueGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentBlue.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          key: const Key('saveButton'),
          onPressed: () => _onSave(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isEditing ? 'Save Changes' : 'Add Subscription',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Valida o formulário e salva a assinatura no provider
  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SubscriptionProvider>();
    final name = _nameController.text.trim();
    final priceText = _priceController.text.replaceAll(',', '.');
    final price = double.parse(priceText);

    if (widget.isEditing) {
      // Modo de edição: atualiza a assinatura existente
      final updated = widget.subscription!.copyWith(
        name: name,
        monthlyPrice: price,
        category: _selectedCategory,
      );
      provider.updateSubscription(updated);
    } else {
      // Modo de criação: adiciona nova assinatura
      provider.addSubscription(
        name: name,
        monthlyPrice: price,
        category: _selectedCategory,
      );
    }

    Navigator.of(context).pop();
  }

  /// Retorna o ícone correspondente à categoria
  IconData _getCategoryIcon(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.streaming:
        return Icons.play_circle_outline_rounded;
      case SubscriptionCategory.music:
        return Icons.music_note_rounded;
      case SubscriptionCategory.gaming:
        return Icons.sports_esports_rounded;
      case SubscriptionCategory.fitness:
        return Icons.fitness_center_rounded;
      case SubscriptionCategory.productivity:
        return Icons.work_outline_rounded;
      case SubscriptionCategory.other:
        return Icons.category_outlined;
    }
  }
}
