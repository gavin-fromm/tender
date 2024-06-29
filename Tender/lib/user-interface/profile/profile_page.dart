import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_for_thought/back-end/authentification.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/user_class.dart';
import '../user-functions/login_page.dart';
import 'settings_page.dart';

const _red = Color(0xFFE8120C);
const _darkRed = Color(0xFF8B0000);
const _bg = Color(0xFFFAF9F6);
const _textPrimary = Color(0xFF1C1917);
const _textSecondary = Color(0xFF78716C);
const _borderColor = Color(0xFFE7E5E4);

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final MaterialBanner emptyInputMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please input a password',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );

  final MaterialBanner incorrectPassword = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Password',
      message: 'The password is incorrect',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );

  final user = Supabase.instance.client.auth.currentUser!;
  String uid = Supabase.instance.client.auth.currentUser!.id;
  final userEmail = Supabase.instance.client.auth.currentUser?.email;
  UserInformation? userInformation;
  bool _isLoading = true;
  TextEditingController passwordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    userInformation = await DatabaseService.getUser(uid);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _red,
          title: const Text('PROFILE', style: TextStyle(fontFamily: 'Oswald', letterSpacing: 2)),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: _red),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      backgroundColor: _red,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'PROFILE',
        style: TextStyle(fontFamily: 'Oswald', letterSpacing: 2, color: Colors.white, fontSize: 18),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_darkRed, _red],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 44),
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 42),
                ),
                const SizedBox(height: 12),
                Text(
                  '${userInformation?.firstName ?? ''} ${userInformation?.lastName ?? ''}',
                  style: const TextStyle(
                    fontFamily: 'Oswald',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '@${userInformation?.userName ?? ''}',
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    color: Colors.white.withValues(alpha: 0.80),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email card
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _red.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.email_outlined, color: _red, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EMAIL',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email ?? '',
                        style: const TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
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
            child: _settingsTile(
              Icons.settings_outlined,
              'Settings',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
            ),
          ),

          const SizedBox(height: 36),
          const Text(
            'DANGER ZONE',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFDC2626),
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmDeleteAccount(context),
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626)),
              label: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderColor),
        ),
        child: Icon(icon, color: _textPrimary, size: 19),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFB8B0B0)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure? All your data will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showPasswordDialog(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm with Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your password to confirm account deletion.'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordFieldController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined),
                hintText: 'Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (passwordFieldController.value.text.isEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentMaterialBanner()
                  ..showMaterialBanner(emptyInputMessage);
                Timer(const Duration(seconds: 2), () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner());
                return;
              }
              final signedInUser = await signInWithEmailPassword(
                userEmail.toString(),
                passwordFieldController.value.text,
              );
              if (signedInUser != null) {
                await deleteUser(uid);
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deleted')),
                  );
                }
              } else {
                passwordFieldController.clear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentMaterialBanner()
                    ..showMaterialBanner(incorrectPassword);
                  Timer(const Duration(seconds: 2), () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner());
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}
