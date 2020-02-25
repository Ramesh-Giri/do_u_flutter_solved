import 'package:get_it/get_it.dart';
import 'package:iremember/core/services/item_service.dart';
import 'package:iremember/core/view_models/item_model.dart';
import 'core/services/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => API());

  locator.registerLazySingleton(() => ItemService());
  locator.registerFactory(() => ItemModel());

}
