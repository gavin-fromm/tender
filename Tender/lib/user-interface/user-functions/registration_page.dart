import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../back-end/authentification.dart';
import '../home_page.dart';

const _red = Color(0xFFE8120C);
const _bg = Color(0xFFFAF9F6);
const _textPrimary = Color(0xFF1C1917);
const _textSecondary = Color(0xFF78716C);

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRegister() async {
    setState(() => isLoading = true);

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showSnackBar('Please fill in all inputs', true);
      setState(() => isLoading = false);
      return;
    }
    if (!emailController.text.contains('@')) {
      showSnackBar('Please enter a valid email', true);
      setState(() => isLoading = false);
      return;
    }
    if (passwordController.text.length < 6) {
      showSnackBar('Password must be at least 6 characters', true);
      setState(() => isLoading = false);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showSnackBar('Passwords do not match', true);
      setState(() => isLoading = false);
      return;
    }

    try {
      final user = await registerWithEmailPassword(
        '',
        '',
        '',
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        final hasSession =
            Supabase.instance.client.auth.currentSession != null;
        if (hasSession) {
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomePage()),
              (route) => false,
            );
          }
        } else {
          showSnackBar(
              'Account created! Check your email to confirm before logging in.',
              false);
          if (context.mounted) Navigator.pop(context);
        }
      }
    } on AuthException catch (e) {
      showSnackBar(e.message, true);
    } catch (e) {
      showSnackBar('Connection failed. Check your internet connection.', true);
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _handleGoogle() async {
    setState(() => isLoading = true);
    try {
      final user = await signInWithGoogle();
      if (!context.mounted) return;
      if (user != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      } else {
        showSnackBar('Google sign-in failed or was cancelled.', true);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar('Google sign-in failed. Please try again.', true);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _red,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.30,
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'JOIN RECIPEAL',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Create your free account',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 14,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fill in your details below',
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 15,
                        color: _textSecondary,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: isHiddenPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outlined),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isHiddenPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () =>
                              setState(() => isHiddenPassword = !isHiddenPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: isHiddenConfirmPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outlined),
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isHiddenConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                              () => isHiddenConfirmPassword = !isHiddenConfirmPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleRegister,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text('CREATE ACCOUNT'),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: isLoading ? null : _handleGoogle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'G',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: _red,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Continue with Google'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
