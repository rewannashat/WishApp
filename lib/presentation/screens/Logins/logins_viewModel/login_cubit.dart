import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_states.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  // == Fetch DeviceData LOGIC == //
  String macAddress = 'Fetching...';
//  String deviceKey = 'Fetching...';

  Future<void> fetchDeviceData() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String uniqueId = androidInfo.id; // Unique ID for the device

      // Use androidInfo properties for device identification
      macAddress = uniqueId.substring(0, 12).toUpperCase();
    //  deviceKey = uniqueId.substring(0, 6).toUpperCase();
      log('deviceInfo $macAddress ');
      emit(FetchDataSucessState());
    } catch (e) {
      log('Error fetching device data: $e');
      emit(FetchDataErrorState(e.toString()));
    }
  }
}