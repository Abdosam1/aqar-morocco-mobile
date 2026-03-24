import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';

class RoleSelectionScreen extends StatefulWidget {
  final Function(List<String>) onRolesSelected;

  const RoleSelectionScreen({
    super.key,
    required this.onRolesSelected,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  // Group 1: Seekers (those looking for properties)
  final Map<String, RoleInfo> _seekerRoles = {
    'buyer': RoleInfo(
      title: 'Acheteur',
      titleAr: 'مشتري',
      description: 'Je souhaite acheter un bien immobilier',
      icon: LucideIcons.search,
    ),
    'tenant': RoleInfo(
      title: 'Locataire',
      titleAr: 'مستأجر',
      description: 'Je recherche un bien à louer',
      icon: LucideIcons.key,
    ),
  };

  // Group 2: Owners (those listing properties)
  final Map<String, RoleInfo> _ownerRoles = {
    'seller': RoleInfo(
      title: 'Vendeur',
      titleAr: 'بائع',
      description: 'Je souhaite vendre ma propriété',
      icon: LucideIcons.home,
    ),
    'landlord': RoleInfo(
      title: 'Bailleur',
      titleAr: 'مؤجر',
      description: 'Je souhaite mettre en location mon bien',
      icon: LucideIcons.userCheck,
    ),
    'agency': RoleInfo(
      title: 'Agence / Courtier',
      titleAr: 'وكالة / وسيط',
      description: 'Je gère plusieurs biens et prospects',
      icon: LucideIcons.briefcase,
    ),
  };

  final Set<String> _selectedRoles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Que souhaitez-vous\nfaire ?',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ماذا تريد أن تفعل؟',
                      style: GoogleFonts.notoSansArabic(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vous pouvez sélectionner plusieurs options.',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // GROUP 1: Seekers
                    _buildGroupHeader(
                      icon: LucideIcons.search,
                      title: 'Je cherche un bien',
                      titleAr: 'أبحث عن عقار',
                    ),
                    const SizedBox(height: 12),
                    ..._seekerRoles.entries.map((e) => _buildRoleCard(e.key, e.value)),

                    const SizedBox(height: 28),

                    // GROUP 2: Owners
                    _buildGroupHeader(
                      icon: LucideIcons.building,
                      title: 'Je propose un bien',
                      titleAr: 'أعرض عقاراً',
                    ),
                    const SizedBox(height: 12),
                    ..._ownerRoles.entries.map((e) => _buildRoleCard(e.key, e.value)),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Continue Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedRoles.isEmpty
                      ? null
                      : () => widget.onRolesSelected(_selectedRoles.toList()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryEmerald,
                    disabledBackgroundColor: AppTheme.cardDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continuer',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupHeader({required IconData icon, required String title, required String titleAr}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryEmerald.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryEmerald, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryEmerald,
              ),
            ),
            Text(
              titleAr,
              style: GoogleFonts.notoSansArabic(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard(String key, RoleInfo role) {
    final isSelected = _selectedRoles.contains(key);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedRoles.remove(key);
          } else {
            _selectedRoles.add(key);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryEmerald.withOpacity(0.15) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryEmerald : AppTheme.borderDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryEmerald.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                role.icon,
                color: isSelected ? AppTheme.primaryEmerald : AppTheme.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        role.title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        role.titleAr,
                        style: GoogleFonts.notoSansArabic(
                          fontSize: 12,
                          color: isSelected ? AppTheme.primaryEmerald : AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.description,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(LucideIcons.checkCircle, color: AppTheme.primaryEmerald, size: 22),
          ],
        ),
      ),
    );
  }
}

class RoleInfo {
  final String title;
  final String titleAr;
  final String description;
  final IconData icon;

  RoleInfo({
    required this.title,
    required this.titleAr,
    required this.description,
    required this.icon,
  });
}
