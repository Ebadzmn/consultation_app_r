import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:consultant_app/l10n/app_localizations.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import '../../domain/entities/expert_entity.dart';
import '../bloc/appointment/appointment_bloc.dart';
import '../bloc/appointment/appointment_event.dart';
import '../bloc/appointment/appointment_state.dart';
import '../models/pay_now_args.dart';
import '../widgets/appointment_calendar.dart';

class AppointmentPage extends StatelessWidget {
  final ExpertEntity expert;

  const AppointmentPage({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentBloc(
        expertId: expert.id,
        initialDate: DateTime.now(),
        getAvailableWorkDatesUseCase: sl(),
        getAvailableTimeSlotsUseCase: sl(),
      )
        ..add(LoadAvailableWorkDates(expert.id))
        ..add(AppointmentDateChanged(DateTime.now())),
      child: _AppointmentContent(expert: expert),
    );
  }
}

class _AppointmentContent extends StatelessWidget {
  final ExpertEntity expert;

  const _AppointmentContent({required this.expert});

  static const List<String> _categories = ['Finance', 'Banking', 'IT'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33354E),
        elevation: 0,
        leading: const SizedBox.shrink(),
        titleSpacing: -34,
        title: Text(
          l10n.appointmentTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: BlocConsumer<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state.status == AppointmentStatus.success) {
            final time = state.selectedTime;
            if (time == null) return;
            context.push(
              AppRoutes.payNow,
              extra: PayNowArgs(
                expert: expert,
                price: expert.price,
                date: state.selectedDate,
                time: time,
                category: state.selectedCategory,
                comment: state.comment,
                payWithin: const Duration(days: 2, hours: 14, minutes: 45),
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedHeaderDelegate(
                  height: 140,
                  child: _buildPinnedExpertHeader(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        l10n.chooseDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF33354E),
                        ),
                      ),
                    ),
                    if (state.status ==
                        AppointmentStatus.loadingAvailability) ...[
                      const SizedBox(height: 50),
                      const Center(child: CircularProgressIndicator.adaptive()),
                      const SizedBox(height: 50),
                    ] else ...[
                      AppointmentCalendar(
                        selectedDate: state.selectedDate,
                        notWorkingDates: state.notWorkingDates,
                        onDateSelected: (date) {
                          context.read<AppointmentBloc>().add(
                            AppointmentDateChanged(date),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        l10n.chooseTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF33354E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTimeSelector(context, state),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Европа/Москва +03:00',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF90A4AE),
                        ),
                      ),
                    ),
                    if (state.showSlotWarning) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE53935),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  'This slot is unavailable\nPlease select another time',
                                  style: TextStyle(
                                    color: Color(0xFFE53935),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () {
                                  context.read<AppointmentBloc>().add(
                                    AppointmentSlotWarningDismissed(),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xFFE53935),
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        l10n.comments,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF33354E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        maxLines: 4,
                        onChanged: (value) {
                          context.read<AppointmentBloc>().add(
                            AppointmentCommentChanged(value),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: l10n.commentHint,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        l10n.category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF33354E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: state.selectedCategory,
                            hint: Text(
                              l10n.chooseCategory,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: _categories.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                context.read<AppointmentBloc>().add(
                                  AppointmentCategoryChanged(newValue),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                              label: 'Стоимость консультации',
                              value: _formatRuble(context, expert.price),
                              valueEmphasis: true,
                            ),
                            const SizedBox(height: 10),
                            _buildSummaryRow(
                              label: 'Дата',
                              value: _formatDateShort(
                                context,
                                state.selectedDate,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSummaryRow(
                              label: 'Время',
                              value: state.selectedTime == null
                                  ? '-'
                                  : '${state.selectedTime} мск',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AppointmentBloc>().add(
                              AppointmentSubmitted(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              133,
                              235,
                              136,
                            ),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.book,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPinnedExpertHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: _buildExpertHeader(context),
      ),
    );
  }

  Widget _buildExpertHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(expert.avatarUrl),
            onBackgroundImageError: (_, __) => const Icon(Icons.person),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${expert.rating}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.reviews}: ${expert.reviewsCount} ${l10n.articles}: ${expert.articlesCount} ${l10n.polls}: ${expert.pollsCount}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  expert.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33354E),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: expert.tags.take(3).map((area) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getColorForArea(area),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        area,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getTextColorForArea(area),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForArea(String area) {
    // Just some random colors based on the UI screenshot logic
    if (area == 'Finance' || area == 'Финансы') return const Color(0xFFFFF59D);
    if (area == 'Banking' || area == 'Банки') return const Color(0xFFC8E6C9);
    if (area == 'IT' || area == 'ИТ') return const Color(0xFFBBDEFB);
    return Colors.grey[200]!;
  }

  Color _getTextColorForArea(String area) {
    if (area == 'Finance' || area == 'Финансы') return const Color(0xFFFBC02D);
    if (area == 'Banking' || area == 'Банки') return const Color(0xFF388E3C);
    if (area == 'IT' || area == 'ИТ') return const Color(0xFF1976D2);
    return Colors.black87;
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool valueEmphasis = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF33354E),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF33354E),
            fontWeight: valueEmphasis ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatRuble(BuildContext context, int price) {
    final locale = Localizations.localeOf(context).toString();
    final formatted = NumberFormat.decimalPattern(locale).format(price);
    return '$formatted₽';
  }

  String _formatDateShort(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('d MMMM', locale).format(date);
  }

  Widget _buildTimeSelector(BuildContext context, AppointmentState state) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: state.timeSlots.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final time = state.timeSlots[index];
          final isSelected = time == state.selectedTime;
          final isUnavailable = state.unavailableTimes.contains(time);
          return GestureDetector(
            onTap: () {
              context.read<AppointmentBloc>().add(AppointmentTimeChanged(time));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isUnavailable
                    ? const Color(0xFFF1F3F5)
                    : (isSelected ? const Color(0xFF66BB6A) : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUnavailable
                      ? const Color(0xFFE0E0E0)
                      : (isSelected
                            ? const Color(0xFF66BB6A)
                            : Colors.grey[300]!),
                ),
              ),
              child: Text(
                time,
                style: TextStyle(
                  color: isUnavailable
                      ? const Color(0xFFB0BEC5)
                      : (isSelected ? Colors.white : const Color(0xFF33354E)),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const _PinnedHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}
