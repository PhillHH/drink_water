class DrinkingBehavior {
  final int drinksPerWeek;
  final double pricePerDrink;
  final List<String> occasions;

  const DrinkingBehavior({
    required this.drinksPerWeek,
    required this.pricePerDrink,
    required this.occasions,
  });

  DrinkingBehavior copyWith({
    int? drinksPerWeek,
    double? pricePerDrink,
    List<String>? occasions,
  }) {
    return DrinkingBehavior(
      drinksPerWeek: drinksPerWeek ?? this.drinksPerWeek,
      pricePerDrink: pricePerDrink ?? this.pricePerDrink,
      occasions: occasions ?? this.occasions,
    );
  }

  @override
  String toString() {
    return 'DrinkingBehavior(drinksPerWeek: $drinksPerWeek, pricePerDrink: $pricePerDrink, occasions: $occasions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is DrinkingBehavior &&
      other.drinksPerWeek == drinksPerWeek &&
      other.pricePerDrink == pricePerDrink &&
      _listEquals(other.occasions, occasions);
  }

  @override
  int get hashCode {
    return drinksPerWeek.hashCode ^
      pricePerDrink.hashCode ^
      occasions.hashCode;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
