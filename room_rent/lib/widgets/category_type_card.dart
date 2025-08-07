import 'package:flutter/material.dart';
import '../utils/app_categories.dart';
import '../widgets/dialogs/room_type_dialog.dart';
import '../widgets/dialogs/vehicle_type_dialog.dart';
import '../widgets/dialogs/food_type_dialog.dart';
import '../widgets/dialogs/good_type_dialog.dart';

class CategoryTypeCard extends StatelessWidget {
  final TypeInfo typeInfo;

  const CategoryTypeCard({super.key, required this.typeInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleCardTap(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage(typeInfo.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeInfo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        typeInfo.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context) {
    switch (typeInfo.category) {
      case AppCategories.rooms:
        _showRoomTypeDialog(context);
        break;
      case AppCategories.vehicles:
        _showVehicleTypeDialog(context);
        break;
      case AppCategories.traditionalFoods:
        _showFoodTypeDialog(context);
        break;
      case AppCategories.elementalGoods:
        _showGoodTypeDialog(context);
        break;
    }
  }

  void _showRoomTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RoomTypeDialog(typeInfo: typeInfo),
    );
  }

  void _showVehicleTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => VehicleTypeDialog(typeInfo: typeInfo),
    );
  }

  void _showFoodTypeDialog(BuildContext context) {
    if (typeInfo.id == FoodTypes.riceCurry) {
      // Show rice curry variety selection
      _showRiceCurryVarietyDialog(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => FoodTypeDialog(typeInfo: typeInfo),
      );
    }
  }

  void _showGoodTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GoodTypeDialog(typeInfo: typeInfo),
    );
  }

  void _showRiceCurryVarietyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1E3C72).withOpacity(0.95),
                const Color(0xFF2A5298).withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rice & Curry Varieties',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...RiceCurryVarieties.all.map((variety) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        typeInfo.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      RiceCurryVarieties.titles[variety]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      RiceCurryVarieties.descriptions[variety]!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => FoodTypeDialog(
                          typeInfo: typeInfo,
                          variety: variety,
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white.withOpacity(0.1),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
