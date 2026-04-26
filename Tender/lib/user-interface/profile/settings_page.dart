import 'package:flutter/material.dart';
import 'change_email_page.dart';
import 'change_name_page.dart';
import 'change_password_page.dart';
import 'change_username_page.dart';

const _red = Color(0xFFE8120C);
const _textPrimary = Color(0xFF1C1917);
const _textSecondary = Color(0xFF78716C);
const _bg = Color(0xFFFAF9F6);
const _borderColor = Color(0xFFE7E5E4);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('SETTINGS'),
        backgroundColor: _red,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
        children: [
          const Text(
            'ACCOUNT',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _textSecondary,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _tile(
                  context,
                  Icons.mail_outline_rounded,
                  'Change Email',
                  'Update your email address',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeEmailPage())),
                ),
                _divider(),
                _tile(
                  context,
                  Icons.alternate_email_rounded,
                  'Change Username',
                  'Pick a new handle',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeUsernamePage())),
                ),
                _divider(),
                _tile(
                  context,
                  Icons.badge_outlined,
                  'Change Name',
                  'Update your display name',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeNamePage())),
                ),
                _divider(),
                _tile(
                  context,
                  Icons.lock_outline_rounded,
                  'Change Password',
                  'Keep your account secure',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordPage())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: _red, size: 19),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: _textSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFB8B0B0)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, indent: 68, endIndent: 16, color: _borderColor);
}
