import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/user_class.dart';
import 'package:food_for_thought/user-interface/side-menu/pinned_recipes_page.dart';
import 'package:food_for_thought/user-interface/profile/profile_page.dart';
import 'package:food_for_thought/user-interface/side-menu/created_recipes_page.dart';
import 'package:food_for_thought/user-interface/side-menu/liked_recipes_page.dart';
import '../../back-end/authentification.dart';
import '../user-functions/login_page.dart';
import 'public_created_recipes_page.dart';

const _red = Color(0xFFE8120C);
const _darkRed = Color(0xFF8B0000);
const _textPrimary = Color(0xFF1C1917);
const _bg = Color(0xFFFAF9F6);

class NavDrawer extends StatefulWidget {
  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String uid = Supabase.instance.client.auth.currentUser!.id;
  bool loading = true;
  UserInformation? userInformation;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    userInformation = await DatabaseService.getUser(uid);
    setState(() => loading = false);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Confirm Logout',
          style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(NavDrawer.logOutMessage);
              }
            },
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _bg,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _menuItem(
                  context,
                  Icons.person_rounded,
                  'User Details',
                  const Color(0xFF3B82F6),
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())),
                ),
                _menuItem(
                  context,
                  Icons.favorite_rounded,
                  'Liked Recipes',
                  _red,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewSavedRecipesPage())),
                ),
                _menuItem(
                  context,
                  Icons.push_pin_rounded,
                  'Pinned Recipes',
                  const Color(0xFFF59E0B),
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewPinnedRecipesPage())),
                ),
                _menuItem(
                  context,
                  Icons.edit_note_rounded,
                  'Created Recipes',
                  const Color(0xFF16A34A),
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreatedRecipesPage())),
                ),
                _menuItem(
                  context,
                  Icons.verified_rounded,
                  'My Public Recipes',
                  const Color(0xFF3B82F6),
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => PublicCreatedRecipesPage())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 24,
        left: 20,
        right: 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_darkRed, _red],
        ),
      ),
      child: loading
          ? const SizedBox(
              height: 60,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${userInformation?.firstName ?? ''} ${userInformation?.lastName ?? ''}',
                        style: const TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${userInformation?.userName ?? ''}',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          color: Colors.white.withValues(alpha: 0.80),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded),
                  color: Colors.white,
                  iconSize: 26,
                  tooltip: 'Logout',
                ),
              ],
            ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
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
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFB8B0B0), size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
