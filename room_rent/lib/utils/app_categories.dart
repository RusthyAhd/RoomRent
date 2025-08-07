class AppCategories {
  static const String rooms = 'rooms';
  static const String vehicles = 'vehicles';
  static const String traditionalFoods = 'traditional_foods';
  static const String elementalGoods = 'elemental_goods';

  static final Map<String, CategoryInfo> categories = {
    rooms: CategoryInfo(
      id: rooms,
      title: 'Rooms',
      description: 'Find comfortable rooms and halls',
      icon: 'assets/images/ac room.jpg',
      types: RoomTypes.all,
    ),
    vehicles: CategoryInfo(
      id: vehicles,
      title: 'Vehicles',
      description: 'Rent vehicles for your needs',
      icon: 'assets/images/car.jpg',
      types: VehicleTypes.all,
    ),
    traditionalFoods: CategoryInfo(
      id: traditionalFoods,
      title: 'Traditional Foods',
      description: 'Delicious traditional cuisine',
      icon: 'assets/images/rice_curry.jpg',
      types: FoodTypes.all,
    ),
    elementalGoods: CategoryInfo(
      id: elementalGoods,
      title: 'Elemental Goods',
      description: 'Essential household items',
      icon: 'assets/images/iron.jpg',
      types: GoodTypes.all,
    ),
  };
}

class CategoryInfo {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Map<String, TypeInfo> types;

  const CategoryInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.types,
  });
}

class TypeInfo {
  final String id;
  final String title;
  final String description;
  final String image;
  final String category;
  final List<String>? subTypes;

  const TypeInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    this.subTypes,
  });
}

class RoomTypes {
  static const String acRoom = 'ac_room';
  static const String nonAcRoom = 'non_ac_room';
  static const String conferenceHall = 'conference_hall';

  static final Map<String, TypeInfo> all = {
    acRoom: const TypeInfo(
      id: acRoom,
      title: 'AC Room',
      description: 'Air-conditioned rooms with modern amenities',
      image: 'assets/images/ac room.jpg',
      category: AppCategories.rooms,
    ),
    nonAcRoom: const TypeInfo(
      id: nonAcRoom,
      title: 'Non-AC Room',
      description: 'Comfortable rooms with natural ventilation',
      image: 'assets/images/non-ac room.jpg',
      category: AppCategories.rooms,
    ),
    conferenceHall: const TypeInfo(
      id: conferenceHall,
      title: 'Conference Hall',
      description: 'Spacious halls for meetings and events',
      image: 'assets/images/confrence hall.jpg',
      category: AppCategories.rooms,
    ),
  };
}

class VehicleTypes {
  static const String motorcycle = 'motorcycle';
  static const String threeWheel = 'three_wheel';
  static const String car = 'car';
  static const String van = 'van';
  static const String lorry = 'lorry';

  static final Map<String, TypeInfo> all = {
    motorcycle: const TypeInfo(
      id: motorcycle,
      title: 'Motor Cycle',
      description: 'Two-wheelers for quick transportation',
      image: 'assets/images/bike.jpg',
      category: AppCategories.vehicles,
    ),
    threeWheel: const TypeInfo(
      id: threeWheel,
      title: 'Three Wheel',
      description: 'Three-wheelers for local transport',
      image: 'assets/images/three wheel.jpg',
      category: AppCategories.vehicles,
    ),
    car: const TypeInfo(
      id: car,
      title: 'Car',
      description: 'Comfortable cars for family trips',
      image: 'assets/images/car.jpg',
      category: AppCategories.vehicles,
    ),
    van: const TypeInfo(
      id: van,
      title: 'Van',
      description: 'Spacious vans for group travel',
      image: 'assets/images/van.jpg',
      category: AppCategories.vehicles,
    ),
    lorry: const TypeInfo(
      id: lorry,
      title: 'Lorry',
      description: 'Heavy vehicles for cargo transport',
      image: 'assets/images/lorry.jpg',
      category: AppCategories.vehicles,
    ),
  };
}

class FoodTypes {
  static const String stringHoppers = 'string_hoppers';
  static const String milkHoppers = 'milk_hoppers';
  static const String puttu = 'puttu';
  static const String riceCurry = 'rice_curry';

  static final Map<String, TypeInfo> all = {
    stringHoppers: const TypeInfo(
      id: stringHoppers,
      title: 'String Hoppers',
      description: 'Traditional Sri Lankan string hoppers',
      image: 'assets/images/string hopper.jpg',
      category: AppCategories.traditionalFoods,
    ),
    milkHoppers: const TypeInfo(
      id: milkHoppers,
      title: 'Milk Hoppers',
      description: 'Delicious milk hoppers with coconut milk',
      image: 'assets/images/milk hopper.jpg',
      category: AppCategories.traditionalFoods,
    ),
    puttu: const TypeInfo(
      id: puttu,
      title: 'Puttu',
      description: 'Steamed rice flour with coconut',
      image: 'assets/images/puttu.jpg',
      category: AppCategories.traditionalFoods,
    ),
    riceCurry: const TypeInfo(
      id: riceCurry,
      title: 'Rice & Curry',
      description: 'Traditional rice with various curries',
      image: 'assets/images/rice and curry.jpg',
      category: AppCategories.traditionalFoods,
      subTypes: ['chicken', 'fish', 'beef', 'sea_foods'],
    ),
  };
}

class RiceCurryVarieties {
  static const String chicken = 'chicken';
  static const String fish = 'fish';
  static const String beef = 'beef';
  static const String seafoods = 'sea_foods';

  static final List<String> all = [chicken, fish, beef, seafoods];

  static final Map<String, String> titles = {
    chicken: 'Chicken Rice & Curry',
    fish: 'Fish Rice & Curry',
    beef: 'Beef Rice & Curry',
    seafoods: 'Sea Foods Rice & Curry',
  };

  static final Map<String, String> descriptions = {
    chicken: 'Rice with chicken curry and vegetables',
    fish: 'Rice with fish curry and accompaniments',
    beef: 'Rice with beef curry and sides',
    seafoods: 'Rice with seafood curry and vegetables',
  };
}

class GoodTypes {
  static const String iron = 'iron';
  static const String kettle = 'kettle';
  static const String riceCooker = 'rice_cooker';
  static const String bbqRack = 'bbq_rack';
  static const String gasCooker = 'gas_cooker';

  static final Map<String, TypeInfo> all = {
    iron: const TypeInfo(
      id: iron,
      title: 'Iron',
      description: 'Electric irons for clothing care',
      image: 'assets/images/iron.jpg',
      category: AppCategories.elementalGoods,
    ),
    kettle: const TypeInfo(
      id: kettle,
      title: 'Kettle',
      description: 'Electric kettles for boiling water',
      image: 'assets/images/kettle.jpg',
      category: AppCategories.elementalGoods,
    ),
    riceCooker: const TypeInfo(
      id: riceCooker,
      title: 'Rice Cooker',
      description: 'Electric rice cookers for perfect rice',
      image: 'assets/images/rice cooker.jpg',
      category: AppCategories.elementalGoods,
    ),
    bbqRack: const TypeInfo(
      id: bbqRack,
      title: 'BBQ Rack',
      description: 'Barbecue racks for outdoor cooking',
      image: 'assets/images/bbq rack.jpg',
      category: AppCategories.elementalGoods,
    ),
    gasCooker: const TypeInfo(
      id: gasCooker,
      title: 'Gas Cooker with Cylinder',
      description: 'Complete gas cooking setup',
      image: 'assets/images/gas cooker.jpg',
      category: AppCategories.elementalGoods,
    ),
  };
}
