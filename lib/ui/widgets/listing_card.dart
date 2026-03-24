import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/core/localization/localizer.dart';
import 'package:aqar_morocco_mobile/data/models/listing_model.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;
  const ListingCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderDark.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Star Badge
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: listing.images.isNotEmpty ? listing.images.first : 'https://via.placeholder.com/400x320',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Star Badge (Featured Look)
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.star, color: AppTheme.primaryEmerald, size: 16),
                  ),
                ),
                // Price Tag Overlay (Optional, matching image)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      listing.listingType == ListingType.sale ? 'Vente' : 'Location',
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            
            // Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Price
                   Text(
                    '${listing.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MAD',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryEmerald,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 12, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Maroc, ${listing.city ?? 'Casablanca'}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      
                      // Metrics
                      Row(
                        children: [
                          Icon(LucideIcons.bed, size: 12, color: AppTheme.textSecondary.withOpacity(0.7)),
                          const SizedBox(width: 4),
                          Text('${listing.bedrooms ?? 0}', style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textSecondary)),
                          const SizedBox(width: 8),
                          Icon(LucideIcons.maximize2, size: 12, color: AppTheme.textSecondary.withOpacity(0.7)),
                          const SizedBox(width: 4),
                          Text('${listing.areaM2?.toInt() ?? 0}', style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
