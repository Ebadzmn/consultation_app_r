import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:consultant_app/core/config/app_routes.dart';
import '../bloc/pay_success/pay_success_bloc.dart';
import '../bloc/pay_success/pay_success_event.dart';
import '../bloc/pay_success/pay_success_state.dart';
import '../models/pay_now_args.dart';

class PaySuccessPage extends StatelessWidget {
  final PayNowArgs args;

  const PaySuccessPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaySuccessBloc(args: args),
      child: const _PaySuccessContent(),
    );
  }
}

class _PaySuccessContent extends StatelessWidget {
  const _PaySuccessContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<PaySuccessBloc, PaySuccessState>(
          builder: (context, state) {
            final args = state.args;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 36),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 34,
                            color: Color(0xFF66BB6A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Консультация\nоплачена успешно',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E2E3E),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Эксперт',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF90A4AE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 14),
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(args.expert.avatarUrl),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.person),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          args.expert.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF33354E),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: [
                            ...args.expert.tags
                                .take(3)
                                .map((t) => _TagChip(text: t)),
                            if (args.expert.tags.length > 3)
                              _TagChip(
                                text: '+${args.expert.tags.length - 3}',
                                muted: true,
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF90A4AE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatDate(context, args.date),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2E2E3E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF90A4AE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          args.time,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2E2E3E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Европа/Москва +03:00',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB0BEC5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF90A4AE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          args.comment.isEmpty ? '-' : args.comment,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2E2E3E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PaySuccessBloc>().add(
                          PaySuccessMoveToProfilePressed(),
                        );
                        context.go(AppRoutes.myProfile);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Move to you profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('MMMM d', locale).format(date);
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
