import 'package:equatable/equatable.dart';

abstract class PayNowEvent extends Equatable {
  const PayNowEvent();

  @override
  List<Object?> get props => [];
}

class PayNowTicked extends PayNowEvent {
  final Duration remaining;

  const PayNowTicked(this.remaining);

  @override
  List<Object?> get props => [remaining];
}

class PayNowPressed extends PayNowEvent {}

class PayLaterPressed extends PayNowEvent {}

