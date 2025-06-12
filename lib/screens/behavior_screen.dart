import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/drinking_behavior.dart';
import 'tracker_screen.dart';

class BehaviorScreen extends StatefulWidget {
  const BehaviorScreen({super.key});

  @override
  State<BehaviorScreen> createState() => _BehaviorScreenState();
}

class _BehaviorScreenState extends State<BehaviorScreen> {
  double _drinksPerWeek = 0;
  final TextEditingController _priceController = TextEditingController();
  final Set<String> _selectedOccasions = <String>{};

  final List<String> _availableOccasions = [
    'Party',
    'Date',
    'Home alone',
    'With colleagues',
    'During meals',
    'Stress',
  ];

  DrinkingBehavior? _savedBehavior;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _saveBehaviorAndContinue() {
    final priceText = _priceController.text.replaceAll(',', '.');
    final price = double.tryParse(priceText) ?? 0.0;

    final behavior = DrinkingBehavior(
      drinksPerWeek: _drinksPerWeek.round(),
      pricePerDrink: price,
      occasions: _selectedOccasions.toList(),
    );

    setState(() {
      _savedBehavior = behavior;
    });

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Behavior saved: ${_drinksPerWeek.round()} drinks/week, €${price.toStringAsFixed(2)}/drink'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to tracker screen after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TrackerScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008EC1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const SizedBox(height: 20),
              const Text(
                'Reflect on Your Drinking Behavior',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Help us understand your current habits',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Main content in white container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drinks per week slider
                        const Text(
                          'How many alcoholic drinks do you usually consume per week?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            '${_drinksPerWeek.round()} drinks per week',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF008EC1),
                            ),
                          ),
                        ),
                        Slider(
                          value: _drinksPerWeek,
                          min: 0,
                          max: 14,
                          divisions: 14,
                          activeColor: const Color(0xFF008EC1),
                          inactiveColor: const Color(0xFF008EC1).withOpacity(0.3),
                          onChanged: (value) {
                            setState(() {
                              _drinksPerWeek = value;
                            });
                          },
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0', style: TextStyle(color: Colors.grey)),
                            Text('14', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Price per drink input
                        const Text(
                          'Average price per drink (€)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}')),
                          ],
                          decoration: InputDecoration(
                            hintText: 'e.g., 4.50',
                            prefixText: '€ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF008EC1), width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Drinking occasions
                        const Text(
                          'When do you typically drink?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Select all that apply',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableOccasions.map((occasion) {
                            final isSelected = _selectedOccasions.contains(occasion);
                            return FilterChip(
                              label: Text(occasion),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedOccasions.add(occasion);
                                  } else {
                                    _selectedOccasions.remove(occasion);
                                  }
                                });
                              },
                              selectedColor: const Color(0xFF008EC1).withOpacity(0.2),
                              checkmarkColor: const Color(0xFF008EC1),
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: isSelected ? const Color(0xFF008EC1) : Colors.black87,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              // Save button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBehaviorAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF008EC1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Save behavior & continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
