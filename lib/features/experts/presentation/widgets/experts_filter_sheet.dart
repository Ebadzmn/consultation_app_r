import 'package:flutter/material.dart';

class ExpertsFilterSheet extends StatefulWidget {
  const ExpertsFilterSheet({super.key});

  @override
  State<ExpertsFilterSheet> createState() => _ExpertsFilterSheetState();
}

class _ExpertsFilterSheetState extends State<ExpertsFilterSheet> {
  String selectedSort = 'Popular';
  String category = 'All';
  String rating = '4 and above';

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
          
          // Dropdowns
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildDropdown(
                  label: 'Category:',
                  value: category,
                  items: ['All', 'IT', 'Finance', 'Banking'],
                  onChanged: (val) => setState(() => category = val!),
                ),
                const Spacer(),
                _buildDropdown(
                  label: 'Rating:',
                  value: rating,
                  items: ['4 and above', '4.5 and above', '5 only'],
                  onChanged: (val) => setState(() => rating = val!),
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
          _buildMenuItem(
            icon: Icons.account_balance,
            text: 'Banks',
            isSelected: selectedSort == 'Banks',
            onTap: () => setState(() => selectedSort = 'Banks'),
          ),
          _buildMenuItem(
            icon: Icons.monetization_on, // Closest to coin stack
            text: 'Finance',
            isSelected: selectedSort == 'Finance',
            onTap: () => setState(() => selectedSort = 'Finance'),
          ),
          _buildMenuItem(
            icon: Icons.code, // Braces
            text: 'IT',
            isSelected: selectedSort == 'IT',
            onTap: () => setState(() => selectedSort = 'IT'),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
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
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF2E2E3E)),
            style: const TextStyle(
              color: Color(0xFF2E2E3E),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
