import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrackerScreen extends StatefulWidget {
  final int weeklyDrinks;
  final double pricePerDrink;

  const TrackerScreen({
    super.key,
    required this.weeklyDrinks,
    required this.pricePerDrink,
  });

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final TextEditingController _inputController = TextEditingController();
  double _totalSaved = 0.0;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _addSavings() {
    final inputText = _inputController.text.trim();
    if (inputText.isEmpty) return;

    final amount = double.tryParse(inputText.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte gib eine gültige Zahl ein'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _totalSaved += amount;
      _inputController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('€${amount.toStringAsFixed(2)} hinzugefügt!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008EC1),
      appBar: AppBar(
        title: Text(
          'Tracker',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF008EC1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Dein Trinkverhalten',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.weeklyDrinks} Drinks/Woche • €${widget.pricePerDrink.toStringAsFixed(2)}/Drink',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Input section
                      Text(
                        'Gesparte Euros eintragen',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.black87,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: _inputController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'z.B. 15,50',
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
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _addSavings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008EC1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Eintragen',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Total savings display
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008EC1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Insgesamt gespart:',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '€${_totalSaved.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 36,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Reset button
                      if (_totalSaved > 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _totalSaved = 0.0;
                            });
                          },
                          child: const Text(
                            'Zurücksetzen',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
