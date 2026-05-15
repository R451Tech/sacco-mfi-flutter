import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../providers/members_provider.dart';

class MemberFormScreen extends ConsumerStatefulWidget {
  final String? memberId;

  const MemberFormScreen({super.key, this.memberId});

  @override
  ConsumerState<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends ConsumerState<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _employerController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  final _kraPinController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.memberId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingMember();
      });
    }
  }

  Future<void> _loadExistingMember() async {
    await ref.read(memberDetailNotifierProvider.notifier).loadMember(widget.memberId!);
    final memberState = ref.read(memberDetailNotifierProvider);
    memberState.whenOrNull(
      data: (member) {
        if (member != null) {
          _firstNameController.text = member.firstName;
          _lastNameController.text = member.lastName;
          _idNumberController.text = member.idNumber;
          _phoneController.text = member.phone;
          _emailController.text = member.email;
          _occupationController.text = member.occupation ?? '';
          _employerController.text = member.employer ?? '';
          _monthlyIncomeController.text = member.monthlyIncome?.toString() ?? '';
          _kraPinController.text = member.kraPin ?? '';
          _addressController.text = member.address ?? '';
        }
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _employerController.dispose();
    _monthlyIncomeController.dispose();
    _kraPinController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'idNumber': _idNumberController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'occupation': _occupationController.text.trim(),
      'employer': _employerController.text.trim(),
      'kraPin': _kraPinController.text.trim(),
      'address': _addressController.text.trim(),
      if (_monthlyIncomeController.text.isNotEmpty)
        'monthlyIncome': double.parse(_monthlyIncomeController.text.trim()),
    };

    final notifier = ref.read(memberFormNotifierProvider.notifier);
    final future = widget.memberId != null
        ? notifier.updateMember(widget.memberId!, data)
        : notifier.createMember(data);

    future.then((_) {
      setState(() => _isLoading = false);
      final formState = ref.read(memberFormNotifierProvider);
      formState.whenOrNull(
        data: (_) {
          ref.invalidate(membersListNotifierProvider);
          context.pop();
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
    final isEditing = widget.memberId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Member' : 'Add Member'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (v) => Validators.required(v, 'First name'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (v) => Validators.required(v, 'Last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idNumberController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'ID Number'),
                validator: Validators.idNumber,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: Validators.email,
              ),
              const SizedBox(height: 24),
              Text(
                'Employment Details',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _occupationController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Occupation'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employerController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Employer'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _monthlyIncomeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Monthly Income',
                  prefixText: 'KES ',
                ),
                validator: (v) => v != null && v.isNotEmpty ? Validators.positiveNumber(v, 'Income') : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Other Information',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kraPinController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'KRA PIN'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                textInputAction: TextInputAction.done,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Address'),
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
                    : Text(isEditing ? 'Update Member' : 'Add Member'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
