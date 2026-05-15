import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/members_provider.dart';
import '../widgets/member_card.dart';

class MembersListScreen extends ConsumerStatefulWidget {
  const MembersListScreen({super.key});

  @override
  ConsumerState<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends ConsumerState<MembersListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(membersListNotifierProvider.notifier).loadMembers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersState = ref.watch(membersListNotifierProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search members...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(membersListNotifierProvider.notifier).loadMembers();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {});
              ref.read(membersListNotifierProvider.notifier).loadMembers(search: value);
            },
          ),
        ),
        Expanded(
          child: membersState.when(
            loading: () => const AppLoadingPage(),
            error: (error, _) => AppError(
              message: error.toString(),
              onRetry: () => ref.read(membersListNotifierProvider.notifier).loadMembers(),
            ),
            data: (members) {
              if (members.isEmpty) {
                return const EmptyState(
                  icon: Icons.people_outlined,
                  title: 'No members found',
                  subtitle: 'Add your first member to get started',
                  actionLabel: 'Add Member',
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(membersListNotifierProvider.notifier).loadMembers(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  itemCount: members.length,
                  itemBuilder: (context, index) => MemberCard(
                    member: members[index],
                    onTap: () => context.go('/dashboard/members/${members[index].id}'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
