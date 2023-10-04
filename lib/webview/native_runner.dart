import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/app_util.dart';
import 'native_interface.dart';

class NativeRunner {
  static const String CHANNEL = "ni";

  final WebViewController controller;
  Function(NativeError, String)? errorCallback;

  bool _isLayerOpened = false;
  bool _isSideOpened = false;

  NativeRunner(this.controller) {
    controller.addJavaScriptChannel(CHANNEL, onMessageReceived: (jsonMsg) async {
      AppUtil.printHighlightLog("msg: $jsonMsg");
      Map<String, dynamic> map = jsonDecode(jsonMsg.message) as Map<String, dynamic>;

      WebViewMessage msg = WebViewMessage.fromJson(map);
      NativeInterface? ni = NativeInterface.from(msg.name);

      if (ni == null) {
        errorCallback?.call(NativeError.noSuchInterface, "");
        return;
      }

      String? resultJson = await handleNativeMessage(ni, msg.params);
      String? callback = msg.callback;
      if (callback != null) {
        controller.runJavaScript("$callback(${resultJson ?? ""});");
      }
    });
  }

  void setErrorCallback(Function(NativeError, String)? callback) {
    errorCallback = callback;
  }

  Future<String?> handleNativeMessage<T>(NativeInterface ni, Map params) async {
    switch (ni) {
    // TODO
      case NativeInterface.showToast:
        NativeRunner.runToastProvider(params);
        return null;

      case NativeInterface.setLayerOpened:
        _setLayerOpened(params);
        return null;
      case NativeInterface.setSideOpened:
        _setSideOpened(params);
        return null;

      case NativeInterface.test:
        AppUtil.printHighlightLog("NativeInterface.test: $params");
        await Future.delayed(const Duration(milliseconds: 2500));
        return jsonEncode("is it work?");
    }
  }

  static void runToastProvider(params) {
    if (params['message'] != null) {
      Fluttertoast.showToast(msg: params['message']);
    }
    return;
  }

  void _setLayerOpened(Map param) {
    bool? opened = _tryParse(param["opened"]);
    if (opened != null) {
      _isLayerOpened = opened;
    }
  }

  void _setSideOpened(Map param) {
    bool? opened = _tryParse(param["opened"]);
    if (opened != null) {
      _isSideOpened = opened;
    }
  }

  bool handleBack() {
    if (_isSideOpened) {
      controller.runJavaScript("javascript:sideMenuClose();");
      return true;
    } else if (_isLayerOpened) {
      controller.runJavaScript("javascript:layout_last_remove(\$('#atchFileId').val());");
      return true;
    } else {
      return false;
    }
  }

  bool? _tryParse(String value) {
    if (value.toLowerCase() == "true") {
      return true;
    } else if (value.toLowerCase() == "false") {
      return false;
    }
    return null;
  }
}
