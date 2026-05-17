import 'package:flutter/material.dart';
import '../services/local_storage_services.dart';
import '../main_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await LocalStorageService.getLoginCredentials();
    if (mounted) {
      setState(() {
        if (credentials['username'] != null) {
          nameController.text = credentials['username']!;
        }
        if (credentials['password'] != null) {
          passwordController.text = credentials['password']!;
        }
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.storefront,
                        size: 72,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12.0),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 18.0,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Kullanıcı Adı',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Lütfen kullanıcı adınızı girin';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12.0),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Şifre',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Lütfen şifrenizi girin';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                ),
                                const SizedBox(height: 12.0),
                                CheckboxListTile(
                                  tristate: true,
                                  contentPadding: EdgeInsets.zero,
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v ?? false),
                                  title: const Text('Beni hatırla'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                const SizedBox(height: 6.0),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final currentContext = context;
                                      final isValid =
                                          _formKey.currentState?.validate() ??
                                          false;
                                      if (!isValid) return;
                                      setState(() => _isLoading = true);

                                      final isLoggedIn =
                                          await LocalStorageService.loginUser(
                                            nameController.text,
                                            passwordController.text,
                                          );

                                      if (!mounted) return;

                                      setState(() => _isLoading = false);

                                      if (isLoggedIn) {
                                        await LocalStorageService.saveLoginCredentials(
                                          nameController.text,
                                          passwordController.text,
                                        );

                                        await Future.delayed(
                                          const Duration(milliseconds: 300),
                                        );
                                        if (!currentContext.mounted) return;
                                        Navigator.pushReplacement(
                                          currentContext,
                                          MaterialPageRoute(
                                            builder: (_) => MainPage(
                                              username: nameController.text,
                                            ),
                                          ),
                                        );
                                      } else {
                                        if (currentContext.mounted) {
                                          ScaffoldMessenger.of(
                                            currentContext,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Kullanıcı adı veya şifre yanlış!',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text('Giriş Yap'),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Hesabınız yok mu? Kayıt olun',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
