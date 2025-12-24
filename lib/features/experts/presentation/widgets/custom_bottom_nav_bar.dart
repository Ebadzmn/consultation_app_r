import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import 'package:consultant_app/features/experts/presentation/widgets/add_menu_popup.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.star_border_rounded,
            label: l10n.experts,
            isSelected: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) {
                context.go(AppRoutes.experts);
              }
            },
          ),
          _NavBarItem(
            icon: Icons.bolt_rounded,
            label: l10n.materials,
            isSelected: currentIndex == 1,
            onTap: () {
              // Navigate to Materials if route exists
            },
          ),
          const _AddButton(),
          _NavBarItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: l10n.consultations,
            isSelected: currentIndex == 3,
            onTap: () {
              if (currentIndex != 3) {
                context.go(AppRoutes.consultations);
              }
            },
          ),
          _NavBarItem(
            icon: Icons.help_outline_rounded,
            label: l10n.questions,
            isSelected: currentIndex == 4,
            onTap: () {
              // Navigate to Questions if route exists
            },
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFF33354E) : Colors.grey[400];
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  void _showAddMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background to dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: () => overlayEntry.remove(),
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Popup
          Positioned(
            left: offset.dx - (280 - size.width) / 2, // Center horizontally
            top: offset.dy - 350, // Approximate height of menu
            child: const AddMenuPopup(),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddMenu(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF33354E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF33354E).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
