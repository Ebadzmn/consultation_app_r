import 'package:equatable/equatable.dart';

abstract class PaySuccessEvent extends Equatable {
  const PaySuccessEvent();

  @override
  List<Object?> get props => [];
}

class PaySuccessMoveToProfilePressed extends PaySuccessEvent {}

