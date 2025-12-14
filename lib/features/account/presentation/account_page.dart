import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/generated/assets.gen.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: KColors.textDefaultColor,
              ),
            ),
            const SizedBox(height: 16),
            _ProfileCard(
              name: 'Amanda',
              subtitle: 'View and manage your profile',
              onEdit: () {
                // TODO: wire navigation once profile flow exists
              },
            ),
            const SizedBox(height: 16),
            _QuickActionsRow(
              actions: [
                _QuickAction(
                  title: 'My bookings',
                  icon: Icons.confirmation_number_outlined,
                  onTap: () {
                    // TODO: navigate to bookings
                  },
                ),
                _QuickAction(
                  title: 'Saved',
                  icon: Icons.bookmark_border,
                  onTap: () {
                    // TODO: navigate to saved
                  },
                ),
                _QuickAction(
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  onTap: () {
                    getIt<AppNavigator>().pushNamed(RouterName.SettingPage);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SectionCard(
              children: [
                _MenuTile(title: 'Personal details', icon: Icons.person_outline, onTap: () {}),
                _MenuTile(title: 'Payment methods', icon: Icons.credit_card, onTap: () {}),
                _MenuTile(title: 'Notifications', icon: Icons.notifications_none, onTap: () {}),
              ],
            ),
            const SizedBox(height: 12),
            _SectionCard(
              children: [
                _MenuTile(title: 'Help & support', icon: Icons.help_outline, onTap: () {}),
                _MenuTile(title: 'About', icon: Icons.info_outline, onTap: () {}),
              ],
            ),
            const SizedBox(height: 12),
            _SectionCard(
              children: [
                _MenuTile(
                  title: 'Log out',
                  icon: Icons.logout,
                  iconColor: KColors.red,
                  titleColor: KColors.red,
                  showChevron: false,
                  onTap: () {
                    // TODO: logout flow
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'KASM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onEdit;

  const _ProfileCard({required this.name, required this.subtitle, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: KColors.primary50,
            child: ClipOval(
              child: Assets.images.placeholder.image(width: 48, height: 48, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $name!',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.black.withValues(alpha: 0.55)),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({required this.title, required this.icon, required this.onTap});
}

class _QuickActionsRow extends StatelessWidget {
  final List<_QuickAction> actions;

  const _QuickActionsRow({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: a == actions.last ? 0 : 10),
                child: _QuickActionCard(action: a),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: KColors.primary20,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: KColors.primaryDark2, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                action.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(children: _withDividers(children)),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) {
        out.add(Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)));
      }
    }
    return out;
  }
}

class _MenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showChevron;
  final Color? iconColor;
  final Color? titleColor;

  const _MenuTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.showChevron = true,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: KColors.primary20,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor ?? KColors.primaryDark2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor ?? KColors.darkGrey,
                  ),
                ),
              ),
              if (showChevron)
                Icon(Icons.chevron_right, color: Colors.black.withValues(alpha: 0.35)),
            ],
          ),
        ),
      ),
    );
  }
}
