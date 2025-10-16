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

import '../services/database/database_service.dart' as _i247;
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
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
