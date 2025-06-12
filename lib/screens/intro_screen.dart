import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/drinking_behavior.dart';
import 'tracker_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  double _drinksPerWeek = 0;
  final TextEditingController _priceController = TextEditingController();
  final Set<String> _selectedOccasions = <String>{};

  final List<String> _availableOccasions = [
    'Party',
    'Date',
    'Allein zu Hause',
    'Mit Kollegen',
    'Beim Essen',
    'Bei Stress',
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
        content: Text('Verhalten gespeichert: ${_drinksPerWeek.round()} Drinks/Woche, €${price.toStringAsFixed(2)}/Drink'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to tracker screen after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TrackerScreen(
              weeklyDrinks: _drinksPerWeek.round(),
              pricePerDrink: price,
            ),
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
              Text(
                'Trinkverhalten verstehen',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Hilf uns, deine aktuellen Gewohnheiten zu verstehen',
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
                        // Question 1: Drinks per week slider
                        Text(
                          'Wie oft trinkst du durchschnittlich pro Woche?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            '${_drinksPerWeek.round()} Drinks pro Woche',
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

                        // Question 2: Price per drink input
                        Text(
                          'Wie viel gibst du im Schnitt pro Drink aus?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
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
                            hintText: 'z.B. 4,50',
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

                        // Question 3: Drinking occasions
                        Text(
                          'In welchen Situationen trinkst du typischerweise?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Wähle alle zutreffenden aus',
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
                child: Text(
                  'Verhalten speichern & fortfahren',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF008EC1),
                    fontSize: 18,
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
