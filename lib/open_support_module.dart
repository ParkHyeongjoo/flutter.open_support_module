
import 'open_support_module_platform_interface.dart';

class OpenSupportModule {
  Future<String?> getPlatformVersion() {
    return OpenSupportModulePlatform.instance.getPlatformVersion();
  }
}
