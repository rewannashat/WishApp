import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wish/presentation/screens/More/playList_viewModel/playList_model.dart';
import '../../../../domian/local/sharedPref.dart';
import '../../../resources/colors-manager.dart';
import '../../../resources/styles-manager.dart';
import '../../Logins/logins_viewModel/login_cubit.dart';
import '../../Logins/logins_viewModel/login_states.dart';

class PlaylistsView extends StatefulWidget {
  const PlaylistsView({super.key});

  @override
  _PlaylistsViewState createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView> {
  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the screen is loaded
  }

  void _fetchData() {
    BlocProvider.of<LoginCubit>(context).fetchPlaylists(SharedPreferencesHelper.getData(key: 'macAddress'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Playlists',
          style: getSemiBoldTextStyle(
            color: ColorsManager.whiteColor,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          const Icon(Icons.search, color: Colors.white),
          SizedBox(width: 16.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
                if (state is AddPlayListLoadingState || state is ActivePlayListLoadingState || state is GetPlayListLoadingState) {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  );
                } else if (state is AddPlayListSucessState ||
                    state is GetPlayListSucessState ||
                    state is ActivePlayListSucessState) {
                  final playlists = state is AddPlayListSucessState
                      ? state.playlists
                      : state is GetPlayListSucessState
                      ? state.playlists
                      : (state as ActivePlayListSucessState).playlists;
                  return _buildPlaylistGridView(playlists, context);
                } else if (state is AddPlayListErrorState ||
                    state is GetPlayListErrorState ||
                    state is ActivePlayListErrorState) {
                  return Center(
                    child: Text(
                      'Error: ${state is AddPlayListErrorState
                          ? state.error
                          : (state is GetPlayListErrorState
                          ? state.error
                          : (state as ActivePlayListErrorState).error)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistGridView(List<Playlist> playlists, BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.8,
      ),
      itemCount: playlists.length + 1,
      itemBuilder: (context, index) {
        if (index == playlists.length) {
          return GestureDetector(
            onTap: () {
              _showAddPlaylistDialog(context);
            },
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff4f4e4e),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [Color(0xFF1C1C1E), Color(0xFF26262A), Color(0xFF3E3E45)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Color(0xff4f4e4e),
                  size: 40.0,
                ),
              ),
            ),
          );
        } else {
          final playlist = playlists[index];
          final title = playlist.name;
          final status = playlist.isActive ? 'Currently Online' : 'Currently Offline';
          final statusColor = playlist.isActive ? Colors.green : Colors.red;

          return GestureDetector(
            onTap: () {
              BlocProvider.of<LoginCubit>(context).activatePlaylist(playlist.id);
            },
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff4f4e4e),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [Colors.black, Colors.black87],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white.withOpacity(0.2),
                    size: 50.sp,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: getRegularTitleStyle(
                          color: ColorsManager.whiteColor,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        status,
                        style: getRegularTitleStyle(
                          color: statusColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _showAddPlaylistDialog(BuildContext context) {
    final _playlistNameController = TextEditingController();
    final _playlistUrlController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Playlist'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _playlistNameController,
                  decoration: InputDecoration(
                    labelText: 'Playlist Name',
                    hintText: 'Enter the playlist name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a playlist name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: _playlistUrlController,
                  decoration: InputDecoration(
                    labelText: 'Playlist URL',
                    hintText: 'Enter the playlist URL',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a playlist URL';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog without saving
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Get playlist name and URL
                  final playlistName = _playlistNameController.text;
                  final playlistUrl = _playlistUrlController.text;

                  // Call addPlaylist API request
                  BlocProvider.of<LoginCubit>(context).addPlaylist(name: playlistName, url: playlistUrl);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

