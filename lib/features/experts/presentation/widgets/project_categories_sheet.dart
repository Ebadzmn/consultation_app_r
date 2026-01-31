 import 'package:flutter/material.dart';
 import '../../../../injection_container.dart' as di;
 import '../../../auth/domain/repositories/auth_repository.dart';

class ProjectCategoriesSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final Function(List<String>) onApply;

  const ProjectCategoriesSheet({
    super.key,
    required this.selectedCategories,
    required this.onApply,
  });

  @override
  State<ProjectCategoriesSheet> createState() => _ProjectCategoriesSheetState();
}

class _ProjectCategoriesSheetState extends State<ProjectCategoriesSheet> {
  late List<String> _tempSelected;
  List<String> _allCategories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedCategories);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final repository = di.sl<AuthRepository>();
    final result = await repository.getCategories(page: 1, pageSize: 50);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _error = failure.message;
          _isLoading = false;
        });
      },
      (categories) {
        setState(() {
          _allCategories = categories.map((c) => c.name).toList();
          _isLoading = false;
        });
      },
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_tempSelected.contains(category)) {
        _tempSelected.remove(category);
      } else {
        _tempSelected.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Project’s categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33354E),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempSelected = List.from(_allCategories);
                    });
                  },
                  child: const Text(
                    'Select all',
                    style: TextStyle(
                      color: Color(0xFF66BB6A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempSelected.clear();
                    });
                  },
                  child: const Text(
                    'Clear selection',
                    style: TextStyle(
                      color: Color(0xFF66BB6A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Selection List
            Flexible(
              child: Builder(
                builder: (context) {
                  if (_isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (_error != null) {
                    return const Center(
                      child: Text('Failed to load categories'),
                    );
                  }

                  if (_allCategories.isEmpty) {
                    return const Center(
                      child: Text('No categories available'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _allCategories.length,
                    itemBuilder: (context, index) {
                      final category = _allCategories[index];
                      final isSelected = _tempSelected.contains(category);
                      return InkWell(
                        onTap: () => _toggleCategory(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF5F5F5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (val) =>
                                      _toggleCategory(category),
                                  activeColor: const Color(0xFF33354E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF33354E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_tempSelected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
