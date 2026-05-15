import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/members/screens/members_list_screen.dart';
import '../../features/members/screens/member_detail_screen.dart';
import '../../features/members/screens/member_form_screen.dart';
import '../../features/savings/screens/savings_list_screen.dart';
import '../../features/savings/screens/savings_detail_screen.dart';
import '../../features/savings/screens/deposit_screen.dart';
import '../../features/savings/screens/withdrawal_screen.dart';
import '../../features/loans/screens/loans_list_screen.dart';
import '../../features/loans/screens/loan_detail_screen.dart';
import '../../features/loans/screens/apply_loan_screen.dart';
import '../../features/loans/screens/repayment_screen.dart';
import '../../features/reports/screens/reports_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: 'members',
              name: 'members',
              builder: (context, state) => const MembersListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'member-detail',
                  builder: (context, state) => MemberDetailScreen(
                    memberId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'member-edit',
                      builder: (context, state) => MemberFormScreen(
                        memberId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'add',
                  name: 'member-add',
                  builder: (context, state) => const MemberFormScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'savings',
              name: 'savings',
              builder: (context, state) => const SavingsListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'savings-detail',
                  builder: (context, state) => SavingsDetailScreen(
                    accountId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'deposit',
                      name: 'savings-deposit',
                      builder: (context, state) => DepositScreen(
                        accountId: state.pathParameters['id']!,
                      ),
                    ),
                    GoRoute(
                      path: 'withdraw',
                      name: 'savings-withdraw',
                      builder: (context, state) => WithdrawalScreen(
                        accountId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'loans',
              name: 'loans',
              builder: (context, state) => const LoansListScreen(),
              routes: [
                GoRoute(
                  path: 'apply',
                  name: 'loan-apply',
                  builder: (context, state) => const ApplyLoanScreen(),
                ),
                GoRoute(
                  path: ':id',
                  name: 'loan-detail',
                  builder: (context, state) => LoanDetailScreen(
                    loanId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'repay',
                      name: 'loan-repay',
                      builder: (context, state) => RepaymentScreen(
                        loanId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'reports',
              name: 'reports',
              builder: (context, state) => const ReportsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class DashboardShell extends StatelessWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
