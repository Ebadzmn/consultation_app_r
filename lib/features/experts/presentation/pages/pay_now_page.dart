import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import '../../domain/entities/expert_entity.dart';
import '../bloc/pay_now/pay_now_bloc.dart';
import '../bloc/pay_now/pay_now_event.dart';
import '../bloc/pay_now/pay_now_state.dart';
import '../models/pay_now_args.dart';

class PayNowPage extends StatelessWidget {
  final PayNowArgs args;

  const PayNowPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PayNowBloc(args: args),
      child: const _PayNowContent(),
    );
  }
}

class _PayNowContent extends StatelessWidget {
  const _PayNowContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33354E),
        elevation: 0,
        leading: const SizedBox.shrink(),
        titleSpacing: -34,
        title: const Text(
          'Детали заказа',
          style: TextStyle(
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
      body: BlocConsumer<PayNowBloc, PayNowState>(
        listener: (context, state) {
          if (state.status == PayNowStatus.paid) {
            context.go(AppRoutes.paySuccess, extra: state.args);
          }
        },
        builder: (context, state) {
          final args = state.args;
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 16),
                      _ExpertInfoCard(expert: args.expert),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'Стоимость консультации'),
                      const SizedBox(height: 6),
                      _ValueText(text: _formatPrice(context, args.price)),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'Категория'),
                      const SizedBox(height: 8),
                      _CategoryChip(text: args.category ?? '-'),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'Date'),
                      const SizedBox(height: 6),
                      _ValueText(text: _formatPayNowDate(context, args.date)),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'Time'),
                      const SizedBox(height: 6),
                      _ValueText(text: args.time),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'Status'),
                      const SizedBox(height: 8),
                      _StatusChip(
                        text: state.status == PayNowStatus.paid
                            ? 'paid'
                            : 'not paid',
                        isPaid: state.status == PayNowStatus.paid,
                      ),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'Comment'),
                      const SizedBox(height: 6),
                      _ValueText(
                        text: args.comment.isEmpty ? '-' : args.comment,
                      ),
                      const SizedBox(height: 24),
                      _NeedToPayCard(remaining: state.remaining),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.status == PayNowStatus.paying
                              ? null
                              : () => context.read<PayNowBloc>().add(
                                  PayNowPressed(),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66BB6A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            state.status == PayNowStatus.paying
                                ? 'Paying...'
                                : 'Pay now',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () =>
                              context.read<PayNowBloc>().add(PayLaterPressed()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF33354E),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Pay later',
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
              ],
            ),
          );
        },
      ),
    );
  }

  static String _formatPrice(BuildContext context, int price) {
    final locale = Localizations.localeOf(context).toString();
    final formatted = NumberFormat.decimalPattern(locale).format(price);
    return '$formatted₽';
  }

  static String _formatPayNowDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('MMMM d', locale).format(date);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF90A4AE),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  final String text;

  const _ValueText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF2E2E3E),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String text;

  const _CategoryChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2CC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFFF59D00),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final bool isPaid;

  const _StatusChip({required this.text, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isPaid ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isPaid ? const Color(0xFF2E7D32) : const Color(0xFFE53935),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ExpertInfoCard extends StatelessWidget {
  final ExpertEntity expert;

  const _ExpertInfoCard({required this.expert});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    'Отзывов: ${expert.reviewsCount}  Статей: ${expert.articlesCount}  Опросов: ${expert.pollsCount}',
                    style: const TextStyle(
                      color: Color(0xFF90A4AE),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
                runSpacing: 6,
                children: [
                  ...expert.tags.take(3).map((t) => _TagChip(text: t)),
                  if (expert.tags.length > 3)
                    _TagChip(text: '+${expert.tags.length - 3}', muted: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final bool muted;

  const _TagChip({required this.text, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final bg = muted ? const Color(0xFFECEFF1) : const Color(0xFFFFF2CC);
    final fg = muted ? const Color(0xFF607D8B) : const Color(0xFFF59D00);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: fg, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _NeedToPayCard extends StatelessWidget {
  final Duration remaining;

  const _NeedToPayCard({required this.remaining});

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24);
    final minutes = remaining.inMinutes.remainder(60);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Need to pay',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF33354E),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimeUnit(value: days, label: 'day'),
              const _Colon(),
              _TimeUnit(value: hours, label: 'hour'),
              const _Colon(),
              _TimeUnit(value: minutes, label: 'min'),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'You can pay not later than\nor your appointment will be cancelled',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;

  const _TimeUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E3E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF90A4AE),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF90A4AE),
        ),
      ),
    );
  }
}
