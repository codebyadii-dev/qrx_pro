import 'package:injectable/injectable.dart';
import 'package:qrx_pro/common/cubit/base_cubit.dart';
import 'package:qrx_pro/core/services/ai/ai_helper_service.dart';
import 'package:qrx_pro/features/scanner/domain/entities/url_metadata.dart';

@injectable
class UrlMetadataCubit extends BaseCubit<UrlMetadata> {
  final AiHelperService _aiHelperService;

  UrlMetadataCubit(this._aiHelperService) : super();

  /// Fetches metadata for the given URL and updates the state.
  Future<void> fetchMetadata(String url) async {
    // Our BaseCubit's run method handles loading/success/error states.
    await run(() => _aiHelperService.fetchUrlMetadata(url));
  }
}
