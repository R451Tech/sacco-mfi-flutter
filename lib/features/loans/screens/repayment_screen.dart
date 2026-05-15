import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../providers/loans_provider.dart';

class RepaymentScreen extends ConsumerStatefulWidget {
  final String loanId;

  const RepaymentScreen({super.key, required this.loanId});

  @override
  ConsumerState<RepaymentScreen> createState() => _RepaymentScreenState();
}

class _RepaymentScreenState extends ConsumerState<RepaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  String _paymentMethod = 'Cash';
  bool _isLoading = false;

  final _paymentMethods = ['Cash', 'MPesa', 'Bank Transfer', 'Cheque', 'Other'];

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final amount = double.parse(_amountController.text.trim());
    ref.read(loanRepayNotifierProvider.notifier).repay(
      widget.loanId,
      amount,
      paymentMethod: _paymentMethod,
      reference: _referenceController.text.trim().isEmpty
          ? null
          : _referenceController.text.trim(),
    ).then((_) {
      setState(() => _isLoading = false);
      final state = ref.read(loanRepayNotifierProvider);
      state.whenOrNull(
        data: (_) {
          ref.invalidate(loanDetailNotifierProvider);
          ref.invalidate(loanRepaymentsNotifierProvider);
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment successful'),
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
      appBar: AppBar(title: const Text('Make Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.payments_rounded,
                size: 64,
                color: AppColors.success.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: 'KES ',
                ),
                validator: Validators.amount,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: _paymentMethods
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenceController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Reference/Receipt No. (optional)',
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
                    : const Text('Make Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
