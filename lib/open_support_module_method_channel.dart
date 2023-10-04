import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'open_support_module_platform_interface.dart';

/// An implementation of [OpenSupportModulePlatform] that uses method channels.
class MethodChannelOpenSupportModule extends OpenSupportModulePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('open_support_module');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
