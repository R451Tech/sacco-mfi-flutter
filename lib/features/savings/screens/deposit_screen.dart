import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../providers/savings_provider.dart';

class DepositScreen extends ConsumerStatefulWidget {
  final String accountId;

  const DepositScreen({super.key, required this.accountId});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final amount = double.parse(_amountController.text.trim());
    final notifier = ref.read(savingsTransactionNotifierProvider.notifier);
    notifier.deposit(
      widget.accountId,
      amount,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    ).then((_) {
      setState(() => _isLoading = false);
      final state = ref.read(savingsTransactionNotifierProvider);
      state.whenOrNull(
        data: (_) {
          ref.invalidate(savingsDetailNotifierProvider);
          ref.invalidate(savingsTransactionsNotifierProvider);
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Deposit successful'),
              backgroundColor: AppColors.success,
            ),
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: AppColors.error),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make Deposit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.add_circle_rounded,
                size: 64,
                color: AppColors.success.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: 'KES ',
                ),
                validator: Validators.amount,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                textInputAction: TextInputAction.done,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
