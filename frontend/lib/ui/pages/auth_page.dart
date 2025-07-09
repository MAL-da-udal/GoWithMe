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
  final nameComtroller = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool isObscured = true;
  bool isObscuredConfirm = true;

  @override
  void initState() {
    super.initState();
  }

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

  void clearControllers() {
    nameComtroller.clear();
    passwordController.clear();
    confirmPasswordController.clear();
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
                      onPressed: () {
                        clearControllers();
                        setState(() => isLogin = null);
                        isObscured = true;
                        isObscuredConfirm = true;
                      },
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
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() => isLogin = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLogin == false
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      child: const Text('Register'),
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
                              controller: nameComtroller,
                              decoration: const InputDecoration(
                                labelText: 'Login',
                              ),
                              validator: (val) => validateLogin(val ?? ''),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: isObscured,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isObscured = !isObscured;
                                    });
                                  },
                                ),
                                labelText: 'Password',
                              ),
                              validator: (val) => validatePassword(val ?? ''),
                            ),
                            if (isLogin == false) ...[
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: isObscuredConfirm,
                                decoration: InputDecoration(
                                  labelText: 'Retry password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isObscuredConfirm
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isObscuredConfirm = !isObscuredConfirm;
                                      });
                                    },
                                  ),
                                ),
                                validator: (val) =>
                                    validatePasswordConfirmation(
                                      passwordController.text,
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
