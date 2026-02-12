import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:consultant_app/core/network/dio_client.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../models/pay_now_args.dart';
import 'package:consultant_app/core/config/app_routes.dart';

class PaymentMethodPage extends StatelessWidget {
  final PayNowArgs args;

  const PaymentMethodPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33354E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Вернуться назад',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Выберите способ оплаты',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // YoMoney Card
                    _PaymentMethodCard(
                      onTap: () {},
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9035FF),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Ю',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'money',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF33354E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Только карты РФ',
                            style: TextStyle(
                              color: Color(0xFFB0BACB),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // International Payments Card
                    _PaymentMethodCard(
                      onTap: () {},
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCardIcon('VISA', Colors.blue[800]!),
                              const SizedBox(width: 8),
                              _buildCardIcon('MC', Colors.orange[800]!),
                              const SizedBox(width: 8),
                              _buildCardIcon('PP', Colors.blue[600]!),
                              const SizedBox(width: 8),
                              _buildCardIcon('UP', Colors.green[800]!),
                              const SizedBox(width: 8),
                              _buildCardIcon('JCB', Colors.blue[900]!),
                              const SizedBox(width: 8),
                              _buildCardIcon('AMEX', Colors.blue[400]!),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Международные оплаты',
                            style: TextStyle(
                              color: Color(0xFFB0BACB),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final router = GoRouter.of(context);
                    final appointmentId = args.appointmentId;
                    if (appointmentId == null) {
                      return;
                    }
                    try {
                      final dioClient = di.sl<DioClient>();
                      final numericId = int.tryParse(appointmentId);
                      final response = await dioClient.post(
                        '/payments/checkout/yookassa/',
                        data: {
                          'appointment_id': numericId ?? appointmentId,
                        },
                      );
                      final data = response.data as Map<String, dynamic>;
                      final confirmationUrl =
                          data['confirmation_url'] as String;
                      final paymentId = data['payment_id'] as int;

                      await navigator.push(
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentWebViewPage(url: confirmationUrl),
                        ),
                      );

                      final statusResponse = await dioClient.get(
                        '/payments/$paymentId/status',
                      );
                      final statusData =
                          statusResponse.data as Map<String, dynamic>;
                      final rawStatus = statusData['status'];
                      final status = rawStatus is int
                          ? rawStatus
                          : int.tryParse(rawStatus.toString()) ?? -1;

                      if (status == 2) {
                        await navigator.push(
                          MaterialPageRoute(
                            builder: (_) => const PaymentFailedPage(),
                          ),
                        );
                      } else {
                        router.go(AppRoutes.paySuccess, extra: args);
                      }
                    } catch (_) {
                      await navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const PaymentFailedPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFD6EDD9,
                    ), // Light green from screenshot
                    foregroundColor: const Color(0xFFFFFFFF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Перейти к оплате',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardIcon(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PaymentMethodCard({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class PaymentWebViewPage extends StatelessWidget {
  final String url;

  const PaymentWebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text(
          'Payment was not completed',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
