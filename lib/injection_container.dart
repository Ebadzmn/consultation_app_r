import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/dio_client.dart';
import 'core/network/token_storage.dart';
import 'core/network/auth_interceptor.dart';
import 'core/network/logger_interceptor.dart';

import 'features/auth/domain/entities/user_entity.dart';
import 'features/auth/data/datasources/auth_remote_ds.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/get_categories_usecase.dart';
import 'features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';

import 'features/experts/data/repositories/experts_repository_impl.dart';
import 'features/experts/data/data_sources/experts_remote_data_source.dart';
import 'features/experts/domain/repositories/experts_repository.dart';
import 'features/experts/domain/usecases/get_experts_usecase.dart';
import 'features/experts/domain/usecases/create_project_use_case.dart';
import 'features/experts/domain/usecases/get_available_work_dates_use_case.dart';
import 'features/experts/domain/usecases/get_available_time_slots_use_case.dart';
import 'features/experts/domain/usecases/create_appointment_use_case.dart';
import 'features/experts/presentation/bloc/experts_bloc.dart';
import 'features/experts/domain/usecases/get_client_appointments_use_case.dart';
import 'features/experts/domain/usecases/get_expert_appointments_use_case.dart';

final sl = GetIt.instance;

final ValueNotifier<UserEntity?> currentUser = ValueNotifier<UserEntity?>(null);

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => SignUpBloc(
        signUpUseCase: sl(),
        getCategoriesUseCase: sl(),
      ));
  sl.registerFactory(() => LoginBloc(signInUseCase: sl()));
  sl.registerFactory(() => ExpertsBloc(getExperts: sl()));

  // Use cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetExpertsUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableWorkDatesUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableTimeSlotsUseCase(sl()));
  sl.registerLazySingleton(() => CreateAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => GetClientAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => GetExpertAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateProjectUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );
  sl.registerLazySingleton<ExpertsRepository>(
    () => ExpertsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ExpertsRemoteDataSource>(
    () => ExpertsRemoteDataSourceImpl(sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => TokenStorage(sl()));
  sl.registerLazySingleton(() => AuthInterceptor(sl(), sl()));
  sl.registerLazySingleton(() => LoggerInterceptor());

  sl.registerLazySingleton(() {
    final dioClient = DioClient(sl());
    dioClient.addInterceptor(sl<AuthInterceptor>());
    if (kDebugMode) {
      dioClient.addInterceptor(sl<LoggerInterceptor>());
    }
    return dioClient;
  });
}
