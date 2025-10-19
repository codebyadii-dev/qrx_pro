// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/history/data/repositories/history_repository_impl.dart'
    as _i751;
import '../../features/history/presentation/cubit/history_cubit.dart' as _i232;
import '../../features/hub/data/repositories/hub_repository_impl.dart' as _i686;
import '../../features/scanner/presentation/cubit/url_metadata_cubit.dart'
    as _i1001;
import '../services/ai/ai_helper_service.dart' as _i272;
import '../services/database/database_service.dart' as _i247;
import '../services/device/device_info_service.dart' as _i1054;
import '../services/permissions/permission_service.dart' as _i202;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i583.GoRouter>(() => registerModule.router);
    await gh.lazySingletonAsync<_i247.DatabaseService>(
      () => _i247.DatabaseService.create(),
      preResolve: true,
    );
    gh.lazySingleton<_i202.PermissionService>(() => _i202.PermissionService());
    gh.lazySingleton<_i272.AiHelperService>(() => _i272.AiHelperService());
    gh.lazySingleton<_i1054.DeviceInfoService>(
        () => _i1054.DeviceInfoService());
    gh.lazySingleton<_i751.IHistoryRepository>(
        () => _i751.HistoryRepositoryImpl(gh<_i247.DatabaseService>()));
    gh.factory<_i232.HistoryCubit>(
        () => _i232.HistoryCubit(gh<_i751.IHistoryRepository>()));
    gh.lazySingleton<_i686.IHubRepository>(
        () => _i686.HubRepositoryImpl(gh<_i247.DatabaseService>()));
    gh.factory<_i1001.UrlMetadataCubit>(
        () => _i1001.UrlMetadataCubit(gh<_i272.AiHelperService>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
