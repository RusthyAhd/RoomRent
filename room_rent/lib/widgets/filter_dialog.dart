import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  double _minPrice = 0;
  double _maxPrice = 5000;
  int? _selectedBedrooms;
  String? _selectedPropertyType;
  List<String> _selectedAmenities = [];

  final List<String> _propertyTypes = ['Apartment', 'House', 'Studio', 'Room'];

  final List<String> _amenities = [
    'WiFi',
    'Air Conditioning',
    'Kitchen',
    'Parking',
    'Pool',
    'Gym',
    'Laundry',
    'Garden',
    'Balcony',
    'Pet Friendly',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Price Range
                  const Text(
                    'Price Range',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 5000,
                    divisions: 100,
                    labels: RangeLabels(
                      '\$${_minPrice.round()}',
                      '\$${_maxPrice.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_minPrice.round()}'),
                      Text('\$${_maxPrice.round()}'),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Bedrooms
                  const Text(
                    'Bedrooms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        ChoiceChip(
                          label: Text('$i'),
                          selected: _selectedBedrooms == i,
                          onSelected: (selected) {
                            setState(() {
                              _selectedBedrooms = selected ? i : null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Property Type
                  const Text(
                    'Property Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: _propertyTypes.map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: _selectedPropertyType == type.toLowerCase(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedPropertyType = selected
                                ? type.toLowerCase()
                                : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Amenities
                  const Text(
                    'Amenities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _amenities.map((amenity) {
                      return FilterChip(
                        label: Text(amenity),
                        selected: _selectedAmenities.contains(amenity),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedAmenities.add(amenity);
                            } else {
                              _selectedAmenities.remove(amenity);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _minPrice = 0;
      _maxPrice = 5000;
      _selectedBedrooms = null;
      _selectedPropertyType = null;
      _selectedAmenities.clear();
    });
  }

  void _applyFilters() {
    // Apply filters logic here
    // You would typically call the provider method to filter rooms
    Navigator.pop(context);
  }
}
