import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../providers/loans_provider.dart';

class ApplyLoanScreen extends ConsumerStatefulWidget {
  const ApplyLoanScreen({super.key});

  @override
  ConsumerState<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends ConsumerState<ApplyLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _memberIdController = TextEditingController();
  final _principalController = TextEditingController();
  final _termController = TextEditingController();
  final _purposeController = TextEditingController();
  final _collateralController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedProduct = 'Normal Loan';
  bool _isLoading = false;

  final _loanProducts = [
    'Normal Loan',
    'Emergency Loan',
    'Business Loan',
    'Development Loan',
    'Education Loan',
  ];

  @override
  void dispose() {
    _memberIdController.dispose();
    _principalController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    _collateralController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = {
      'memberId': _memberIdController.text.trim(),
      'loanProduct': _selectedProduct,
      'principal': double.parse(_principalController.text.trim()),
      'termMonths': int.parse(_termController.text.trim()),
      'purpose': _purposeController.text.trim(),
      if (_collateralController.text.isNotEmpty)
        'collateral': _collateralController.text.trim(),
      if (_notesController.text.isNotEmpty)
        'notes': _notesController.text.trim(),
    };

    ref.read(loanApplyNotifierProvider.notifier).applyLoan(data).then((_) {
      setState(() => _isLoading = false);
      final state = ref.read(loanApplyNotifierProvider);
      state.whenOrNull(
        data: (_) {
          ref.invalidate(loansListNotifierProvider);
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loan application submitted successfully'),
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
      appBar: AppBar(title: const Text('Apply for Loan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _memberIdController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Member ID',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                validator: (v) => Validators.required(v, 'Member ID'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedProduct,
                decoration: const InputDecoration(
                  labelText: 'Loan Product',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _loanProducts.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _selectedProduct = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _principalController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Principal Amount',
                  prefixText: 'KES ',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                validator: Validators.amount,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _termController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Term (Months)',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (v) => Validators.positiveNumber(v, 'Term'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                textInputAction: TextInputAction.next,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Purpose of Loan',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (v) => Validators.required(v, 'Purpose'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _collateralController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Collateral (optional)',
                  prefixIcon: Icon(Icons.security_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (optional)',
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
