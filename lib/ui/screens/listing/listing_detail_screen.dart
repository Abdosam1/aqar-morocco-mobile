import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/data/models/listing_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aqar_morocco_mobile/ui/widgets/visit_request_modal.dart';
import 'package:aqar_morocco_mobile/ui/widgets/lead_qualification_modal.dart';
import 'package:aqar_morocco_mobile/ui/widgets/verification_badge.dart';
import 'package:aqar_morocco_mobile/core/localization/localizer.dart';
import 'package:provider/provider.dart';
import 'package:aqar_morocco_mobile/providers/auth_provider.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;
  const ListingDetailScreen({super.key, required this.listing});

  void _launchWhatsApp() async {
    final phone = listing.whatsappContact ?? listing.phoneContact ?? '212';
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent("Salam, je suis intéressé par votre annonce: ${listing.title}")}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceStr = '${listing.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MAD';

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Image Header
              SliverAppBar(
                expandedHeight: 450,
                pinned: true,
                stretch: true,
                backgroundColor: AppTheme.darkBackground,
                elevation: 0,
                leadingWidth: 70,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: IconButton(
                        icon: const Icon(LucideIcons.chevronLeft, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: IconButton(
                        icon: const Icon(LucideIcons.heart, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: listing.images.isNotEmpty ? listing.images.first : 'https://via.placeholder.com/800x600',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.5, 1.0],
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              AppTheme.darkBackground,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 150),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Verification
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                listing.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            if (listing.isVerified) ...[
                              const SizedBox(width: 8),
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: VerificationBadge(size: 24),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Price
                        Text(
                          priceStr,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryEmerald,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Location
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 16, color: AppTheme.textSecondary),
                            const SizedBox(width: 8),
                            Text(
                              'Maroc, ${listing.city ?? "Casablanca"}',
                              style: GoogleFonts.outfit(
                                color: AppTheme.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                        
                        // Features Row (Glass Style)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FeatureCard(icon: LucideIcons.maximize2, value: '${listing.areaM2?.toInt() ?? 0}', unit: 'm²'),
                              _FeatureCard(icon: LucideIcons.bed, value: '${listing.bedrooms ?? 0}', unit: 'Ch'),
                              _FeatureCard(icon: LucideIcons.bath, value: '${listing.bathrooms ?? 0}', unit: 'Sdb'),
                              _FeatureCard(icon: LucideIcons.calendar, value: '2024', unit: 'Année'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                        
                        // Description
                        Text(
                          context.l('description'),
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          listing.description,
                          style: GoogleFonts.outfit(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Contact Info Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppTheme.borderDark.withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppTheme.primaryEmerald.withOpacity(0.1),
                                child: const Icon(LucideIcons.user, color: AppTheme.primaryEmerald),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listing.userVerified ? 'Agent Vérifié' : 'Propriétaire',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Aqar Morocco Member',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(LucideIcons.chevronRight, color: AppTheme.textSecondary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          
          // Sticky Bottom Bar
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildStickyBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.95),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.borderDark.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, offset: const Offset(0, 20)),
        ],
      ),
      child: Row(
        children: [
          // Sub-actions
          Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.phone, color: Colors.white),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
             decoration: BoxDecoration(
              color: const Color(0xFF25D366).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.messageSquare, color: Color(0xFF25D366)),
              onPressed: _launchWhatsApp,
            ),
          ),
          const SizedBox(width: 12),
          // Main Primary Action
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final auth = context.read<AuthProvider>();
                final user = auth.user;
                
                if (user != null && user['budget'] == null) {
                  final qualified = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LeadQualificationModal(),
                  );
                  if (qualified != true) return;
                }

                if (context.mounted) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => VisitRequestModal(listingId: listing.id),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryEmerald,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
              child: Text(
                context.l('request_visit').toUpperCase(),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  const _FeatureCard({required this.icon, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderDark.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryEmerald, size: 18),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                unit,
                style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
