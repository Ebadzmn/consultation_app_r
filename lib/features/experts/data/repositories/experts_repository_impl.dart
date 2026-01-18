import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expert_entity.dart';
import '../../domain/entities/expert_profile.dart';
import '../../domain/repositories/experts_repository.dart';
import '../data_sources/experts_remote_data_source.dart';
import '../../domain/entities/available_work_dates_entity.dart';

class ExpertsRepositoryImpl implements ExpertsRepository {
  final ExpertsRemoteDataSource remoteDataSource;

  ExpertsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<ExpertEntity>>> getExperts() async {
    try {
      final experts =
          await remoteDataSource.getExperts(page: 1, pageSize: 10);
      return Right(experts);
    } catch (e) {
      return const Left(ServerFailure('Failed to load experts'));
    }
  }

  @override
  Future<Either<Failure, ExpertProfile>> getExpertProfile(
    String expertId,
  ) async {
    try {
      final profile = await remoteDataSource.getExpertProfile(expertId);
      return Right(profile);
    } catch (e) {
      return const Left(ServerFailure('Failed to load expert profile'));
    }
  }

  @override
  Future<Either<Failure, ExpertProfile>> getCurrentUserProfile() async {
    try {
      final profile = await remoteDataSource.getCurrentUserProfile();
      return Right(profile);
    } catch (e) {
      return const Left(ServerFailure('Failed to load current profile'));
    }
  }

  @override
  Future<Either<Failure, AvailableWorkDatesEntity>> getAvailableWorkDates(
    String expertId,
  ) async {
    try {
      final result = await remoteDataSource.getAvailableWorkDates(expertId);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Failed to load available dates'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableTimeSlots({
    required String expertId,
    required DateTime selectedDate,
  }) async {
    try {
      final result = await remoteDataSource.getAvailableTimeSlots(
        expertId,
        selectedDate,
      );
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Failed to load available timeslots'));
    }
  }

  @override
  Future<Either<Failure, void>> createAppointment({
    required String expertId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required int categoryId,
    required String notes,
  }) async {
    try {
      await remoteDataSource.createAppointment(
        expertId: expertId,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        categoryId: categoryId,
        notes: notes,
      );
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to create appointment'));
    }
  }
}
