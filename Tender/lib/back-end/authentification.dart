import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

Future<User?> registerWithEmailPassword(String firstName, String lastName,
    String userName, String email, String password) async {
  final response = await _supabase.auth.signUp(
    email: email,
    password: password,
  );

  final user = response.user;

  // Supabase returns a fake user with empty identities when the email is
  // already registered but unconfirmed (email enumeration protection)
  if (user == null || (user.identities?.isEmpty ?? false)) {
    throw const AuthException(
        'This email is already registered. Check your inbox for a confirmation link, or try logging in.');
  }

  try {
    await _supabase.from('profiles').insert({
      'id': user.id,
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName.isNotEmpty
          ? userName
          : '${email.split('@')[0]}_${user.id.substring(0, 6)}',
      'email': email,
    });
  } catch (e) {
    print('Profile insert error (non-fatal): $e');
  }
  return user;
}

Future<User?> signInWithGoogle() async {
  const port = 8080;
  const redirectUrl = 'http://localhost:$port';

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

  await _supabase.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: redirectUrl,
  );

  final completer = Completer<User?>();

  late StreamSubscription<HttpRequest> sub;
  sub = server.listen((request) async {
    request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.html
      ..write(
          '<html><head><title>Recipeal</title></head><body>'
          '<p>Sign-in complete! You can close this tab.</p>'
          '<script>window.close();</script></body></html>');
    await request.response.close();
    await sub.cancel();
    await server.close();

    final code = request.uri.queryParameters['code'];
    if (code == null) {
      completer.complete(null);
      return;
    }

    try {
      final response = await _supabase.auth.exchangeCodeForSession(code);
      final user = response.session.user;

      final existing = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existing == null) {
        final meta = user.userMetadata ?? {};
        try {
          await _supabase.from('profiles').insert({
            'id': user.id,
            'first_name': meta['given_name'] ?? '',
            'last_name': meta['family_name'] ?? '',
            'user_name': (user.email ?? '').split('@')[0],
            'email': user.email ?? '',
          });
        } catch (_) {
          // Profile insert failed (e.g. username conflict) — non-fatal
        }
      }

      completer.complete(user);
    } catch (e) {
      completer.complete(null);
    }
  });

  return completer.future.timeout(
    const Duration(minutes: 5),
    onTimeout: () async {
      await server.close();
      return null;
    },
  );
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  final response = await _supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );
  return response.user;
}

Future<void> signOut() async {
  await _supabase.auth.signOut();
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
