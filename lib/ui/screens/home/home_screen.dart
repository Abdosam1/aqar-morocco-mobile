import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/listings_provider.dart';
import 'package:aqar_morocco_mobile/ui/widgets/listing_card.dart';
import 'package:aqar_morocco_mobile/ui/screens/listing/listing_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      context.read<ListingsProvider>().fetchListings()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aqar Morocco'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ListingsProvider>(
        builder: (context, provider, child) {
          if (provider.loading && provider.listings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchListings(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Découvrir l\'immobilier',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: provider.listings.length,
                  itemBuilder: (context, index) {
                    final listing = provider.listings[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing))
                      ),
                      child: ListingCard(listing: listing),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
