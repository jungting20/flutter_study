import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN = 'ACCESS_TOKEN';
const REFRESH_TONKE_KEY = 'REFRESH_TONKE_KEY';

final emulatorUp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';
final ip  = Platform.isIOS ? simulatorIp : emulatorUp;

final storage = new FlutterSecureStorage();
