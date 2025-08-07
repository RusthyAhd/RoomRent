import 'dart:math';

/// Collection of inspirational quotes for the Pegas Rental Hub app
class AppQuotes {
  static const List<String> _rentalQuotes = [
    "\"Your perfect rental experience starts here - rooms, rides, and culture await\"",
    "\"Every great journey begins with finding the perfect place to stay\"",
    "\"Home is not a place, it's a feeling - let us help you find it\"",
    "\"Adventure awaits in every rental - discover, explore, experience\"",
    "\"Quality accommodations for extraordinary memories\"",
    "\"Where comfort meets convenience - your rental sanctuary\"",
    "\"Unlock new experiences, one rental at a time\"",
    "\"Travel with confidence, stay with comfort\"",
    "\"Your gateway to authentic local experiences\"",
    "\"Creating memories, one perfect rental at a time\"",
    "\"Exceptional stays for exceptional people\"",
    "\"Rent smart, travel better, live fully\"",
    "\"Your comfort zone, wherever you go\"",
    "\"Discover the world through perfect rentals\"",
    "\"Quality rentals for quality moments\"",
  ];

  static const List<String> _motivationalQuotes = [
    "\"Life is either a daring adventure or nothing at all\" - Helen Keller",
    "\"Travel is the only thing you buy that makes you richer\"",
    "\"Adventure is worthwhile in itself\" - Amelia Earhart",
    "\"The world is a book, and those who do not travel read only one page\" - Augustine",
    "\"Not all those who wander are lost\" - J.R.R. Tolkien",
    "\"Travel makes one modest, you see what a tiny place you occupy in the world\"",
    "\"To travel is to live\" - Hans Christian Andersen",
    "\"Collect moments, not things\"",
    "\"Life begins at the end of your comfort zone\"",
    "\"Adventure awaits those who seek it\"",
  ];

  static const List<String> _businessQuotes = [
    "\"Excellence is not a destination; it is a continuous journey that never ends\"",
    "\"Quality is not an act, it is a habit\" - Aristotle",
    "\"Success is where preparation and opportunity meet\"",
    "\"Customer satisfaction is our highest priority\"",
    "\"Innovation distinguishes between a leader and a follower\" - Steve Jobs",
    "\"Your rental experience, our commitment to excellence\"",
    "\"Building trust, one rental at a time\"",
    "\"Service excellence is our standard, not our goal\"",
  ];

  /// Get a random rental-focused quote
  static String getRandomRentalQuote() {
    final random = Random();
    return _rentalQuotes[random.nextInt(_rentalQuotes.length)];
  }

  /// Get a random motivational quote
  static String getRandomMotivationalQuote() {
    final random = Random();
    return _motivationalQuotes[random.nextInt(_motivationalQuotes.length)];
  }

  /// Get a random business/service quote
  static String getRandomBusinessQuote() {
    final random = Random();
    return _businessQuotes[random.nextInt(_businessQuotes.length)];
  }

  /// Get a random quote from all categories
  static String getRandomQuote() {
    final allQuotes = [
      ..._rentalQuotes,
      ..._motivationalQuotes,
      ..._businessQuotes,
    ];
    final random = Random();
    return allQuotes[random.nextInt(allQuotes.length)];
  }

  /// Get all rental quotes
  static List<String> getAllRentalQuotes() => List.from(_rentalQuotes);

  /// Get all motivational quotes
  static List<String> getAllMotivationalQuotes() =>
      List.from(_motivationalQuotes);

  /// Get all business quotes
  static List<String> getAllBusinessQuotes() => List.from(_businessQuotes);

  /// Get all quotes
  static List<String> getAllQuotes() => [
    ..._rentalQuotes,
    ..._motivationalQuotes,
    ..._businessQuotes,
  ];

  /// Get a quote by category and index (useful for consistent display)
  static String getQuoteByCategory(QuoteCategory category, int index) {
    switch (category) {
      case QuoteCategory.rental:
        return _rentalQuotes[index % _rentalQuotes.length];
      case QuoteCategory.motivational:
        return _motivationalQuotes[index % _motivationalQuotes.length];
      case QuoteCategory.business:
        return _businessQuotes[index % _businessQuotes.length];
    }
  }

  /// Get the count of quotes in a category
  static int getCategoryCount(QuoteCategory category) {
    switch (category) {
      case QuoteCategory.rental:
        return _rentalQuotes.length;
      case QuoteCategory.motivational:
        return _motivationalQuotes.length;
      case QuoteCategory.business:
        return _businessQuotes.length;
    }
  }
}

/// Categories of quotes available in the app
enum QuoteCategory { rental, motivational, business }
