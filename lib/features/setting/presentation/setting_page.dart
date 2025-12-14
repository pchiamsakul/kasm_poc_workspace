import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = false;
  bool _biometrics = true;

  String _languageLabel = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Row(
              children: [
                _IconCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: KColors.textDefaultColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const _SectionTitle('Preferences'),
            const SizedBox(height: 10),
            _SectionCard(
              children: [
                _ValueTile(
                  title: 'Language',
                  icon: Icons.language_outlined,
                  value: _languageLabel,
                  onTap: _openLanguageSheet,
                ),
                _SwitchTile(
                  title: 'Push notifications',
                  icon: Icons.notifications_none,
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                ),
                _SwitchTile(
                  title: 'Email updates',
                  icon: Icons.mark_email_unread_outlined,
                  value: _emailNotifications,
                  onChanged: (v) => setState(() => _emailNotifications = v),
                ),
                _SwitchTile(
                  title: 'Dark mode',
                  icon: Icons.dark_mode_outlined,
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const _SectionTitle('Security'),
            const SizedBox(height: 10),
            _SectionCard(
              children: [
                _SwitchTile(
                  title: 'Use biometrics',
                  icon: Icons.fingerprint,
                  value: _biometrics,
                  onChanged: (v) => setState(() => _biometrics = v),
                ),
                _NavigationTile(
                  title: 'Change password',
                  icon: Icons.lock_outline,
                  onTap: () {
                    // TODO: wire up change password flow
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            const _SectionTitle('Support'),
            const SizedBox(height: 10),
            _SectionCard(
              children: [
                _NavigationTile(
                  title: 'Help & support',
                  icon: Icons.help_outline,
                  onTap: () {
                    // TODO: open support
                  },
                ),
                _NavigationTile(
                  title: 'About',
                  icon: Icons.info_outline,
                  onTap: () {
                    // TODO: open about
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            _SectionCard(
              children: [
                _NavigationTile(
                  title: 'Log out',
                  icon: Icons.logout,
                  titleColor: KColors.red,
                  iconColor: KColors.red,
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

  Future<void> _openLanguageSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                _BottomSheetOption(
                  label: 'English',
                  selected: _languageLabel == 'English',
                  onTap: () => Navigator.of(ctx).pop('English'),
                ),
                _BottomSheetOption(
                  label: 'Thai',
                  selected: _languageLabel == 'Thai',
                  onTap: () => Navigator.of(ctx).pop('Thai'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() => _languageLabel = selected);
    }
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Icon(icon, size: 18, color: KColors.primaryDark2),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: KColors.darkGrey,
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

class _BaseTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget trailing;
  final bool showChevron;
  final Color? iconColor;
  final Color? titleColor;

  const _BaseTile({
    required this.title,
    required this.icon,
    required this.trailing,
    this.onTap,
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
              trailing,
              if (showChevron)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showChevron;
  final Color? iconColor;
  final Color? titleColor;

  const _NavigationTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.showChevron = true,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseTile(
      title: title,
      icon: icon,
      onTap: onTap,
      showChevron: showChevron,
      iconColor: iconColor,
      titleColor: titleColor,
      trailing: const SizedBox(width: 0, height: 0),
    );
  }
}

class _ValueTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _ValueTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseTile(
      title: title,
      icon: icon,
      onTap: onTap,
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseTile(
      title: title,
      icon: icon,
      showChevron: false,
      trailing: Transform.scale(
        scale: 0.9,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: KColors.primaryDark,
          activeTrackColor: KColors.primary50,
        ),
      ),
    );
  }
}

class _BottomSheetOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomSheetOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded, color: KColors.primaryDark),
            ],
          ),
        ),
      ),
    );
  }
}
