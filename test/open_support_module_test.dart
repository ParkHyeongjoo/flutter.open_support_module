import 'package:flutter_test/flutter_test.dart';
import 'package:open_support_module/open_support_module.dart';
import 'package:open_support_module/open_support_module_platform_interface.dart';
import 'package:open_support_module/open_support_module_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpenSupportModulePlatform
    with MockPlatformInterfaceMixin
    implements OpenSupportModulePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OpenSupportModulePlatform initialPlatform = OpenSupportModulePlatform.instance;

  test('$MethodChannelOpenSupportModule is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpenSupportModule>());
  });

  test('getPlatformVersion', () async {
    OpenSupportModule openSupportModulePlugin = OpenSupportModule();
    MockOpenSupportModulePlatform fakePlatform = MockOpenSupportModulePlatform();
    OpenSupportModulePlatform.instance = fakePlatform;

    expect(await openSupportModulePlugin.getPlatformVersion(), '42');
  });
}
