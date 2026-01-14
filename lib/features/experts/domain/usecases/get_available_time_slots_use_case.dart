import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/experts_repository.dart';

class GetAvailableTimeSlotsUseCase
    implements UseCase<List<String>, GetAvailableTimeSlotsParams> {
  final ExpertsRepository repository;

  GetAvailableTimeSlotsUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(
    GetAvailableTimeSlotsParams params,
  ) async {
    return repository.getAvailableTimeSlots(
      expertId: params.expertId,
      selectedDate: params.selectedDate,
    );
  }
}

class GetAvailableTimeSlotsParams extends Equatable {
  final String expertId;
  final DateTime selectedDate;

  const GetAvailableTimeSlotsParams({
    required this.expertId,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [expertId, selectedDate];
}

