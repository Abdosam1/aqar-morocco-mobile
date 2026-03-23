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
import 'package:aqar_morocco_mobile/ui/screens/auth/login_screen.dart';
import 'package:aqar_morocco_mobile/ui/screens/profile/profile_screen.dart';
import 'package:aqar_morocco_mobile/ui/widgets/notification_modal.dart';
import 'package:aqar_morocco_mobile/providers/notification_provider.dart';
import 'package:aqar_morocco_mobile/ui/screens/chat/chat_list_screen.dart';
import 'package:aqar_morocco_mobile/core/localization/localizer.dart';
import 'package:aqar_morocco_mobile/providers/locale_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedType = 'sale'; // 'sale' or 'rent'
  int? _selectedCityId;
  String? _selectedCityName;
  double? _maxPrice;

  final Map<int, String> _cityMap = {
    1: 'Casablanca',
    2: 'Rabat',
    3: 'Marrakech',
    4: 'Tanger',
    5: 'Agadir',
    6: 'Fès',
    7: 'Meknès',
    8: 'Oujda',
    9: 'Kénitra',
    10: 'Tétouan',
  };

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  void _fetchListings() {
    final filters = <String, dynamic>{
      'listing_type': _selectedType,
    };
    if (_selectedCityId != null) filters['city_id'] = _selectedCityId;
    if (_maxPrice != null) filters['max_price'] = _maxPrice;

    Future.microtask(() => 
      context.read<ListingsProvider>().fetchListings(filters: filters)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          const Center(child: Text('Recherche (Bientôt)')),
          const Center(child: Text('Favoris (Bientôt)')),
          const ChatListScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12),
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: const Icon(LucideIcons.home), label: context.l('home')),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.search), label: context.l('search')),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.heart), label: context.l('favorites')),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.messageSquare), label: context.l('messages')),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.user), label: context.l('profile')),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
        onRefresh: () => context.read<ListingsProvider>().fetchListings(),
        color: AppTheme.primaryGreen,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 450,
              pinned: true,
              stretch: true,
              backgroundColor: AppTheme.primaryGreen,
              elevation: 0,
              leading: const SizedBox.shrink(),
              actions: [
                Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.bell, color: Colors.white),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const NotificationModal(),
                            );
                          },
                        ),
                        if (provider.unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: Text(
                                provider.unreadCount.toString(),
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(LucideIcons.logOut, color: AppTheme.primaryGreen, size: 20),
                      onPressed: _handleLogout,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1539650116574-8efeb43e2750?w=1600', // Luxury Moroccan Palace
                    fit: BoxFit.cover,
                  ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.deepNavy.withOpacity(0.4),
                            AppTheme.deepNavy.withOpacity(0.1),
                            AppTheme.background,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.l('hello')},\n${user?['full_name']?.split(' ').first ?? context.l('guest')} 👋',
                            style: GoogleFonts.outfit(fontSize: 16, color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l('welcome_dream'),
                            style: GoogleFonts.outfit(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                              shadows: const [
                                Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                              ],
                            ),
                          ),
                          // Premium Floating Search Bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: context.l('search_hint_alt'),
                                hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 16),
                                icon: const Icon(LucideIcons.search, color: AppTheme.primaryGreen),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Vente / Location Toggle
                          Row(
                            children: [
                              _buildTypeToggle(context.l('buy'), 'sale'),
                              const SizedBox(width: 12),
                              _buildTypeToggle(context.l('rent'), 'rent'),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Filter Bar
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildFilterChip(
                        icon: LucideIcons.mapPin,
                        label: _selectedCityName ?? 'Ville',
                        isActive: _selectedCityId != null,
                        onTap: _showCityPicker,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        icon: LucideIcons.banknote,
                        label: _maxPrice != null ? '< ${_maxPrice!.toInt()} MAD' : 'Prix Max',
                        isActive: _maxPrice != null,
                        onTap: _showPricePicker,
                      ),
                      if (_selectedCityId != null || _maxPrice != null) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCityId = null;
                              _selectedCityName = null;
                              _maxPrice = null;
                            });
                            _fetchListings();
                          },
                          child: Text('Réinitialiser', style: GoogleFonts.outfit(color: Colors.red, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Categories
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _CategoryItem(icon: LucideIcons.building, label: context.l('apartment'), isActive: true),
                          _CategoryItem(icon: LucideIcons.home, label: context.l('villa')),
                          _CategoryItem(icon: LucideIcons.landmark, label: context.l('riad')),
                          _CategoryItem(icon: LucideIcons.map, label: context.l('land')),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _SectionHeader(title: context.l('new_maroc')),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 450,
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
                                width: 300,
                                margin: const EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing))
                                  ),
                                  child: ListingCard(listing: listing),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    _SectionHeader(title: context.l('all_listings')),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            Consumer<ListingsProvider>(
              builder: (context, provider, child) {
                if (provider.loading && provider.listings.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (provider.listings.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.searchX, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            context.l('none_found'),
                            style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final listing = provider.listings[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing))
                          ),
                          child: ListingCard(listing: listing),
                        );
                      },
                      childCount: provider.listings.length,
                    ),
                  ),
                );
              },
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _handleLogout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Widget _buildTypeToggle(String label, String type) {
    final isActive = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = type);
        _fetchListings();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isActive ? AppTheme.primaryGreen : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({required IconData icon, required String label, bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? AppTheme.primaryGreen : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? AppTheme.primaryGreen : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isActive ? AppTheme.primaryGreen : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(LucideIcons.chevronDown, size: 14, color: isActive ? AppTheme.primaryGreen : Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choisir une ville', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _cityMap.entries.map((entry) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCityId = entry.key;
                    _selectedCityName = entry.value;
                  });
                  Navigator.pop(context);
                  _fetchListings();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedCityId == entry.key ? AppTheme.primaryGreen : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(entry.value, style: GoogleFonts.outfit(
                    color: _selectedCityId == entry.key ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600
                  )),
                ),
              )).toList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showPricePicker() {
    final prices = [500000, 1000000, 2000000, 5000000, 10000000];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Budget Maximum', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...prices.map((p) => ListTile(
              title: Text('< ${p.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MAD'),
              onTap: () {
                setState(() => _maxPrice = p.toDouble());
                Navigator.pop(context);
                _fetchListings();
              },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepNavy,
            ),
          ),
          Text(
            'Voir tout',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _CategoryItem({required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryGreen : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!isActive) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
              ],
            ),
            child: Icon(icon, color: isActive ? Colors.white : AppTheme.primaryGreen),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppTheme.primaryGreen : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
