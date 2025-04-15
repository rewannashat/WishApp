import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wish/domian/local/sharedPref.dart';

import '../../More/playList_viewModel/playList_model.dart';
import '../deviceData_view.dart';
import '../splash_view.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  BuildContext? context;

  String macAddress = '';
  String deviceType = Platform.isAndroid ? 'android' : 'ios';
  String deviceKey = '';
  bool isTrialActive = true;

  bool _isDataLoaded = false;  // لضمان تحميل البيانات مرة واحدة فقط

  Future<bool> login() async {
    emit(FetchDataLoadingState());

    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        macAddress = androidInfo.id.substring(0, 12).toLowerCase();
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        macAddress = iosInfo.identifierForVendor ?? 'unknown_ios_mac';
      }

      final response = await Dio().post(
        'https://wish-omega-blush.vercel.app/user/checkMac',
        data: {
          'macAddress': macAddress,
          'type': deviceType,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        deviceKey = data['deviceKey'] ?? '';
        macAddress = data['macAddress'] ?? macAddress;
        isTrialActive = data['isTrialActive'] ?? false;

        final playlists = data['playlists'] ?? [];

        // Find the active playlist
        final activePlaylist = playlists.firstWhere(
              (playlist) => playlist['isActive'] == true,
          orElse: () => null,
        );
        // Save to SharedPreferences if found
        if (activePlaylist != null) {
          await SharedPreferencesHelper.saveData(key: 'playlist_name', value:activePlaylist['name']);
          await SharedPreferencesHelper.saveData(key: 'playlist_url', value:activePlaylist['url']);
        }
        await SharedPreferencesHelper.saveData(key: 'macAddress', value:macAddress);

        log('Received Device Key: $deviceKey $isTrialActive');

        if (isTrialActive) {
          if (!_isDataLoaded) {  // تأكد من أنه يتم تحميل البيانات مرة واحدة فقط
            _isDataLoaded = true;
            emit(FetchDataSucessState());  // بيانات النجاح
          }
          return true; // Login success
        } else {
          emit(FetchDataErrorState("Trial period expired"));
          return false; // Trial expired
        }
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } catch (e) {
      emit(FetchDataErrorState(e.toString()));
      return false;
    }
  }



  /// send data m3u  - add playlist - ///

  Future<void> addPlaylist({
    required String name,
    required String url,
  }) async {
    emit(AddPlayListLoadingState());

    try {
      final response = await Dio().post(
        'https://wish-omega-blush.vercel.app/playList/addFromApp',
        data: {
          'macAddress': macAddress,
          'name': name,
          'url': url,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> allPlaylistsJson = data['allPlaylists'];
        final List<Playlist> playlists = allPlaylistsJson.map((json) => Playlist.fromJson(json)).toList();

        emit(AddPlayListSucessState(playlists));
      } else {
        emit(AddPlayListErrorState('Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AddPlayListErrorState(e.toString()));
    }
  }


  /// get all data playlist  ///

  Future<void> fetchPlaylists(String macAddress) async {
    try {
      emit(AddPlayListLoadingState()); // Show loading state

      final response = await Dio().get(
        'https://wish-omega-blush.vercel.app/playList/getToApp?macAddress=$macAddress',
      );

      if (response.statusCode == 404) {
        emit(GetPlayListErrorState(error: "API endpoint not found (404)."));
        return;
      }

      final data = response.data;
      if (data['message'] == 'Playlist fetched successfully') {
        List<dynamic> playlistData = data['playlists'];
        List<Playlist> playlists = playlistData.map((playlist) {
          return Playlist.fromJson(playlist);
        }).toList();

        // Emit success state with playlists if data is valid
        emit(GetPlayListSucessState(playlists: playlists));
      } else {
        emit(GetPlayListErrorState(error: 'Failed to fetch playlists: ${data['message']}'));
      }
    } catch (e) {
      // Catch and display any errors that happen during the request
      emit(GetPlayListErrorState(error: e.toString()));
    }
  }


  /// put data playlist  ///


  Future<void> activatePlaylist(String playlistId) async {
    try {
      emit(ActivePlayListLoadingState());

      final response = await Dio().put(
        'https://wish-omega-blush.vercel.app/playList/active/$playlistId',
      );

       log('Response data: ${response.data}');  // Log the response for debugging

      if (response.statusCode == 200 && response.data != null && response.data['allPlaylists'] != null) {
        final playlists = response.data['allPlaylists'];

        if (playlists is List) {
          final updatedPlaylists = playlists.map<Playlist>((playlistData) {
            return Playlist.fromJson(playlistData);
          }).toList();

          // Emit the state with updated playlists
          emit(ActivePlayListSucessState(updatedPlaylists));

          // Optionally, save the activated playlist in SharedPreferences
          final activePlaylist = updatedPlaylists.firstWhere(
                (playlist) => playlist.id == playlistId,
            orElse: () => updatedPlaylists.first,
          );

          await SharedPreferencesHelper.saveData(key: 'playlist_name', value: activePlaylist.name);
          await SharedPreferencesHelper.saveData(key: 'playlist_url', value: activePlaylist.url);
        //  await SharedPreferencesHelper.saveData(key: 'activePlaylistUrl', value: activePlaylist.url);
        } else {
          emit(ActivePlayListErrorState('Error: Playlists data is not in the correct format.'));
        }
      } else {
        emit(ActivePlayListErrorState('Error: No playlists data found.'));
      }
    } catch (error) {
      emit(ActivePlayListErrorState('Error: $error'));
    }
  }























}
