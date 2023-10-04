import 'package:flutter/material.dart';
import 'dart:math' show pi, sin, cos, tan, atan2, sqrt, pow, atan;
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUtil {
  static init() {}

  static bool isEmptyList<T>(List<T>? list) {
    if (list == null) {
      return true;
    }

    return list.isEmpty;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  static void printLog(Object log) {
    // TODO 릴리즈 출력 설정

    developer.log(log.toString());
  }

  static void printErrorLog(Object obj) {
    String log = "";
    if (Platform.isAndroid) {
      log = '\x1B[31m$obj\x1B[0m';
    } else if (Platform.isIOS) {
      log = '\u{26D4}$obj';
    }

    _print(log);
  }

  static void printWarningLog(Object obj) {
    String log = "";
    if (Platform.isAndroid) {
      log = '\x1B[31m$obj\x1B[0m';
    } else if (Platform.isIOS) {
      log = '\u{26A0}$obj';
    }

    _print(log);
  }

  static void printHighlightLog(Object obj) {
    String log = "";
    if (Platform.isAndroid) {
      log = '\x1B[31m$obj\x1B[0m';
    } else if (Platform.isIOS) {
      log = '\u{1F536}$obj';
    }

    _print(log);
  }

  static void _print(String logStr) {
    // TODO 릴리 로그 출력 설정
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss').format(now);

    if (Platform.isAndroid) {
      debugPrint('$formattedDate: $logStr');
    } else if (Platform.isIOS) {
      developer.log('$formattedDate: $logStr');
    }
  }

  static double getDistanceMeter(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // metres

    var p1 = lat1 * pi / 180; // φ, λ in radians
    var p2 = lat2 * pi / 180;

    var dp = (lat2 - lat1) * pi / 180;
    var dl = (lon2 - lon1) * pi / 180;

    var a = sin(dp / 2) * sin(dp / 2) + cos(p1) * cos(p2) * sin(dl / 2) * sin(dl / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    var d = R * c; // in metres

    return d;
  }

  static double getDistanceMeter2(double lat1, double lon1, double lat2, double lon2) {
    int MAXITERS = 20;
    // Convert lat/long to radians
    lat1 *= pi / 180.0;
    lat2 *= pi / 180.0;
    lon1 *= pi / 180.0;
    lon2 *= pi / 180.0;

    double a = 6378137.0; // WGS84 major axis
    double b = 6356752.3142; // WGS84 semi-major axis
    double f = (a - b) / a;
    double aSqMinusBSqOverBSq = (a * a - b * b) / (b * b);

    double L = lon2 - lon1;
    double A = 0.0;
    double U1 = atan((1.0 - f) * tan(lat1));
    double U2 = atan((1.0 - f) * tan(lat2));

    double cosU1 = cos(U1);
    double cosU2 = cos(U2);
    double sinU1 = sin(U1);
    double sinU2 = sin(U2);
    double cosU1cosU2 = cosU1 * cosU2;
    double sinU1sinU2 = sinU1 * sinU2;

    double sigma = 0.0;
    double deltaSigma = 0.0;
    double cosSqAlpha;
    double cos2SM;
    double cosSigma;
    double sinSigma;
    double cosLambda = 0.0;
    double sinLambda = 0.0;

    double lambda = L; // initial guess
    for (int iter = 0; iter < MAXITERS; iter++) {
      double lambdaOrig = lambda;
      cosLambda = cos(lambda);
      sinLambda = sin(lambda);
      double t1 = cosU2 * sinLambda;
      double t2 = cosU1 * sinU2 - sinU1 * cosU2 * cosLambda;
      double sinSqSigma = t1 * t1 + t2 * t2; // (14)
      sinSigma = sqrt(sinSqSigma);
      cosSigma = sinU1sinU2 + cosU1cosU2 * cosLambda; // (15)
      sigma = atan2(sinSigma, cosSigma); // (16)
      double sinAlpha = (sinSigma == 0) ? 0.0 : cosU1cosU2 * sinLambda / sinSigma; // (17)
      cosSqAlpha = 1.0 - sinAlpha * sinAlpha;
      cos2SM = (cosSqAlpha == 0) ? 0.0 : cosSigma - 2.0 * sinU1sinU2 / cosSqAlpha; // (18)

      double uSquared = cosSqAlpha * aSqMinusBSqOverBSq; // defn
      A = 1 +
          (uSquared / 16384.0) * // (3)
              (4096.0 + uSquared * (-768 + uSquared * (320.0 - 175.0 * uSquared)));
      double B = (uSquared / 1024.0) * // (4)
          (256.0 + uSquared * (-128.0 + uSquared * (74.0 - 47.0 * uSquared)));
      double C = (f / 16.0) * cosSqAlpha * (4.0 + f * (4.0 - 3.0 * cosSqAlpha)); // (10)
      double cos2SMSq = cos2SM * cos2SM;
      deltaSigma = B *
          sinSigma * // (6)
          (cos2SM +
              (B / 4.0) *
                  (cosSigma * (-1.0 + 2.0 * cos2SMSq) -
                      (B / 6.0) * cos2SM * (-3.0 + 4.0 * sinSigma * sinSigma) * (-3.0 + 4.0 * cos2SMSq)));

      lambda = L +
          (1.0 - C) *
              f *
              sinAlpha *
              (sigma + C * sinSigma * (cos2SM + C * cosSigma * (-1.0 + 2.0 * cos2SM * cos2SM))); // (11)

      double delta = (lambda - lambdaOrig) / lambda;
      if (delta.abs() < 1.0e-12) {
        break;
      }
    }

    return (b * A * (sigma - deltaSigma));
  }

  static double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }
}