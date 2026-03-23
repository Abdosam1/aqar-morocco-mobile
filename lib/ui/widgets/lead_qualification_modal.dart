import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/auth_provider.dart';

class LeadQualificationModal extends StatefulWidget {
  const LeadQualificationModal({super.key});

  @override
  State<LeadQualificationModal> createState() => _LeadQualificationModalState();
}

class _LeadQualificationModalState extends State<LeadQualificationModal> {
  final _budgetController = TextEditingController();
  final _areaController = TextEditingController();
  DateTime? _moveDate;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _budgetController.text = user['budget']?.toString() ?? '';
      _areaController.text = user['preferred_area'] ?? '';
      if (user['move_date'] != null) {
        _moveDate = DateTime.parse(user['move_date']);
      }
    }
  }

  void _submit() async {
    final success = await context.read<AuthProvider>().updateUser({
      'budget': double.tryParse(_budgetController.text),
      'preferred_area': _areaController.text,
      'move_date': _moveDate?.toIso8601String(),
    });

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 32, 32, MediaQuery.of(context).viewInsets.bottom + 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text(
              'Précisez votre recherche',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Aidez-nous à mieux vous accompagner dans votre projet immobilier.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 32),
            
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Votre budget max (MAD)',
                prefixIcon: Icon(LucideIcons.banknote, size: 20),
              ),
            ),
            const SizedBox(height: 20),
            
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(
                labelText: 'Zone préférée (Ville, Quartier)',
                prefixIcon: Icon(LucideIcons.mapPin, size: 20),
              ),
            ),
            const SizedBox(height: 20),
            
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _moveDate = date);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 20, color: AppTheme.primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      _moveDate == null ? 'Date d\'aménagement prévue' : 'Prévu le ${_moveDate!.day}/${_moveDate!.month}/${_moveDate!.year}',
                      style: GoogleFonts.outfit(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Enregistrer mes préférences',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Plus tard', style: GoogleFonts.outfit(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
