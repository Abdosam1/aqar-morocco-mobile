import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/data/models/listing_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: listing.images.isNotEmpty ? listing.images.first : 'https://via.placeholder.com/800x600',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Text(
                          '${listing.price.toInt()} MAD',
                          style: const TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.bold, 
                            color: AppTheme.primaryGreen
                          ),
                        ),
                        const Icon(LucideIcons.heart, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      listing.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${listing.city}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      listing.description,
                      style: const TextStyle(color: Colors.slate-600, height: 1.6),
                    ),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ElevatedButton.icon(
          onPressed: _launchWhatsApp,
          icon: const Icon(LucideIcons.messageCircle),
          label: const Text('Contacter sur WhatsApp'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)),
        ),
      ),
    );
  }
}
