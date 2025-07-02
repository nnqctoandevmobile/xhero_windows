// ignore_for_file: unused_field, depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:toastification/toastification.dart';
import '../../../resource/assets_constant/icon_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../resource/assets_constant/frames_constant.dart';
import '../../resource/assets_constant/images_constants.dart';
import '../../setup_url/url.dart';
import '../../shared/multi_appear_widgets/gradient_icon_widget.dart';
import '../../shared/text_style.dart';
import '../../utils/logic/common_widget.dart';
import '../../utils/logic/xhero_common_logics.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../compass/model/location_model.dart';


class SatelliteCompassMap extends StatefulWidget {
  final double degreeFromCompas;
  const SatelliteCompassMap({super.key, required this.degreeFromCompas});

  @override
  State<SatelliteCompassMap> createState() => SatelliteCompassMapState();
}

class SatelliteCompassMapState extends State<SatelliteCompassMap> {
  late GoogleMapController _controller;
  LatLng? _currentPosition;
  final GlobalKey _globalKey = GlobalKey();
  String currentSearch = '';
  String address = '';
  bool _isLoading = true;
  final Set<Marker> _markersPin = {};
  LatLng? _selectedPosition;
  bool _scrollGesturesEnabled = true;
  bool _hidenCompass = false;
  final bool _activeCompass = false;
  final bool _lockedCompass = false;
  bool _isTurnMap = false;
  double bearingForTurn = 0;
  double _angleMerging = 0.0;
  final bool _isRotationLockedRed = false;
  TextEditingController searchTEC = TextEditingController();
  late CameraPosition _initialPosition;
  final Set<Marker> _markers = {};
  final double _rotationAngle = 0.0; // Góc quay ban đầu
  final double _lastRotationAngle = 0.0;
  final ValueNotifier<double> _rotationAngleNotifier = ValueNotifier<double>(
    0.0,
  );
  List<String> icFnVertical = [
    IconConstants.ic_zoom_in_map,
    IconConstants.ic_zoom_out_map,
  ];
  Uint8List? imageBytes;
  bool isSnapshotReady = false;
  bool isCapturing = false;
  final bool _initialized = false;
  List<String> icFnHorizontalInactive = [
    IconConstants.ic_refresh_gradient,
    IconConstants.ic_color_picker,
    // IconConstants.ic_compass_geology,
    IconConstants.ic_layer_map_gradient,
    IconConstants.ic_show_compass_map,
    IconConstants.ic_compass_all_map_locked,
  ];
  List<String> icFnHorizontalActive = [
    IconConstants.ic_refresh_gradient,
    IconConstants.ic_color_picker,
    // IconConstants.ic_compass_geology_locked,
    IconConstants.ic_layer_map_gradient,
    IconConstants.ic_show_compass_map_locked,
    IconConstants.ic_compass_all_map,
  ];
  List<bool> isActiveIcons = [true, true, true, true, true];
  List<String> icMapTypes = [
    IconConstants.ic_satellite_map,
    IconConstants.ic_hybrid_map,
    IconConstants.ic_terrain_map,
    IconConstants.ic_normal_map,
  ];
  List<String> titleMapTypes = [
    'satellite_map',
    'hybrid_map',
    'terrain_map',
    'normal_map',
  ];
  BitmapDescriptor? _customIcon;
  int selectedIdxMap = 0;

