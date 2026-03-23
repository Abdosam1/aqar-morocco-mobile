import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';
import 'package:aqar_morocco_mobile/providers/listings_provider.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Data
  String _listingType = 'sale';
  int? _propertyTypeId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();
  int _bedrooms = 0;
  int _bathrooms = 0;
  int? _selectedCityId;
  String? _neighborhood;

  final Map<int, String> _propertyTypes = {
    1: 'Appartement',
    2: 'Villa',
    3: 'Riad',
    4: 'Terrain',
    5: 'Bureau',
    6: 'Local Commercial',
  };

  final Map<int, String> _cityMap = {
    1: 'Casablanca',
    2: 'Rabat',
    3: 'Marrakech',
    4: 'Tanger',
    5: 'Agadir',
  };

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Logic to call ListingsProvider.create()
    // For now, show success snackbar and pop
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Annonce soumise pour révision !'), backgroundColor: AppTheme.primaryGreen),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Publier une annonce', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(key: _formKey, child: _buildCurrentStepView()),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 0: return _buildStepOne();
      case 1: return _buildStepTwo();
      case 2: return _buildStepThree();
      case 3: return _buildStepFour();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Type d\'annonce'),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildChoiceChip('À Vendre', 'sale', _listingType == 'sale'),
            const SizedBox(width: 12),
            _buildChoiceChip('À Louer', 'rent', _listingType == 'rent'),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Catégorie de bien'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _propertyTypes.entries.map((e) => _buildCategoryChip(e.value, e.key)).toList(),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Localisation'),
        const SizedBox(height: 24),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Ville'),
          value: _selectedCityId,
          items: _cityMap.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: (val) => setState(() => _selectedCityId = val),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: TextEditingController(text: _neighborhood),
          decoration: const InputDecoration(labelText: 'Quartier'),
          onChanged: (val) => _neighborhood = val,
        ),
      ],
    );
  }

  Widget _buildStepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Détails du bien'),
        const SizedBox(height: 24),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Titre de l\'annonce'),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Description détaillée'),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Prix (MAD)'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _sizeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Surface (m²)'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepFour() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Caractéristiques'),
        const SizedBox(height: 24),
        _buildCounter('Chambres', _bedrooms, (val) => setState(() => _bedrooms = val)),
        const SizedBox(height: 16),
        _buildCounter('Salles de bain', _bathrooms, (val) => setState(() => _bathrooms = val)),
        const SizedBox(height: 32),
        _buildSectionTitle('Photos (Bientôt)'),
        const SizedBox(height: 16),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
          ),
          child: const Center(child: Icon(LucideIcons.imagePlus, size: 40, color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label, String value, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _listingType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, int id) {
    final isSelected = _propertyTypeId == id;
    return GestureDetector(
      onTap: () => setState(() => _propertyTypeId = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? AppTheme.primaryColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.minusCircle, color: Colors.grey),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            SizedBox(width: 30, child: Center(child: Text('$value', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)))),
            IconButton(
              icon: const Icon(LucideIcons.plusCircle, color: AppTheme.primaryColor),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Précédent'),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(_currentStep == 3 ? 'Publier' : 'Suivant'),
            ),
          ),
        ],
      ),
    );
  }
}
