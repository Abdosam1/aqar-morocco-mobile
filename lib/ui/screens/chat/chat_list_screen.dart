import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/chat_provider.dart';
import 'package:aqar_morocco_mobile/providers/auth_provider.dart';
import 'package:aqar_morocco_mobile/ui/screens/chat/chat_detail_screen.dart';
import 'package:aqar_morocco_mobile/core/localization/localizer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ChatProvider>().fetchConversations());
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().user?['id'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(context.l('messages'), style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.loading && provider.conversations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.messageSquare, size: 64, color: Colors.grey[200]),
                  const SizedBox(height: 16),
                  Text(context.l('no_chats'), style: GoogleFonts.outfit(color: Colors.grey)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchConversations(),
            child: ListView.separated(
              itemCount: provider.conversations.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100], indent: 80),
              itemBuilder: (context, index) {
                final conv = provider.conversations[index];
                // Determine the other user
                final isSender = conv['sender_id'] == currentUserId;
                final otherUserName = isSender ? (conv['r_full_name'] ?? context.l('guest')) : (conv['s_full_name'] ?? context.l('guest'));
                final otherUserId = isSender ? conv['receiver_id'] : conv['sender_id'];
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(otherUserName[0], style: const TextStyle(color: AppTheme.primaryColor)),
                  ),
                  title: Text(
                    otherUserName,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    conv['content'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '12:30', // Placeholder for time
                        style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                      ),
                      if (conv['is_read'] == false && !isSender)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(
                          otherUserId: otherUserId,
                          otherUserName: otherUserName,
                          listingId: conv['listing_id'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