  MapType _currentMapType = MapType.satellite;
  String mapType = 'satellite_map'.tr;
  final Offset _lastPosition = Offset.zero;
  final double _rotationStep = 0.000072;
  List<Map<String, dynamic>> compassData = []; // Lưu dữ liệu trả về
  void _addPin(LatLng? latLng) {
    if (latLng != null) {
      _setMarker(latLng);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please tap on the map to select a location'),
        ),
      );
    }
  }

  Marker? _myLocationMarker;

  LatLng? _centerPosition; // Biến để lưu tọa độ trung tâm
  Future<void> _getCenterLatLng() async {
    try {
      if (_mapController != null) {
        // Lấy tọa độ tại tâm màn hình
        // Lấy tọa độ tại tâm bản đồ từ chính GoogleMapController
        LatLngBounds visibleRegion = await _mapController!.getVisibleRegion();
        LatLng center = LatLng(
          (visibleRegion.northeast.latitude +
                  visibleRegion.southwest.latitude) /
              2,
          (visibleRegion.northeast.longitude +
                  visibleRegion.southwest.longitude) /
              2,
        );

        setState(() {
          _centerPosition = center; // Lưu tọa độ vào biến
        });
        _addPin(_centerPosition);
      } else {
        printConsole('content');
      }
    } catch (e) {
      printConsole(e.toString());
    }
  }

  Future<void> _setMarker(LatLng position) async {
    _markers.clear();
    final Uint8List markerIcon = await _getBytesFromAsset(
      IconConstants.ic_marker_map,
      84,
      100,
    );

    // Gọi hàm bất đồng bộ để lấy địa chỉ
    String address = await getAddressFromLatLngFinal(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _selectedPosition = position; // Cập nhật vị trí đã chọn
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: 'pinned_address'.tr,
            snippet: address,
          ), // Sử dụng địa chỉ lấy được
          icon: BitmapDescriptor.fromBytes(markerIcon), // Màu xanh lá cây
        ),
      );
    });
  }

  void _addMarker(
    LatLng position,
    String markerId,
    String title,
    BitmapDescriptor icon,
  ) {
    final Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title),
      icon: icon,
    );
    setState(() {
      _markers.add(marker);
    });
  }

  Color _imageColor = Colors.white;
  double _initialAngle = 0.0;
  double _initialAngleMerging = 0.0;
  Offset _initialPositions = Offset.zero;
  double _angle = 0.0;
  double lockedDirection = 0.0;
  final double _angle123 = 0.0;
  StreamSubscription? _compassSubscription;
  double lastRead = 0;
  bool _isBearingChanged = false;
  bool _isMergingAngle = false;
  final double _degreeCompass = 0.0;
  final double _degreeRedline = 0.0;
  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    _initialPositions = box.globalToLocal(details.globalPosition);
    _initialAngle = _angle;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final center = box.size.center(Offset.zero);
    final a = _initialPositions - center;
    final b = localPosition - center;
    final angleDelta = b.direction - a.direction;
    setState(() {
      if (_isMergingAngle) {
        _angleMerging = (_initialAngleMerging + angleDelta) % (2 * math.pi);
      }
      _angle = (_initialAngle + angleDelta) % (2 * math.pi);
      printConsole(_angle.toString());
    });
  }

  // Hàm chuyển đổi từ độ bearing sang angle (radians)
  double bearingToAngle(double bearing) {
    // Chuyển từ độ sang radians
    double radians = bearing * (math.pi / 180);
    printConsole('${radians % (2 * math.pi)}');
    return radians % (2 * math.pi);
  }

  bool isShowWindyMap = false;
  bool isPermissionGranted = false;
  List<String> suggestions = [];
  @override
  void initState() {
    super.initState();
    // Sử dụng trong context của bạn
    // if (AppDataGlobal.IS_SIGNED_IN ?? false) {
    //   isShowWindyMap =
    //       checkAdvanceFunction(AppDataGlobal.advanceFunctions, "windy-map");
    // }
    _loadCustomMarker();
    getLocation();
    // _startLocationUpdates();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    LatLng location = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = location;
      isPermissionGranted = true;
      _isLoading = false;
    });

    getAddressFromLatLngFinal(location.latitude, location.longitude);

    if (_customIcon != null) {
      _addMarker(location, 'myLocation', 'you_are_here'.tr, _customIcon!);
    }
  }

  bool checkAdvanceFunction(List<String>? advanceFunctions, String key) {
    if (advanceFunctions == null) return false;
    return advanceFunctions.contains(key);
  }

  Future<void> _loadCustomMarker() async {
    final Uint8List markerIcon = await _getBytesFromAsset(
      IconConstants.ic_marker_map,
      84,
      100,
    );
    setState(() {
      _customIcon = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  Future<Uint8List> _getBytesFromAsset(
    String path,
    int width,
    int height,
  ) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final img.Image? image = img.decodeImage(bytes);
    final img.Image resized = img.copyResize(
      image!,
      width: width,
      height: height,
    );
    return Uint8List.fromList(img.encodePng(resized));
  }

  late StreamSubscription<Position> positionStream;

  void startTrackingLocation() {
    // Start listening to position stream
    positionStream =
        Geolocator.getPositionStream(
          // You can remove these if not supported:
          // desiredAccuracy: LocationAccuracy.best,
          // distanceFilter: 10,
        ).listen((Position position) {
          // Get the new position
          double lat = position.latitude;
          double long = position.longitude;

          LatLng location = LatLng(lat, long);

          setState(() {
            _currentPosition = location;
            _isLoading = false;
          });

          if (_currentPosition != null) {
            getAddressFromLatLngFinal(
              _currentPosition?.latitude ?? 0.0,
              _currentPosition?.longitude ?? 0.0,
            );
          }

          if (_customIcon != null) {
            _addMarker(
              _currentPosition!,
              'myLocation',
              'you_are_here'.tr,
              _customIcon!,
            );
          }
        });
  }

  void stopTrackingLocation() {
    // Stop the position stream when done
    positionStream.cancel();
  }

  Future<String> getAddressFromLatLngFinal(double lat, double lng) async {
    String apiKey =
        "AIzaSyAtU1dcmkxSmt4yUDlR7A3liYHr4skxcFc"; // Thay bằng API key của bạn
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse kết quả JSON
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // Lấy địa chỉ đầy đủ từ kết quả đầu tiên
          String addressData = data['results'][0]['formatted_address'];
          setState(() {
            address = addressData;
          });
          printConsole(address);
          EasyLoading.dismiss();
          return addressData;
        } else {
          EasyLoading.dismiss();
          return "No Address Found";
        }
      } else {
        EasyLoading.dismiss();
        return "Failed to get address";
      }
    } catch (e) {
      EasyLoading.dismiss();
      printConsole("Error occurred while getting address: $e");
      return "No Address";
    }
  }

  void _onCameraMove(CameraPosition position) {
    if (position.bearing != bearingForTurn) {
      setState(() {
        if (_isTurnMap) {
          _isBearingChanged = true;
          bearingForTurn = position.bearing;
          printConsole('bearing is: $bearingForTurn');
        } else {
          _isBearingChanged = false;
        }
      });
    }
  }

  GoogleMapController? _mapController;

  void _onCameraIdle() {
    // takeSnapShot();
  }
  // void _listenChange() async {
  //   _compassSubscription = FlutterCompass.events?.listen((event) {
  //     setState(() {
  //       if (!_lockedCompass) {
  //         lastRead = convertToPositiveDegree(event.heading ?? 0.0);
  //         lockedDirection = event.heading ?? 0.0;
  //         if (_activeCompass) {
  //           _updateCameraBearing(lastRead);
  //         }
  //       }
  //     });
  //   });
  // }

  double convertToPositiveDegree(double degree) {
    return (degree % 360 + 360) % 360;
  }

  void takeSnapShot() async {
    setState(() {
      isSnapshotReady = false;
    });
    // GoogleMapController controller = await _controller.future;
    // Future<void>.delayed(const Duration(milliseconds: 1), () async {
    //   final image = await controller.takeSnapshot();
    //   final compressedImage = await compressImage(image!);
    //   setState(() {
    //     imageBytes = compressedImage;
    //     isSnapshotReady = true;
    //   });
    // });
  }

  double calculateSymmetricDegree(double degreeFromCompas) {
    double symmetricDegree = degreeFromCompas + 180.0;
    if (symmetricDegree >= 360.0) {
      symmetricDegree -= 360.0;
    }
    return symmetricDegree;
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    searchTEC.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _controller.animateCamera(CameraUpdate.zoomIn());
    });
  }

  void _zoomOut() {
    setState(() {
      _controller.animateCamera(CameraUpdate.zoomOut());
    });
  }

  Future<void> _moveToCurrentPosition() async {
    if (_currentPosition != null) {
      await _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 19.0),
        ),
      );
    }
  }

  Future<void> _captureScreenshot() async {
    try {
      final Uint8List? mapImageBytes = await _controller.takeSnapshot();
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List stackImageBytes = byteData!.buffer.asUint8List();
      final ui.Codec mapCodec = await ui.instantiateImageCodec(mapImageBytes!);
      final ui.FrameInfo mapFrameInfo = await mapCodec.getNextFrame();
      final ui.Image mapImage = mapFrameInfo.image;
      final ui.Codec stackCodec = await ui.instantiateImageCodec(
        stackImageBytes,
      );
      final ui.FrameInfo stackFrameInfo = await stackCodec.getNextFrame();
      final ui.Image stackImage = stackFrameInfo.image;
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint();
      final Size size = Size(
        stackImage.width.toDouble(),
        stackImage.height.toDouble(),
      );
      canvas.drawImage(mapImage, Offset.zero, paint);
      canvas.drawImage(stackImage, Offset.zero, paint);
      final ui.Image finalImage = await recorder.endRecording().toImage(
        size.width.toInt(),
        size.height.toInt(),
      );
      final ByteData? finalByteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List finalPngBytes = finalByteData!.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/screenshot.png');
      await file.writeAsBytes(finalPngBytes);
      setState(() {
        isCapturing = false;
      });
      EasyLoading.dismiss();
      await Share.shareFiles([
        file.path,
      ], text: '${'compass'.tr} ${'satellite'.tr}');
    } catch (e) {
      EasyLoading.dismiss();
      setState(() {
        isCapturing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = screenWidth > 1000
        ? screenWidth * 0.6
        : screenWidth > 600
        ? screenWidth * 0.8
        : screenWidth * 0.95;

    final containerHeight =
        containerWidth * 0.75; // tỷ lệ ngang 4:3 hoặc 16:9 tùy bạn
    final containerHeightLineRed =
        containerWidth * 0.6; // hoặc 0.75 tuỳ nhu cầu
    return Scaffold(
      body: !isPermissionGranted
          ? SizedBox(
              width: Get.width - 0,
              height: Get.height,
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height,
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 148,
                      bottom: 120,
                    ),
                    child: Image.asset('img_map_vn.png'),
                  ),
                  Container(
                    width: Get.width,
                    height: Get.height,
                    color: AppColor.blackColor.withAlpha(60),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'gifs/loading_state.gif',
                            width: 248,
                            height: 248,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GradientText(
                          'get_your_current_location'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          colors: CommonConstants.name,
                          textAlign: TextAlign.center,
                          gradientDirection: GradientDirection.ttb,
                          style: TextAppStyle().thinTextStyleSmallLight(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : RepaintBoundary(
              key: _globalKey,
              child: SizedBox(
                child: Stack(
                  children: [
                    SizedBox(
                      child: GoogleMap(
                        scrollGesturesEnabled: _scrollGesturesEnabled,
                        mapType: _getGoogleMapType(_currentMapType),
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        onCameraMove: _onCameraMove,
                        rotateGesturesEnabled: _isTurnMap,
                        onCameraIdle: _onCameraIdle,
                        trafficEnabled: false,
                        buildingsEnabled: false,
                        indoorViewEnabled: false,
                        markers: Set<Marker>.of(_markers),
                        //  markers: _myLocationMarker != null ? {_myLocationMarker!} : {},
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition!,
                          zoom: 19.0,
                          // tilt: 45,
                          bearing: 0,
                        ),
                        onMapCreated: (GoogleMapController controller) async {
                          _controller = controller;
                          _mapController = controller;
                        },
                      ),
                    ),
                    Visibility(
                      visible: !_hidenCompass,
                      child: Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onPanUpdate: (details) {
                                  // Tùy chỉnh góc xoay khi kéo
                                  setState(() {
                                    bearingForTurn +=
                                        details.delta.dx *
                                        0.01; // Điều chỉnh tốc độ xoay
                                  });
                                },
                                onTapDown: (details) {
                                  // Tính tọa độ chạm so với trung tâm
                                  final double centerX =
                                      MediaQuery.of(context).size.width / 2;
                                  final double centerY =
                                      MediaQuery.of(context).size.width /
                                      2; // Giả sử chiều cao bằng chiều rộng
                                  final double dx =
                                      details.localPosition.dx - centerX;
                                  final double dy =
                                      details.localPosition.dy - centerY;

                                  // Tính góc (độ) từ tọa độ chạm
                                  double angle =
                                      (math.atan2(dy, dx) * 180 / math.pi);
                                  _determineDirection(angle, context);
                                },
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 40),
                                          Transform.rotate(
                                            angle: _isBearingChanged
                                                ? -bearingForTurn /
                                                      ((180 / math.pi))
                                                : 0,
                                            child: _imageColor == Colors.white
                                                ? Image.asset(
                                                    FrameConstants
                                                        .fr_compass_satellite,
                                                    width: containerWidth,
                                                    height:
                                                        containerHeightLineRed,
                                                  )
                                                : _imageColor == Colors.white
                                                ? Image.asset(
                                                    FrameConstants
                                                        .fr_compass_satellite,
                                                    width: containerWidth,
                                                    height: containerHeight,
                                                  )
                                                : ColorFiltered(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          _imageColor,
                                                          BlendMode.srcATop,
                                                        ),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(
                                                          FrameConstants
                                                              .fr_compass_satellite,
                                                          width: containerWidth,
                                                          height:
                                                              containerHeight,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(height: 40),
                                        ],
                                      ),
                                      Positioned.fill(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              IconConstants.ic_logo_dn_35,
                                              width: optimizedSize(
                                                phone: 100,
                                                zfold: 120,
                                                tablet: 132,
                                                context: context,
                                              ),
                                              height: optimizedSize(
                                                phone: 100,
                                                zfold: 120,
                                                tablet: 132,
                                                context: context,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: Transform.rotate(
                        angle: _angle,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 0.15,
                                  right: 51,
                                  left: MediaQuery.of(context).size.width > 430
                                      ? 52.2
                                      : 52.05,
                                ),
                                // color: AppColor.whiteColor
                                //     .withAlpha((0.75 * 255).toInt()),
                                child: Image.asset(
                                  FrameConstants.fr_line_x_y,
                                  width: containerWidth,
                                  height: containerHeightLineRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _isTurnMap
                        ? Positioned(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.width > 500
                                    ? ((Get.width / 1.5) - 148)
                                    : ((Get.width - 60)) - 80,
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    printConsole('content');
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        // margin: const EdgeInsets.only(bottom: 80),
                                        width: 80,
                                        height: 24,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.colorRed,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: AppColor.textLightColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _isBearingChanged
                                                ? '${bearingForTurn.toStringAsFixed(1)}\u00B0'
                                                : '${(_angle * (180 / math.pi)).toStringAsFixed(1)}\u00B0',
                                            maxLines: 1,
                                            textScaler: const TextScaler.linear(
                                              1,
                                            ),
                                            style: TextAppStyle()
                                                .titleStyleSmallLight(),
                                          ),
                                        ),
                                      ),
                                      MediaQuery.of(context).size.width > 500
                                          ? const SizedBox(height: 100)
                                          : const SizedBox(height: 60),
                                      Container(
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColor.borderYellow
                                                  .withAlpha(
                                                    (0.15 * 255).toInt(),
                                                  ),
                                              blurRadius: 16,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          IconConstants
                                              .ic_center_compass_satellite,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Positioned(
                            child: Transform.rotate(
                              angle: _angle,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenWidth < 500
                                      ? ((Get.width) * 0.32)
                                      : ((Get.width)) * 0.28,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      printConsole('content');
                                    },
                                    onPanStart: _onPanStart,
                                    onPanUpdate: _onPanUpdate,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          // margin: const EdgeInsets.only(bottom: 80),
                                          width: 80,
                                          height: 24,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.colorRed,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColor.textLightColor,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _isBearingChanged
                                                  ? '${(_angleMerging * (180 / math.pi)).toStringAsFixed(1)}\u00B0'
                                                  : '${(_angle * (180 / math.pi)).toStringAsFixed(1)}\u00B0',
                                              maxLines: 1,
                                              textScaler:
                                                  const TextScaler.linear(1),
                                              style: TextAppStyle()
                                                  .titleStyleSmallLight(),
                                            ),
                                          ),
                                        ),
                                        MediaQuery.of(context).size.width > 500
                                            ? const SizedBox(height: 100)
                                            : const SizedBox(height: 60),
                                        Container(
                                          margin: const EdgeInsets.only(top: 0),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColor.borderYellow
                                                    .withAlpha(
                                                      (0.15 * 255).toInt(),
                                                    ),
                                                blurRadius: 16,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            IconConstants
                                                .ic_center_compass_satellite,
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                        // const SizedBox( height: 8)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    if (!isCapturing)
                      Positioned(
                        bottom: 24,
                        right: MediaQuery.of(context).size.width > 500
                            ? 64
                            : 60,
                        child: Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width > 500
                                  ? 44
                                  : 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          ImageConstants.img_bg_map_action_hoz,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(icFnHorizontalActive.length, (
                                        index,
                                      ) {
                                        return onTapWidget(
                                          onTap: () {
                                            if (index == 4) {
                                              setState(() {
                                                isActiveIcons[index] =
                                                    !isActiveIcons[index];
                                                _isTurnMap = !_isTurnMap;
                                                if (_isTurnMap) {
                                                  _angle = 0;
                                                  _isBearingChanged = true;
                                                  Fluttertoast.showToast(
                                                    msg: 'turn_map_is_on'.tr,
                                                    backgroundColor:
                                                        AppColor.colorGreenDark,
                                                    fontSize: 14,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    textColor:
                                                        AppColor.secondaryColor,
                                                  );
                                                } else {
                                                  _isMergingAngle = true;

                                                  _initialAngleMerging =
                                                      bearingToAngle(
                                                        bearingForTurn,
                                                      );
                                                  if (_isMergingAngle) {
                                                    _angleMerging =
                                                        _initialAngleMerging;
                                                  }
                                                  Fluttertoast.showToast(
                                                    msg: 'turn_map_is_off'.tr,
                                                    backgroundColor:
                                                        AppColor.colorRedBold,
                                                    fontSize: 14,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    textColor:
                                                        AppColor.secondaryColor,
                                                  );
                                                }
                                              });
                                            } else if (index == 3) {
                                              setState(() {
                                                _hidenCompass = !_hidenCompass;
                                                isActiveIcons[index] =
                                                    !isActiveIcons[index];
                                              });

                                              if (_hidenCompass) {
                                                Toastification().show(
                                                  autoCloseDuration:
                                                      const Duration(
                                                        seconds: 2,
                                                      ),
                                                  borderSide: BorderSide.none,
                                                  dragToClose: true,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  style:
                                                      ToastificationStyle.flat,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                        8,
                                                        8,
                                                        8,
                                                        0,
                                                      ),
                                                  backgroundColor:
                                                      AppColor.colorRedBold,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        16,
                                                        16,
                                                        0,
                                                        16,
                                                      ),
                                                  alignment: Alignment.center,
                                                  showProgressBar: false,
                                                  closeButtonShowType:
                                                      CloseButtonShowType.none,
                                                  icon: Image.asset(
                                                    ImageConstants
                                                        .img_compass_lock,
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${'compass'.tr} ${'satellite'.tr.toLowerCase()}',
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextAppStyle()
                                                            .normalTextStyleSmallLight(),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'compass_is_hiding'.tr,
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextAppStyle()
                                                            .thinTextStyleExtraSmallLight(),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                Toastification().show(
                                                  autoCloseDuration:
                                                      const Duration(
                                                        seconds: 2,
                                                      ),
                                                  borderSide: BorderSide.none,
                                                  dragToClose: true,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  style:
                                                      ToastificationStyle.flat,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                        8,
                                                        8,
                                                        8,
                                                        0,
                                                      ),
                                                  backgroundColor:
                                                      AppColor.colorGreenDark,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        16,
                                                        16,
                                                        0,
                                                        16,
                                                      ),
                                                  alignment: Alignment.center,
                                                  showProgressBar: false,
                                                  closeButtonShowType:
                                                      CloseButtonShowType.none,
                                                  icon: Image.asset(
                                                    ImageConstants
                                                        .img_compass_unlock,
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${'compass'.tr} ${'satellite'.tr.toLowerCase()}',
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextAppStyle()
                                                            .normalTextStyleSmallLight(),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'compass_is_showing'.tr,
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextAppStyle()
                                                            .thinTextStyleExtraSmallLight(),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            } else if (index == 2) {
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    AppColor.whiteColor,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  26,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  26,
                                                                ),
                                                          ),
                                                      border: Border(
                                                        top: BorderSide(
                                                          color: AppColor
                                                              .newPrimaryColor2,
                                                          width: 6,
                                                        ),
                                                      ),
                                                      image: const DecorationImage(
                                                        image: AssetImage(
                                                          ImageConstants
                                                              .img_bg_mbs_flower,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                          24,
                                                          16,
                                                          24,
                                                          48,
                                                        ),
                                                    width: Get.width,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const SizedBox(
                                                              width: 40,
                                                            ),
                                                            Text(
                                                              'select_map_type'
                                                                  .tr,
                                                              style: TextAppStyle()
                                                                  .titleStyle()
                                                                  .copyWith(
                                                                    color: AppColor
                                                                        .primaryColor,
                                                                  ),
                                                            ),
                                                            onTapWidget(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      left: 12,
                                                                    ),
                                                                child: Icon(
                                                                  CupertinoIcons
                                                                      .clear,
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                  size: 28,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 0.5,
                                                          width: Get.width - 48,
                                                          margin:
                                                              const EdgeInsets.only(
                                                                top: 16,
                                                                bottom: 0,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: AppColor
                                                                .primaryColor
                                                                .withAlpha(
                                                                  (0.25 * 255)
                                                                      .toInt(),
                                                                ),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: List.generate(
                                                            icMapTypes.length,
                                                            (
                                                              index,
                                                            ) => onTapWidget(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedIdxMap =
                                                                      index;
                                                                  if (index ==
                                                                      0) {
                                                                    _currentMapType =
                                                                        MapType
                                                                            .satellite;
                                                                    mapType =
                                                                        'satellite_map'
                                                                            .tr;
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  } else if (index ==
                                                                      1) {
                                                                    _currentMapType =
                                                                        MapType
                                                                            .hybrid;
                                                                    mapType =
                                                                        'hybrid_map'
                                                                            .tr;
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  } else if (index ==
                                                                      2) {
                                                                    _currentMapType =
                                                                        MapType
                                                                            .terrain;
                                                                    mapType =
                                                                        'terrain_map'
                                                                            .tr;
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  } else {
                                                                    _currentMapType =
                                                                        MapType
                                                                            .normal;
                                                                    mapType =
                                                                        'normal_map'
                                                                            .tr;
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  }
                                                                });
                                                                Toastification().show(
                                                                  autoCloseDuration:
                                                                      const Duration(
                                                                        seconds:
                                                                            2,
                                                                      ),
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none,
                                                                  dragToClose:
                                                                      true,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                  style:
                                                                      ToastificationStyle
                                                                          .flat,
                                                                  margin: const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical: 0,
                                                                  ),
                                                                  backgroundColor:
                                                                      AppColor
                                                                          .secondaryColor,
                                                                  padding:
                                                                      const EdgeInsets.fromLTRB(
                                                                        16,
                                                                        16,
                                                                        0,
                                                                        16,
                                                                      ),
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  showProgressBar:
                                                                      false,
                                                                  closeButtonShowType:
                                                                      CloseButtonShowType
                                                                          .none,
                                                                  icon: ColorFiltered(
                                                                    colorFilter: ColorFilter.mode(
                                                                      AppColor
                                                                          .textBrownDark,
                                                                      BlendMode
                                                                          .srcATop,
                                                                    ),
                                                                    child: SvgPicture.asset(
                                                                      _currentMapType ==
                                                                              MapType.satellite
                                                                          ? icMapTypes[0]
                                                                          : _currentMapType ==
                                                                                MapType.hybrid
                                                                          ? icMapTypes[1]
                                                                          : _currentMapType ==
                                                                                MapType.terrain
                                                                          ? icMapTypes[2]
                                                                          : icMapTypes[3],
                                                                      width: 44,
                                                                    ),
                                                                  ),
                                                                  title: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'change_map_successfully'
                                                                            .tr,
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextAppStyle()
                                                                            .normalTextStyleSmallLight()
                                                                            .copyWith(
                                                                              color: AppColor.textBrownDark,
                                                                            ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                        '${'switch_to'.tr} $mapType',
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextAppStyle().thinTextStyleExtraSmallLight().copyWith(
                                                                          color:
                                                                              AppColor.textBrownDark,
                                                                          fontSize:
                                                                              12.5,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          16,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          icMapTypes[index],
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              12,
                                                                        ),
                                                                        Text(
                                                                          titleMapTypes[index]
                                                                              .tr,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextAppStyle().semiBoldTextStyleLarge().copyWith(
                                                                            color:
                                                                                index ==
                                                                                    4
                                                                                ? AppColor.colorRedBold
                                                                                : AppColor.primaryColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    selectedIdxMap ==
                                                                            index
                                                                        ? SvgPicture.asset(
                                                                            IconConstants.ic_checked_gradient,
                                                                            width:
                                                                                28,
                                                                            height:
                                                                                28,
                                                                          )
                                                                        : const SizedBox(
                                                                            width:
                                                                                28,
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            } else if (index == 1) {
                                              Color pickerColor = _imageColor;

                                              showModalBottomSheet(
                                                backgroundColor:
                                                    AppColor.whiteColor,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (
                                                          BuildContext context,
                                                          StateSetter
                                                          setStateColor,
                                                        ) {
                                                          return Container(
                                                            height:
                                                                Get.height *
                                                                0.4,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius.only(
                                                                    topLeft:
                                                                        Radius.circular(
                                                                          26,
                                                                        ),
                                                                    topRight:
                                                                        Radius.circular(
                                                                          26,
                                                                        ),
                                                                  ),
                                                              border: Border(
                                                                top: BorderSide(
                                                                  color: AppColor
                                                                      .newPrimaryColor2,
                                                                  width: 6,
                                                                ),
                                                              ),
                                                              image: const DecorationImage(
                                                                image: AssetImage(
                                                                  ImageConstants
                                                                      .img_bg_mbs_flower,
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets.fromLTRB(
                                                                  0,
                                                                  16,
                                                                  0,
                                                                  24,
                                                                ),
                                                            width: Get.width,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 40,
                                                                    ),
                                                                    Text(
                                                                      'pick_color_compass'
                                                                          .tr,
                                                                      style: TextAppStyle()
                                                                          .titleStyle()
                                                                          .copyWith(
                                                                            color:
                                                                                AppColor.primaryColor,
                                                                          ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                          right:
                                                                              24,
                                                                        ),
                                                                        child: Icon(
                                                                          CupertinoIcons
                                                                              .clear,
                                                                          color:
                                                                              AppColor.primaryColor,
                                                                          size:
                                                                              28,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  height: 0.5,
                                                                  width:
                                                                      Get.width -
                                                                      48,
                                                                  margin:
                                                                      const EdgeInsets.only(
                                                                        top: 16,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColor
                                                                        .primaryColor
                                                                        .withAlpha(
                                                                          (0.25 *
                                                                                  255)
                                                                              .toInt(),
                                                                        ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: GridView.builder(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          24,
                                                                      vertical:
                                                                          24,
                                                                    ),
                                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          5,
                                                                      crossAxisSpacing:
                                                                          8.0,
                                                                      mainAxisSpacing:
                                                                          8.0,
                                                                      childAspectRatio:
                                                                          1.0,
                                                                    ),
                                                                    itemCount: CommonConstants
                                                                        .colorsPicker
                                                                        .length,
                                                                    itemBuilder:
                                                                        (
                                                                          context,
                                                                          index,
                                                                        ) {
                                                                          final color =
                                                                              CommonConstants.colorsPicker[index];
                                                                          final isSelected =
                                                                              pickerColor ==
                                                                              color;
                                                                          return GestureDetector(
                                                                            onTap: () {
                                                                              setStateColor(
                                                                                () {
                                                                                  pickerColor = color;
                                                                                  _imageColor = pickerColor;
                                                                                },
                                                                              );

                                                                              setState(
                                                                                () {
                                                                                  // Cập nhật lại màu chính
                                                                                  // Lưu ý: `_imageColor` đã được cập nhật từ `StatefulBuilder`
                                                                                },
                                                                              );
                                                                            },
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(
                                                                                    2,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      width: 1,
                                                                                      color: color,
                                                                                    ),
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Container(
                                                                                    width: optimizedSize(
                                                                                      phone:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          5,
                                                                                      zfold:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          9,
                                                                                      tablet:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          7,
                                                                                      context: context,
                                                                                    ),
                                                                                    height: optimizedSize(
                                                                                      phone:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          5,
                                                                                      zfold:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          9,
                                                                                      tablet:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          7,
                                                                                      context: context,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      color: color,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                if (isSelected)
                                                                                  SvgPicture.asset(
                                                                                    IconConstants.ic_checked_gradient,
                                                                                    width: 36,
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                  );
                                                },
                                              );
                                            } else {
                                              setState(() {
                                                _markers.clear();
                                                _loadCustomMarker();
                                                // getLocation();
                                                currentSearch = '';
                                                _imageColor = Colors.white;
                                                _angle = 0;
                                                _isTurnMap = false;
                                                _isBearingChanged = false;
                                                bearingForTurn = 0;
                                                _moveToCurrentPosition();
                                                _scrollGesturesEnabled = true;
                                                if (isActiveIcons[4] == false) {
                                                  isActiveIcons[4] = true;
                                                }
                                              });
                                              return;
                                            }
                                          },
                                          child: Container(
                                            height:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width >
                                                    500
                                                ? 44
                                                : 40,
                                            margin: EdgeInsets.only(
                                              right: index + 1 < 5 ? 4 : 0,
                                            ),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              !isActiveIcons[index]
                                                  ? icFnHorizontalActive[index]
                                                  : icFnHorizontalInactive[index],
                                              width:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 40
                                                  : 32,
                                              height:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 40
                                                  : 32,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const Column(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isCapturing)
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24,
                            left: 8,
                            right: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                'logo_with_slogan.png',
                                height: 40,
                                fit: BoxFit.fitWidth,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'img_qr_code.png',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!isCapturing)
                      Positioned(
                        bottom: 16,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width > 500
                                  ? 44
                                  : 40,
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.sandColor.withAlpha(
                                  (0.3 * 255).toInt(),
                                ),
                                borderRadius: BorderRadius.circular(100),
                                border: const GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: CommonConstants.gradientsLight,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: List.generate(icFnVertical.length, (
                                  index,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    child: onTapWidget(
                                      onTap: () async {
                                        if (index == 0) {
                                          _zoomIn();
                                        } else if (index == 1) {
                                          _zoomOut();
                                        } else if (index == 2) {
                                          setState(() {
                                            isCapturing = true;
                                          });
                                          await EasyLoading.show(
                                            maskType: EasyLoadingMaskType.black,
                                          );

                                          _captureScreenshot();
                                        } else {
                                          setState(() {
                                            _markers.clear();
                                            _loadCustomMarker();
                                            getLocation();
                                            currentSearch = '';
                                            _imageColor = Colors.white;
                                            _angle = 0;
                                            _isTurnMap = false;
                                            _isBearingChanged = false;
                                            bearingForTurn = 0;
                                            _moveToCurrentPosition();
                                            _scrollGesturesEnabled = true;
                                            if (isActiveIcons[4] == false) {
                                              isActiveIcons[4] = true;
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: index + 1 < 4 ? 4 : 0,
                                        ),
                                        child: Image.asset(
                                          icFnVertical[index],
                                          width: 40,
                                          // height: heightFlexible(60),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 8),
                            onTapWidget(
                              onTap: () {
                                _moveToCurrentPosition();
                                setState(() {
                                  currentSearch = '';
                                });
                              },
                              child: Image.asset(
                                IconConstants.ic_my_location,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!isCapturing)
                      Positioned(
                        top: 116,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.sandColor.withAlpha(
                              (0.3 * 255).toInt(),
                            ),
                            borderRadius: BorderRadius.circular(100),
                            border: const GradientBoxBorder(
                              gradient: LinearGradient(
                                colors: CommonConstants.gradientsLight,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              onTapWidget(
                                onTap: () {
                                  setState(() {
                                    _scrollGesturesEnabled =
                                        !_scrollGesturesEnabled;
                                  });
                                },
                                child: Image.asset(
                                  _scrollGesturesEnabled
                                      ? IconConstants.ic_compass_geology
                                      : IconConstants.ic_compass_geology_locked,
                                  width: optimizedSize(
                                    phone: 28,
                                    zfold: 32,
                                    tablet: 32,
                                    context: context,
                                  ),
                                  height: optimizedSize(
                                    phone: 28,
                                    zfold: 32,
                                    tablet: 32,
                                    context: context,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              onTapWidget(
                                onTap: () {
                                  // if (Platform.isAndroid) {
                                  //   Get.to(
                                  //       () => const CesiumMapScreen());
                                  // } else {
                                  //   Get.to(() => WebViewScreen(
                                  //       url:
                                  //           'https://vothanhthe.github.io/cesium-map-static-web/',
                                  //       title: capitalForText(
                                  //           'terrain_compass'.tr)));
                                  // }
                                },
                                child: Container(
                                  width: optimizedSize(
                                    phone: 28,
                                    zfold: 32,
                                    tablet: 32,
                                    context: context,
                                  ),
                                  height: optimizedSize(
                                    phone: 28,
                                    zfold: 32,
                                    tablet: 32,
                                    context: context,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.blackColor,
                                    shape: BoxShape.circle,
                                    border: GradientBoxBorder(
                                      gradient: LinearGradient(
                                        colors: CommonConstants
                                            .gradientBGCodeRefferal,
                                      ),
                                    ),
                                  ),
                                  child: GradientIcon(
                                    icon: Icons.view_in_ar,
                                    size: optimizedSize(
                                      phone: 20,
                                      zfold: 22,
                                      tablet: 22,
                                      context: context,
                                    ),
                                    gradient: const LinearGradient(
                                      colors: CommonConstants.button,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!isCapturing && isShowWindyMap)
                      Positioned(
                        top: 116,
                        right: 12,
                        child: onTapWidget(
                          onTap: () {
                            // Get.to(() => WindDirectionScreen(
                            //     location: address,
                            //     latLng: _currentPosition ??
                            //         const LatLng(20.862935460108687,
                            //             106.66576316938536)));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 2,
                            ).copyWith(left: 8),
                            decoration: BoxDecoration(
                              color: AppColor.sandColor.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(100),
                              border: const GradientBoxBorder(
                                gradient: LinearGradient(
                                  colors: CommonConstants.gradientsLight,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'windy_map_title'.tr,
                                  style: TextAppStyle()
                                      .normalTextStyle()
                                      .copyWith(
                                        fontSize: 12,
                                        color: AppColor.secondaryColor,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Image.asset(
                                  IconConstants.ic_windy_gradient,
                                  width: optimizedSize(
                                    phone: 30,
                                    zfold: 32,
                                    tablet: 32,
                                    context: context,
                                  ),
                                  height: optimizedSize(
                                    phone: 30,
                                    zfold: 32,
                                    tablet: 32,
                                    context: context,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  void _determineDirection(double angle, BuildContext context) {
    double correctedAngle = angle + 90;
    if (correctedAngle >= 360) correctedAngle -= 360;
    double adjustedAngle =
        (correctedAngle - (bearingForTurn * 180 / math.pi)) % 360;
    if (adjustedAngle < 0) adjustedAngle += 360;
    printConsole(
      'Angle: $angle, Corrected Angle: $correctedAngle, Adjusted Angle: $adjustedAngle, Bearing: $bearingForTurn',
    );
    String direction = '';
    if (adjustedAngle >= 337.5 || adjustedAngle < 22.5)
      direction = 'north';
    else if (adjustedAngle >= 22.5 && adjustedAngle < 67.5)
      direction = 'north-east';
    else if (adjustedAngle >= 67.5 && adjustedAngle < 112.5)
      direction = 'east';
    else if (adjustedAngle >= 112.5 && adjustedAngle < 157.5)
      direction = 'south-east';
    else if (adjustedAngle >= 157.5 && adjustedAngle < 202.5)
      direction = 'south';
    else if (adjustedAngle >= 202.5 && adjustedAngle < 247.5)
      direction = 'south-west';
    else if (adjustedAngle >= 247.5 && adjustedAngle < 292.5)
      direction = 'west';
    else if (adjustedAngle >= 292.5 && adjustedAngle < 337.5)
      direction = 'north-west';
  }

  Future<void> handleSearch(BuildContext context, String input) async {
    FocusScope.of(context).unfocus();
    try {
      if (_isCoordinates(input)) {
        // Xử lý nếu là tọa độ
        List<String> coords = input.split(',');
        double latitude = double.parse(coords[0].trim());
        double longitude = double.parse(coords[1].trim());
        Navigator.pop(
          context,
          LocationModel(
            "${'search_with_coor'.tr} ($latitude,$longitude)",
            latitude,
            longitude,
          ),
        );
      } else {
        try {
          _fetchLocationAPI(query: input);
        } catch (e) {
          printConsole("Lỗi search: $e");
        }
        // Xử lý nếu là địa chỉ
      }
    } catch (ignore) {
      try {} catch (error) {
        printConsole(error.toString());
      }
    }
  }

  Future<void> _fetchLocationAPI({required String query}) async {
    String encodedString = Uri.encodeComponent(query);
    await EasyLoading.show(maskType: EasyLoadingMaskType.black);

    final String url = '$mainUrl/services/locations?text=$encodedString';
    final response = await http.get(
      Uri.parse(url),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final Map<String, dynamic> responseData = json.decode(response.body);
      printConsole('ascsacsac: $responseData');
      final bool status = responseData['status'];
      final Map<String, dynamic> data = responseData['data'];
      printConsole(url);
      if (status) {
        EasyLoading.dismiss();
        final double lat = data['lat'];
        final double lng = data['lng'];
        printConsole('$lat, $lng');
        Navigator.pop(context, LocationModel(query, lat, lng));
      } else {
        EasyLoading.dismiss();
        printConsole('Error: Status is false');
      }
    } else {
      EasyLoading.dismiss();

      printConsole('Failed to load data');
    }
  }

  bool _isCoordinates(String input) {
    final regex = RegExp(
      r'^\s*[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)\s*,\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)\s*$',
    );
    return regex.hasMatch(input);
  }

  MapType _getGoogleMapType(MapType mapType) {
    switch (mapType) {
      case MapType.normal:
        return MapType.normal;
      case MapType.satellite:
        return MapType.satellite;
      case MapType.terrain:
        return MapType.terrain;
      case MapType.hybrid:
        return MapType.hybrid;
      default:
        return MapType.normal;
    }
  }
}
