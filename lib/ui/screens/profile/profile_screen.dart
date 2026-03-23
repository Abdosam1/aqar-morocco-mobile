import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/auth_provider.dart';
import 'package:aqar_morocco_mobile/ui/screens/dashboard/buyer_dashboard.dart';
import 'package:aqar_morocco_mobile/ui/screens/dashboard/seller_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _activeRole;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null && user['app_roles'] != null && (user['app_roles'] as List).isNotEmpty) {
      _activeRole = (user['app_roles'] as List).first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) {
      return Center(child: Text(context.l('please_login')));
    }

    final roles = (user['app_roles'] as List?)?.cast<String>() ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(context.l('my_profile'), style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildUserInfoHeader(user),
          const Divider(height: 1),
          _buildLanguageSwitcher(),
          const Divider(height: 1),
          if (roles.length > 1) _buildRoleSwitcher(roles),
          Expanded(
            child: _buildDashboardContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoHeader(Map<String, dynamic> user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              user['full_name']?[0] ?? 'U',
              style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['full_name'] ?? context.l('guest'),
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  user['email'] ?? '',
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                if (user['is_verified'] == true)
                  Row(
                    children: [
                      const Icon(LucideIcons.shieldCheck, size: 16, color: AppTheme.secondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        context.l('verified_acc'),
                        style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.secondaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      const Icon(LucideIcons.shieldAlert, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        context.l('unverified_acc'),
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.logOut, color: Colors.red),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    final localeProvider = context.watch<LocaleProvider>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Langue / اللغة',
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLangButton('Français', const Locale('fr'), localeProvider),
              const SizedBox(width: 12),
              _buildLangButton('العربية', const Locale('ar'), localeProvider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLangButton(String label, Locale locale, LocaleProvider provider) {
    final isSelected = provider.locale.languageCode == locale.languageCode;
    return GestureDetector(
      onTap: () => provider.setLocale(locale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.transparent),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSwitcher(List<String> roles) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: roles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final role = roles[index];
          final isSelected = _activeRole == role;
          return GestureDetector(
            onTap: () => setState(() => _activeRole = role),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  _getRoleLabel(role),
                  style: GoogleFonts.outfit(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardContent() {
    switch (_activeRole) {
      case 'buyer':
      case 'tenant':
        return const BuyerDashboard();
      case 'seller':
      case 'landlord':
        return const SellerDashboard();
      case 'agency':
        return const SellerDashboard(); // Placeholder for now
      default:
        return const BuyerDashboard();
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'buyer': return context.l('buy_role');
      case 'tenant': return context.l('rent_role');
      case 'seller': return context.l('sell_role');
      case 'landlord': return context.l('lease_role');
      case 'agency': return context.l('agency_role');
      default: return role;
    }
  }
}
