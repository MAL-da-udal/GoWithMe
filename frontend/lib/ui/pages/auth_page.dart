import 'package:flutter/material.dart';
import 'package:go_with_me/data/functions/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool? isLogin;
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'mock.jwt.token');

    setState(() => isLoading = false);

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              if (isLogin != null) ...[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => setState(() => isLogin = null),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  Image.asset(
                    'assets/logo.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  if (isLogin == null) ...[
                    ElevatedButton(
                      onPressed: () => setState(() => isLogin = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLogin == true
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      child: const Text('Вход'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() => isLogin = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLogin == false
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      child: const Text('Регистрация'),
                    ),

                    const SizedBox(height: 20),
                  ],

                  if (isLogin != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Login',
                              ),
                              onSaved: (val) => email = val ?? '',
                              validator: (val) => validateLogin(val ?? ''),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              onSaved: (val) => password = val ?? '',
                              validator: (val) => validatePassword(val ?? ''),
                            ),
                            if (isLogin == false) ...[
                              const SizedBox(height: 20),
                              TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Retry password',
                                ),
                                onSaved: (val) => confirmPassword = val ?? '',
                                validator: (val) =>
                                    validatePasswordConfirmation(
                                      password,
                                      val ?? '',
                                    ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _submit,
                                    child: Text(
                                      isLogin! ? 'Log in' : 'Register',
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
