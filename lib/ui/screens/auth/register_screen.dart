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

  InputDecoration _inputDecoration({required String label, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.outfit(color: AppTheme.textSecondary, fontSize: 14),
      prefixIcon: Icon(icon, size: 20, color: AppTheme.textSecondary),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppTheme.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppTheme.primaryEmerald, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  context.l('create_account'),
                  style: GoogleFonts.outfit(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'إنشاء حساب جديد',
                  style: GoogleFonts.notoSansArabic(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inscrivez-vous pour accéder aux meilleures opportunités immobilières.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: _inputDecoration(label: context.l('full_name'), icon: LucideIcons.user),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return context.l('name_required');
                    if (value.trim().length < 3) return context.l('min_3_chars');
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: _inputDecoration(label: context.l('email'), icon: LucideIcons.mail),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return context.l('email_required');
                    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                      return context.l('email_invalid');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: _inputDecoration(label: context.l('phone'), icon: LucideIcons.phone),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return context.l('phone_required');
                    if (!RegExp(r'^(\+212|0)[5-7][0-9]{8}$').hasMatch(value.trim())) {
                      return context.l('phone_invalid');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: _inputDecoration(
                    label: context.l('password'),
                    icon: LucideIcons.lock,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return context.l('password_required');
                    if (value.length < 8) return context.l('min_8_chars');
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: _inputDecoration(
                    label: context.l('confirm_password'),
                    icon: LucideIcons.shieldCheck,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirm ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
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
                const SizedBox(height: 32),

                // Register Button
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: auth.loading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryEmerald,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: auth.loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              context.l('register'),
                              style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(color: AppTheme.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(text: context.l('already_account_link')),
                          TextSpan(
                            text: context.l('login_header'),
                            style: const TextStyle(
                              color: AppTheme.primaryEmerald,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
