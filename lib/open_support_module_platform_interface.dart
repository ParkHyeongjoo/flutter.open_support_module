import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'open_support_module_method_channel.dart';

abstract class OpenSupportModulePlatform extends PlatformInterface {
  /// Constructs a OpenSupportModulePlatform.
  OpenSupportModulePlatform() : super(token: _token);

  static final Object _token = Object();

  static OpenSupportModulePlatform _instance = MethodChannelOpenSupportModule();

  /// The default instance of [OpenSupportModulePlatform] to use.
  ///
  /// Defaults to [MethodChannelOpenSupportModule].
  static OpenSupportModulePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpenSupportModulePlatform] when
  /// they register themselves.
  static set instance(OpenSupportModulePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
