import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_ds.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'features/experts/data/repositories/experts_repository_impl.dart';
import 'features/experts/domain/repositories/experts_repository.dart';
import 'features/experts/domain/usecases/get_experts_usecase.dart';
import 'features/experts/presentation/bloc/experts_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => SignUpBloc(signUpUseCase: sl()),
  );
  sl.registerFactory(
    () => ExpertsBloc(getExperts: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetExpertsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ExpertsRepository>(
    () => ExpertsRepositoryImpl(),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
}
