import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../loans/screens/loans_list_screen.dart';
import '../../members/screens/members_list_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../savings/screens/savings_list_screen.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  final _screens = <Widget>[
    const _DashboardTab(),
    const MembersListScreen(),
    const SavingsListScreen(),
    const LoansListScreen(),
    const ReportsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardSummaryNotifierProvider.notifier).loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                user?.fullName.isNotEmpty == true
                    ? user!.fullName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authNotifierProvider.notifier).logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: Text(user?.fullName ?? 'User'),
                  subtitle: Text(user?.email ?? ''),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: AppColors.error),
                  title: Text('Logout', style: TextStyle(color: AppColors.error)),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Members',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings_rounded),
            label: 'Savings',
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on_outlined),
            selectedIcon: Icon(Icons.monetization_on_rounded),
            label: 'Loans',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0: return 'Dashboard';
      case 1: return 'Members';
      case 2: return 'Savings';
      case 3: return 'Loans';
      case 4: return 'Reports';
      default: return 'SACCO MFI';
    }
  }
}

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryState = ref.watch(dashboardSummaryNotifierProvider);

    return summaryState.when(
      loading: () => const AppLoadingPage(),
      error: (error, _) => AppError(
        message: error.toString(),
        onRetry: () => ref.read(dashboardSummaryNotifierProvider.notifier).loadSummary(),
      ),
      data: (summary) {
        if (summary == null) {
          return const AppLoadingPage();
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(dashboardSummaryNotifierProvider.notifier).loadSummary(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SummaryCard(
                      title: 'Total Members',
                      value: Formatters.number(summary.totalMembers),
                      icon: Icons.people_rounded,
                      color: AppColors.primary,
                    ),
                    SummaryCard(
                      title: 'Total Savings',
                      value: Formatters.currency(summary.totalSavings),
                      icon: Icons.savings_rounded,
                      color: AppColors.success,
                    ),
                    SummaryCard(
                      title: 'Active Loans',
                      value: Formatters.number(summary.activeLoans),
                      icon: Icons.monetization_on_rounded,
                      color: AppColors.accent,
                    ),
                    SummaryCard(
                      title: 'Loan Portfolio',
                      value: Formatters.currency(summary.totalLoanPortfolio),
                      icon: Icons.account_balance_rounded,
                      color: AppColors.info,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.person_add_rounded,
                      label: 'New Member',
                      color: AppColors.primary,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.add_card_rounded,
                      label: 'New Loan',
                      color: AppColors.accent,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.payments_rounded,
                      label: 'Deposit',
                      color: AppColors.success,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                RecentTransactions(transactions: const []),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
