import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../../auth/domain/entities/category_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../bloc/experts_bloc.dart';
import '../bloc/experts_event.dart';

class ExpertsFilterSheet extends StatefulWidget {
  const ExpertsFilterSheet({super.key});

  @override
  State<ExpertsFilterSheet> createState() => _ExpertsFilterSheetState();
}

class _ExpertsFilterSheetState extends State<ExpertsFilterSheet> {
  String selectedSort = 'Popular';
  String rating = '1';
  List<String> _categories = ['All'];
  Set<String> _selectedCategories = {'All'};
  List<CategoryEntity> _categoryEntities = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await di.sl<AuthRepository>().getCategories(
      page: 1,
      pageSize: 50,
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (_) {},
      (categories) {
        final names = categories
            .map((c) => c.name.trim())
            .where((name) => name.isNotEmpty)
            .toList();
        setState(() {
          _categoryEntities = categories;
          _categories = ['All', ...names];
          _selectedCategories.removeWhere(
            (value) => !_categories.contains(value),
          );
          if (_selectedCategories.isEmpty) {
            _selectedCategories.add('All');
          }
        });
      },
    );
  }

  double _minRatingFromLabel(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 1.0;
    }
    return parsed.clamp(1.0, 5.0);
  }

  List<int> _selectedCategoryIds() {
    if (_selectedCategories.contains('All')) {
      return [];
    }
    final ids = <int>[];
    for (final name in _selectedCategories) {
      for (final category in _categoryEntities) {
        if (category.name == name) {
          ids.add(category.id);
          break;
        }
      }
    }
    return ids;
  }

  String _categoryDisplayValue() {
    if (_selectedCategories.isEmpty || _selectedCategories.contains('All')) {
      return 'All';
    }
    return _selectedCategories.join(', ');
  }

  void _showCategoryPicker() {
    final initialSelection = Set<String>.from(_selectedCategories);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E2E3E),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final name = _categories[index];
                        final isSelected = initialSelection.contains(name);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            name,
                            style: const TextStyle(
                              color: Color(0xFF2E2E3E),
                              fontSize: 14,
                            ),
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            activeColor: const Color(0xFF2E2E3E),
                            onChanged: (checked) {
                              setSheetState(() {
                                if (name == 'All') {
                                  initialSelection
                                    ..clear()
                                    ..add('All');
                                  return;
                                }
                                if (checked == true) {
                                  initialSelection.add(name);
                                  initialSelection.remove('All');
                                } else {
                                  initialSelection.remove(name);
                                  if (initialSelection.isEmpty) {
                                    initialSelection.add('All');
                                  }
                                }
                              });
                            },
                          ),
                          onTap: () {
                            setSheetState(() {
                              if (name == 'All') {
                                initialSelection
                                  ..clear()
                                  ..add('All');
                                return;
                              }
                              if (initialSelection.contains(name)) {
                                initialSelection.remove(name);
                                if (initialSelection.isEmpty) {
                                  initialSelection.add('All');
                                }
                              } else {
                                initialSelection.add(name);
                                initialSelection.remove('All');
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategories = Set<String>.from(
                            initialSelection,
                          );
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E2E3E),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E2E3E),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildMultiSelectField(
                    label: 'Category:',
                    value: _categoryDisplayValue(),
                    onTap: _showCategoryPicker,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'Rating:',
                    value: rating,
                    items: ['1', '2', '3', '4', '5'],
                    onChanged: (val) => setState(() => rating = val!),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Menu Items
          _buildMenuItem(
            icon: Icons.local_fire_department,
            text: 'Popular',
            isSelected: selectedSort == 'Popular',
            onTap: () => setState(() => selectedSort = 'Popular'),
          ),
          _buildMenuItem(
            icon: Icons.access_time_filled,
            text: 'New',
            isSelected: selectedSort == 'New',
            onTap: () => setState(() => selectedSort = 'New'),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ExpertsBloc>().add(
                        FilterExperts(
                          categoryIds: _selectedCategoryIds(),
                          minRating: _minRatingFromLabel(rating),
                          sortBy: selectedSort,
                          page: 1,
                          pageSize: 20,
                        ),
                      );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E3E),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2E2E3E),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF2E2E3E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Color(0xFF2E2E3E),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2E2E3E),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Color(0xFF2E2E3E),
              ),
              style: const TextStyle(
                color: Color(0xFF2E2E3E),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F7F9) : Colors.transparent, // Very light grey for selected
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF2E2E3E), // Dark color for icons
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2E2E3E),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
