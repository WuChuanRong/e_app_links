import 'dart:async';

import 'package:flutter/services.dart';
import 'app_links_platform_interface.dart';

class AppLinksMethodChannel extends AppLinksPlatform {
  /// Channel names
  static const String _messagesChannel = 'com.llfbandit.app_links/messages';
  static const String _eventsChannel = 'com.llfbandit.app_links/events';

  /// Channel handlers
  static const _method = MethodChannel(_messagesChannel);
  static const _event = EventChannel(_eventsChannel);

  /// [getInitialAppLink] method call name
  static const String _getInitialAppLinkMethod = 'getInitialAppLink';

  /// [getLatestAppLink] method call name
  static const String _getLatestAppLinkMethod = 'getLatestAppLink';

  @override
  Future<Uri?> getInitialAppLink() async {
    final result = await getInitialAppLinkString();
    return result != null ? Uri.tryParse(result) : null;
  }

  @override
  Future<String?> getInitialAppLinkString() async {
    final link = await _method.invokeMethod<String?>(_getInitialAppLinkMethod);
    return link != null && link.isNotEmpty ? link : null;
  }

  @override
  Future<Uri?> getLatestAppLink() async {
    final result = await getLatestAppLinkString();
    return result != null ? Uri.tryParse(result) : null;
  }

  @override
  Future<String?> getLatestAppLinkString() async {
    final link = await _method.invokeMethod<String?>(_getLatestAppLinkMethod);
    return link != null && link.isNotEmpty ? link : null;
  }

  // @override
  Stream<String> get stringLinkStream {
    return Stream.value('value');
    // return _event
    //     .receiveBroadcastStream()
    //     .where((link) => link != null && link.isNotEmpty)
    //     .map<String>((dynamic link) => link as String);
  }

  @override
  Stream<Uri> get uriLinkStream {
    return stringLinkStream.transform<Uri>(
      StreamTransformer<String, Uri>.fromHandlers(
        handleData: (String uri, EventSink<Uri> sink) {
          sink.add(Uri.parse(uri));
        },
      ),
    );
  }

  @override
  Stream<Uri> get allUriLinkStream async* {
    final initial = await getInitialAppLink();
    if (initial != null) yield initial;
    yield* uriLinkStream;
  }

  @override
  Stream<String> get allStringLinkStream async* {
    final initial = await getInitialAppLinkString();
    if (initial != null) yield initial;
    yield* stringLinkStream;
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  static const String _getInitialReferrerURLMethod = 'getInitialReferrerURL';

  @override
  Future<Map<String, dynamic>?> getInitialReferrerURL() async {
    final para = await _method.invokeMethod<dynamic>(_getInitialReferrerURLMethod);
    // <String, dynamic>
    return para != null && para.isNotEmpty ? formatParameter(para) : null;
  }
  // 从原生（iOS、Android）接收到的 Event 事件
  @override
  Stream<Map<String, dynamic>> get referrerURLStream {
    // return Stream.value({});
    return _event
        .receiveBroadcastStream()
        .where((link) => link != null && link.isNotEmpty)
        .map<Map<String, dynamic>>((dynamic link) => formatParameter(link));
  }
  // 整合 getInitialReferrerURL &  referrerURLStream
  @override
  Stream<Map<String, dynamic>> get allReferrerURLStream async* {
    final initial = await getInitialReferrerURL();
    if (initial != null) yield initial;
    yield* referrerURLStream;
  }

  Map<String, dynamic> formatParameter(dynamic parameter) {
    final tempMap = parameter as Map?;
    Map<String, dynamic> result = {};
    if (tempMap != null) {
      tempMap.entries.forEach((e) {
        result['${e.key}'] = e.value;
      });
    }
    return result;
  }

}
