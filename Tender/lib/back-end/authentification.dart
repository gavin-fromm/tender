import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _supabase = Supabase.instance.client;

Future<User?> registerWithEmailPassword(String firstName, String lastName,
    String userName, String email, String password) async {
  try {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      await _supabase.from('profiles').insert({
        'id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'user_name': userName,
        'email': email,
      });
    }
    return user;
  } on AuthException catch (e) {
    print('Registration error: ${e.message}');
    return null;
  } catch (e) {
    print('Registration error: $e');
    return null;
  }
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  try {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }
    return user;
  } on AuthException catch (e) {
    print('Login error: ${e.message}');
    return null;
  }
}

Future<String> signOut() async {
  await _supabase.auth.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);
  return 'User signed out';
}

Future<void> deleteUser(String uid) async {
  await _supabase.rpc('delete_user');
}

Future<void> updateUserEmail(String email, String uid) async {
  await _supabase.from('profiles').update({'email': email}).eq('id', uid);
}

Future<void> updateUsername(String uname, String uid) async {
  await _supabase.from('profiles').update({'user_name': uname}).eq('id', uid);
}

Future<void> updateName(String fName, String lName, String uid) async {
  await _supabase.from('profiles').update({
    'first_name': fName,
    'last_name': lName,
  }).eq('id', uid);
}
