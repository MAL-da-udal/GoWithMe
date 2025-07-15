import 'package:flutter/material.dart';
import 'package:go_with_me/data/functions/validations.dart';
import 'package:go_router/go_router.dart';
import 'package:go_with_me/domain/services/app_services.dart';
import 'package:go_with_me/ui/theme/app_colors.dart';
import 'package:go_with_me/ui/widgets/icon_back.dart';

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

    try {
      if (isLogin == true) {
        await authRepository.login(
          nameComtroller.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        await authRepository.register(
          nameComtroller.text.trim(),
          passwordController.text.trim(),
        );
      }
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
                    IconBack(
                      callback: () {
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
                    'assets/images/logo.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  if (isLogin == null) ...[
                    ElevatedButton(
                      onPressed: () => setState(() => isLogin = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      child: Text('Login'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() => isLogin = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: Text('Register'),
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
                              decoration: InputDecoration(labelText: 'Login'),
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
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isLogin == true
                                          ? AppColors.primary
                                          : null,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 16,
                                      ),
                                    ),
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
