enum NativeError {
  noSuchInterface,
  wrongInputParams,
  unknown;
}

class WebViewMessage {
  String name;
  Map params;
  String? callback;

  WebViewMessage(this.name, this.params, this.callback);

  WebViewMessage.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        params = json['params'] ?? {},
        callback = json['callback'];
}

enum NativeInterface {
  showToast("showToast"),
  // runLocator("runLocator"),
  // stopLocator("stopLocator"),
  // sendFcmToken("sendFcmToken"),
  // runKakaoNavi("runKakaoNavi"),
  // runTMap("runTMap"),
  // requestNotiPermission("requestNotiPermission"),
  // checkNotiPermission("checkNotiPermission"),

  setLayerOpened("setLayerOpened"),
  setSideOpened("setSideOpened"),

  test("test"),
  ;

  const NativeInterface(this.name);

  final String? name;

  static NativeInterface? from(String name) {
    for (NativeInterface ni in NativeInterface.values) {
      if (ni.name == name) {
        return ni;
      }
    }

    return null;
  }
}