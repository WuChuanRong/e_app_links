import 'dart:async';
import 'package:app_links/src/app_links_platform_interface.dart';

class AppLinks extends AppLinksPlatform {
  /// Android App Links, Deep Links,
  /// iOS Universal Links and Custom URL schemes handler.
  AppLinks();

  @override
  Future<Uri?> getInitialAppLink() {
    return AppLinksPlatform.instance.getInitialAppLink();
  }

  @override
  Future<String?> getInitialAppLinkString() async {
    return AppLinksPlatform.instance.getInitialAppLinkString();
  }

  @override
  Future<Uri?> getLatestAppLink() async {
    return AppLinksPlatform.instance.getLatestAppLink();
  }

  @override
  Future<String?> getLatestAppLinkString() async {
    return AppLinksPlatform.instance.getLatestAppLinkString();
  }

  @override
  Stream<String> get stringLinkStream {
    return AppLinksPlatform.instance.stringLinkStream;
  }

  @override
  Stream<Uri> get uriLinkStream {
    return AppLinksPlatform.instance.uriLinkStream;
  }

  @override
  Stream<String> get allStringLinkStream {
    return AppLinksPlatform.instance.allStringLinkStream;
  }

  @override
  Stream<Uri> get allUriLinkStream {
    return AppLinksPlatform.instance.allUriLinkStream;
  }




  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<Map<String, dynamic>?> getInitialReferrerURL() async {
    return AppLinksPlatform.instance.getInitialReferrerURL();
  }
  @override
  Stream<Map<String, dynamic>> get referrerURLStream {
    return AppLinksPlatform.instance.referrerURLStream;
  }
  @override
  Stream<Map<String, dynamic>> get allReferrerURLStream {
    return AppLinksPlatform.instance.allReferrerURLStream;
  }


}
