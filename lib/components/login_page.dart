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
      body: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
          child: Form(
            key: _formKey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen kullanıcı adınızı girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen şifrenizi girin';
                  }
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48.0),
                ),
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    setState(() => _isLoading = true);
                    
                    // Kullanıcıyı kontrol et
                    final isLoggedIn = await LocalStorageService.loginUser(
                      nameController.text,
                      passwordController.text,
                    );

                    if (!mounted) return;

                    setState(() => _isLoading = false);
                    
                    if (isLoggedIn) {
                      // Kimlik bilgilerini kaydet
                      await LocalStorageService.saveLoginCredentials(
                        nameController.text,
                        passwordController.text,
                      );

                      if (!mounted) return;

                      // Navigation öncesi kısa gecikme
                      await Future.delayed(const Duration(milliseconds: 300));
                      
                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context, // ignore: use_build_context_synchronously
                        MaterialPageRoute(builder: (context) => MainPage(username: nameController.text)),
                      );
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
                        const SnackBar(
                          content: Text('Kullanıcı adı veya şifre yanlış!'),
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Giriş Yap'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationPage()),
                  );
                },
                child: const Text('Hesabınız yok mu? Kayıt olun'),
              )
            ],
          ),
          ),
        ),
      ),
    );
  }
}