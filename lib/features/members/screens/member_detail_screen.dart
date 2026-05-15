import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../providers/members_provider.dart';

class MemberDetailScreen extends ConsumerStatefulWidget {
  final String memberId;

  const MemberDetailScreen({super.key, required this.memberId});

  @override
  ConsumerState<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends ConsumerState<MemberDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memberDetailNotifierProvider.notifier).loadMember(widget.memberId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(memberDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go('/dashboard/members/${widget.memberId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outlined, color: AppColors.error),
            onPressed: () => _confirmDelete(),
          ),
        ],
      ),
      body: memberState.when(
        loading: () => const AppLoadingPage(),
        error: (error, _) => AppError(
          message: error.toString(),
          onRetry: () => ref.read(memberDetailNotifierProvider.notifier).loadMember(widget.memberId),
        ),
        data: (member) {
          if (member == null) {
            return const AppError(message: 'Member not found');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          '${member.firstName[0]}${member.lastName[0]}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        member.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (member.status != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: member.status == 'active'
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            member.status!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: member.status == 'active'
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _InfoSection(title: 'Personal Information', children: [
                  _InfoRow(label: 'ID Number', value: member.idNumber),
                  _InfoRow(label: 'Phone', value: member.phone),
                  _InfoRow(label: 'Email', value: member.email),
                  if (member.dateOfBirth != null)
                    _InfoRow(label: 'Date of Birth', value: Formatters.date(member.dateOfBirth!)),
                  if (member.gender != null)
                    _InfoRow(label: 'Gender', value: member.gender!),
                ]),
                const SizedBox(height: 16),
                _InfoSection(title: 'Employment', children: [
                  if (member.occupation != null)
                    _InfoRow(label: 'Occupation', value: member.occupation!),
                  if (member.employer != null)
                    _InfoRow(label: 'Employer', value: member.employer!),
                  if (member.monthlyIncome != null)
                    _InfoRow(label: 'Monthly Income', value: Formatters.currency(member.monthlyIncome!)),
                ]),
                const SizedBox(height: 16),
                _InfoSection(title: 'Other Details', children: [
                  if (member.kraPin != null)
                    _InfoRow(label: 'KRA PIN', value: member.kraPin!),
                  if (member.address != null)
                    _InfoRow(label: 'Address', value: member.address!),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Are you sure you want to delete this member? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              ref.read(membersListNotifierProvider.notifier).deleteMember(widget.memberId);
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
