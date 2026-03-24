import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/auth_provider.dart';
import 'package:aqar_morocco_mobile/providers/listings_provider.dart';
import 'package:aqar_morocco_mobile/ui/widgets/listing_card.dart';
import 'package:aqar_morocco_mobile/ui/screens/listing/listing_detail_screen.dart';
import 'package:aqar_morocco_mobile/ui/screens/profile/profile_screen.dart';
import 'package:aqar_morocco_mobile/ui/screens/chat/chat_list_screen.dart';
import 'package:aqar_morocco_mobile/core/localization/localizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ListingsProvider>().fetchListings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          const Center(child: Text('Recherche')),
          const Center(child: Text('Favoris')),
          const ChatListScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        border: Border(top: BorderSide(color: AppTheme.borderDark.withOpacity(0.5), width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppTheme.darkBackground,
        selectedItemColor: AppTheme.primaryEmerald,
        unselectedItemColor: AppTheme.textSecondary.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
        items: [
          BottomNavigationBarItem(icon: Icon(_currentIndex == 0 ? LucideIcons.home : LucideIcons.home, size: 24), label: context.l('home')),
          BottomNavigationBarItem(icon: const Icon(LucideIcons.search, size: 24), label: context.l('search')),
          BottomNavigationBarItem(icon: const Icon(LucideIcons.heart, size: 24), label: context.l('favorites')),
          BottomNavigationBarItem(icon: const Icon(LucideIcons.messageCircle, size: 24), label: context.l('messages')),
          BottomNavigationBarItem(icon: const Icon(LucideIcons.user, size: 24), label: context.l('profile')),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        // Premium Hero Section
        SliverToBoxAdapter(
          child: Stack(
            children: [
              // Hero Image with Gradient
              Container(
                height: 520,
                width: double.infinity,
                child: ClipRRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bbaa?w=1600',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.4, 0.7, 1.0],
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              AppTheme.darkBackground.withOpacity(0.8),
                              AppTheme.darkBackground,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content Overlay
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Custom Header with Logo & Profile
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: const Icon(LucideIcons.home, color: AppTheme.primaryEmerald, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Aqar\nMorocco',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=abdosam'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      
                      // Hero Titles
                      Text(
                        'Trouvez votre\nmaison de rêve',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اعثر على بيت أحلامك',
                        style: GoogleFonts.notoSansArabic(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Floating Search Bar
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 15)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.outfit(color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: 'Rechercher par ville, quartier...',
                                  hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 13),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  fillColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryEmerald,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.search, size: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Categories Grid-style
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryCard(LucideIcons.building, 'Appartements', true),
                  _buildCategoryCard(LucideIcons.home, 'Villas', false),
                  _buildCategoryCard(LucideIcons.landmark, 'Riads', false),
                  _buildCategoryCard(LucideIcons.map, 'Terrains', false),
                ],
              ),
            ),
          ),
        ),

        // Horizontal Recommended Section
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Biens d\'Exception',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Voir tout',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 340,
                child: Consumer<ListingsProvider>(
                  builder: (context, provider, _) {
                    if (provider.loading) return const Center(child: CircularProgressIndicator());
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: provider.listings.length > 5 ? 5 : provider.listings.length,
                      itemBuilder: (context, index) {
                        final listing = provider.listings[index];
                        return Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 20),
                          child: ListingCard(listing: listing),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 85,
      height: 95,
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.08) : AppTheme.cardDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppTheme.primaryEmerald.withOpacity(0.5) : AppTheme.borderDark.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryEmerald.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isActive ? AppTheme.primaryEmerald : AppTheme.textSecondary, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: isActive ? Colors.white : AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
