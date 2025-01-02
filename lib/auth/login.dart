import 'package:flutter/material.dart';
import 'package:pet_care_scheduler/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await supabase.auth.signIn(
        email: email,
        password: password,
      );
      if (response.user != null) {
        // Successful login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${response.user!.email}')),
        );
        Navigator.of(context).pushNamed(Routes.home);
      }
    } catch (e) {
      // Handle login error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }


  @override
  void initState() {
    _emailController.text = 'usamasaleem14@gmail.com';
    _passwordController.text = 'osama1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(Routes.signup);
                },
                child: Text('Don\'t have an account? Sign up')
            ),


          ],
        ),
      ),
    );
  }
}
