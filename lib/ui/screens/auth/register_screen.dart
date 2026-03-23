import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/auth_provider.dart';
import 'package:aqar_morocco_mobile/core/localization/localizer.dart';
import 'package:aqar_morocco_mobile/ui/screens/home/home_screen.dart';
import 'package:aqar_morocco_mobile/ui/screens/auth/login_screen.dart';
import 'package:aqar_morocco_mobile/ui/screens/auth/role_selection_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoleSelectionScreen(
          onRolesSelected: (roles) async {
            final auth = context.read<AuthProvider>();
            final success = await auth.register(
              fullName: fullName,
              email: email,
              phone: phone,
              password: password,
              appRoles: roles,
            );

            if (success && mounted) {
              // Pop RoleSelection and then push Home
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(auth.errorMessage ?? context.l('register_error')),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  icon: const Icon(LucideIcons.chevronLeft, color: AppTheme.deepNavy),
                ),
                const SizedBox(height: 24),
                Text(
                  context.l('create_account'),
                  style: GoogleFonts.outfit(
                    fontSize: 36, 
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepNavy,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Inscrivez-vous pour accéder aux meilleures opportunités immobilières.',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: context.l('full_name'),
                    prefixIcon: const Icon(LucideIcons.user, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return context.l('name_required');
                    if (value.trim().length < 3) return context.l('min_3_chars');
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: context.l('email'),
                    prefixIcon: const Icon(LucideIcons.mail, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return context.l('email_required');
                    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                      return context.l('email_invalid');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: context.l('phone'),
                    hintText: '06XXXXXXXX',
                    prefixIcon: const Icon(LucideIcons.phone, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return context.l('phone_required');
                    if (!RegExp(r'^(\+212|0)[5-7][0-9]{8}$').hasMatch(value.trim())) {
                      return context.l('phone_invalid');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: context.l('password'),
                    prefixIcon: const Icon(LucideIcons.lock, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return context.l('password_required');
                    if (value.length < 8) return context.l('min_8_chars');
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: context.l('confirm_password'),
                    prefixIcon: const Icon(LucideIcons.shieldCheck, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? LucideIcons.eyeOff : LucideIcons.eye, size: 20),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return context.l('password_mismatch');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Register Button
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => ElevatedButton(
                    onPressed: auth.loading ? null : _handleRegister,
                    child: auth.loading
                      ? const SizedBox(
                          height: 24, 
                          width: 24, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : Text(context.l('register')),
                  ),
                ),
                const SizedBox(height: 32),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(color: Colors.grey.shade600, fontSize: 15),
                        children: [
                          TextSpan(text: context.l('already_account_link')),
                          TextSpan(
                            text: context.l('login_header'),
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
