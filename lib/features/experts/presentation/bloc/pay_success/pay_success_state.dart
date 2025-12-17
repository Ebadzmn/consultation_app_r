import 'package:equatable/equatable.dart';
import '../../models/pay_now_args.dart';

class PaySuccessState extends Equatable {
  final PayNowArgs args;

  const PaySuccessState({required this.args});

  @override
  List<Object?> get props => [args];
}

