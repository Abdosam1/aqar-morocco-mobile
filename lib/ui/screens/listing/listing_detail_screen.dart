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
import 'package:intl/date_symbol_data_local.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;
  const ListingDetailScreen({super.key, required this.listing});

  _launchWhatsApp() async {
    final url = "whatsapp://send?phone=+212000000000&text=Salam, je suis intéressé par votre annonce: ${listing.title}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize date formatting for French
    initializeDateFormatting('fr_FR', null);

    final priceStr = '${listing.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} ${context.l('price_mad')}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: AppTheme.primaryGreen,
            elevation: 0,
            title: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final opacity = (top - kToolbarHeight) / (400 - kToolbarHeight);
                return Opacity(
                  opacity: (1.0 - opacity).clamp(0.0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        priceStr,
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        '${listing.city ?? "Maroc"}',
                        style: GoogleFonts.outfit(fontSize: 10, color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                );
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: listing.images.isNotEmpty ? listing.images.first : 'https://via.placeholder.com/800x600',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          priceStr,
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.heart, color: Colors.grey, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            listing.title,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.deepNavy,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (listing.isVerified) ...[
                          const SizedBox(width: 8),
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: VerificationBadge(size: 20),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, size: 14, color: AppTheme.accentGold),
                        const SizedBox(width: 6),
                        Text(
                          '${listing.city ?? "Maroc"}',
                          style: GoogleFonts.outfit(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    Divider(color: Colors.grey.shade100),
                    const SizedBox(height: 24),
                    
                    // Owner Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Text('A', style: GoogleFonts.outfit(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    context.l('agent_imb'),
                                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepNavy),
                                  ),
                                  if (listing.userVerified) ...[
                                    const SizedBox(width: 6),
                                    const VerificationBadge(size: 14),
                                  ],
                                ],
                              ),
                              Text(
                                context.l('app_verified'),
                                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // Link to chat detail
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primaryColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(context.l('message'), style: GoogleFonts.outfit(color: AppTheme.primaryColor, fontSize: 13)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Divider(color: Colors.grey.shade100),
                    const SizedBox(height: 24),
                    
                    // Features Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FeatureItem(icon: LucideIcons.maximize, value: '${listing.areaM2}', unit: context.l('m2')),
                        _FeatureItem(icon: LucideIcons.bed, value: '${listing.bedrooms}', unit: context.l('bedrooms')),
                        _FeatureItem(icon: LucideIcons.bath, value: '${listing.bathrooms}', unit: context.l('bathrooms')),
                        _FeatureItem(icon: LucideIcons.info, value: 'R+2', unit: ''),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    Divider(color: Colors.grey.shade100),
                    const SizedBox(height: 24),
                    
                    Text(
                      context.l('description'),
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      listing.description,
                      style: GoogleFonts.outfit(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 90,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(LucideIcons.phone, color: AppTheme.primaryColor),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(LucideIcons.messageCircle, color: const Color(0xFF25D366)),
                  onPressed: _launchWhatsApp,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final auth = context.read<AuthProvider>();
                    final user = auth.user;
                    
                    // If budget is not set, show qualification modal first
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
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    context.l('request_visit'),
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String price;
  final String address;
  _StickyHeaderDelegate({required this.price, required this.address});

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final opacity = (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    return Container(
      color: Colors.white.withOpacity(opacity > 0.5 ? 1.0 : 0.0),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      child: opacity > 0.5 ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price,
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
              ),
              Text(
                address,
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Contact', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ) : const SizedBox.shrink(),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  const _FeatureItem({required this.icon, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepNavy),
        ),
        Text(
          unit,
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

