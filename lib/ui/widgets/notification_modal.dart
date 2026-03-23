import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/notification_provider.dart';

class NotificationModal extends StatefulWidget {
  const NotificationModal({super.key});

  @override
  State<NotificationModal> createState() => _NotificationModalState();
}

class _NotificationModalState extends State<NotificationModal> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NotificationProvider>().fetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
                  child: Text('Tout lire', style: GoogleFonts.outfit(color: AppTheme.primaryColor)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (context, provider, child) {
                if (provider.loading && provider.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.bellOff, size: 64, color: Colors.grey[200]),
                        const SizedBox(height: 16),
                        Text('Aucune notification', style: GoogleFonts.outfit(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: provider.notifications.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
                  itemBuilder: (context, index) {
                    final note = provider.notifications[index];
                    final isRead = note['is_read'] ?? false;
                    
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getNoteColor(note['type']).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_getNoteIcon(note['type']), color: _getNoteColor(note['type']), size: 20),
                      ),
                      title: Text(
                        note['title'] ?? 'Notification',
                        style: GoogleFonts.outfit(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
                      ),
                      subtitle: Text(
                        note['message'] ?? '',
                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
                      ),
                      onTap: () => provider.markAsRead(note['id']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNoteIcon(String? type) {
    switch (type) {
      case 'message': return LucideIcons.messageSquare;
      case 'visit_request': return LucideIcons.calendar;
      default: return LucideIcons.bell;
    }
  }

  Color _getNoteColor(String? type) {
    switch (type) {
      case 'message': return AppTheme.primaryColor;
      case 'visit_request': return Colors.orange;
      default: return Colors.blue;
    }
  }
}
