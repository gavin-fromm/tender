import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

const _red = Color(0xFFE8120C);
const _bg = Color(0xFFFAF9F6);
const _textPrimary = Color(0xFF1C1917);
const _textSecondary = Color(0xFF78716C);

class ForgotPasswordPage extends StatefulWidget {
  static String id = 'forgot-password';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<bool> passwordReset() async {
    try {
      await Supabase.instance.client.auth
          .resetPasswordForEmail(_emailController.text.trim());
      return true;
    } on AuthException {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _red,
      body: Column(
        children: [
          // Hero section
          SizedBox(
            height: size.height * 0.28,
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
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'RESET PASSWORD',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form card
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Enter your email address and we'll send you a reset link.",
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 15,
                        color: _textSecondary,
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() => isLoading = true);
                              if (_emailController.text.isEmpty) {
                                showSnackBar('Please enter an email!', true);
                                setState(() => isLoading = false);
                                return;
                              }
                              if (await passwordReset()) {
                                showSnackBar('Password reset email sent!', false);
                                Timer(
                                  const Duration(seconds: 2),
                                  () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginPage()),
                                    (route) => false,
                                  ),
                                );
                              } else {
                                showSnackBar(
                                    'Email not found. Please register first!', true);
                              }
                              setState(() => isLoading = false);
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text('SEND RESET EMAIL'),
                    ),
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
