// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/screens/dashboards/resident_dashboard.dart';
import 'package:smart_dhaka_app/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _selectedUserType = 'Resident'; // Default user type
  final _authService = AuthService();
  final _secureStorage = const FlutterSecureStorage();

  final List<String> _userTypes = ['Admin', 'Service Holder', 'Authority', 'Resident'];

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final role = await _authService.validateToken();

    if (role != null) {
      switch (role) {
        case 'Resident':
          Navigator.of(context).pushReplacementNamed('/resident-dashboard');
          break;
        case 'Admin':
          Navigator.of(context).pushReplacementNamed('/admin-dashboard');
          break;
        case 'ServiceHolder':
          Navigator.of(context).pushReplacementNamed('/service-holder-dashboard');
          break;
        case 'Authority':
          Navigator.of(context).pushReplacementNamed('/government-authority-dashboard');
          break;
        default:
          Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Smart Dhaka',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'User Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedUserType,
                  items: _userTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedUserType = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/register'),
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Await the login method to get the role and token
        final Map<String, dynamic>? loginResponse =
            await _authService.login(_email, _password, _selectedUserType);

        if (loginResponse != null) {
          final String role = loginResponse['role'];
          final String token = loginResponse['token'];

          // Save the token securely
          await _secureStorage.write(key: 'authToken', value: token);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );

          // Navigate based on the role
          switch (role) {
            case 'Resident':
              Navigator.of(context).pushReplacementNamed('/resident-dashboard');
              break;
            case 'Admin':
              Navigator.of(context).pushReplacementNamed('/admin-dashboard');
              break;
            case 'ServiceHolder':
              Navigator.of(context).pushReplacementNamed('/service-holder-dashboard');
              break;
            case 'Authority':
              Navigator.of(context).pushReplacementNamed('/government-authority-dashboard');
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Role not recognized: $role')),
              );
          }
        } else {
          // Show error if loginResponse is null
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
          );
        }
      } catch (error) {
        // Handle exceptions and show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $error')),
        );
      }
    }
  }
}

