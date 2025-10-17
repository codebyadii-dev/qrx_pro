import 'package:injectable/injectable.dart';
import 'package:qrx_pro/common/cubit/base_cubit.dart';
import 'package:qrx_pro/features/history/data/repositories/history_repository_impl.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';

@injectable
class HistoryCubit extends BaseCubit<List<HistoryItem>> {
  final IHistoryRepository _historyRepository;

  HistoryCubit(this._historyRepository) : super();

  Future<void> loadHistory() async {
    await run(() => _historyRepository.getHistoryItems());
  }
}
