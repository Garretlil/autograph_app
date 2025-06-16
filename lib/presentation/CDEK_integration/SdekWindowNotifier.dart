import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../core/network/CdekApi.dart';
import '../../core/network/CdekAuth.dart';
import '../../core/services/MetroStation.dart';
import '../../core/services/gps_module.dart';
import 'CustomClusterPainter.dart';


class PointPlaceMark{
  final double latitude;
  final double longitude;
  final String description;
  final String adress;
  final String type;
  final String metro;
  final String workTime;
  final String code;

  PointPlaceMark({
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.adress,
    required this.type,
    required this.metro,
    required this.workTime,
    required this.code
  });
}
class CDEKWindowNotifier extends ChangeNotifier {
  static const clientId = 'NYnDZhNexvHneGnk29cdGpZuAxwFot6J';
  static const clientSecret = 'RglJK9tAYIUUhP2Dt3NuBChjm7iESwkf';

  late final CdekAuth auth;
  late final CdekApi api;
  List<MetroStation>? stations;


  List<DeliveryPoint> points = [];
  List<PlacemarkMapObject> placemarks = [];

  ClusterizedPlacemarkCollection? clusterizedCollection;
  void Function(PointPlaceMark)? onPlacemarkTap;

  CDEKWindowNotifier() {
    auth = CdekAuth(clientId: clientId, clientSecret: clientSecret);
    api = CdekApi(auth);
    stations=[];
  }

  late final GeoLocator geoLocator;
  YandexMapController? controller;
  double? zoom;
  Point currentPosition = const Point(latitude: 55.7522, longitude: 37.6156);

  Future<void> _loadPoints() async {
    try {
      points = await api.fetchDeliveryPoints();

      placemarks = points.map((point) {
        return PlacemarkMapObject(
          mapId: MapObjectId('MapObject_${point.latitude}_${point.longitude}'),
          point: Point(latitude: point.latitude, longitude: point.longitude),
          opacity: 1,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(point.type=='PVZ'? 'assets/pvz.png' : 'assets/postamat.png'),
              scale: 1,
            ),
          ),
          onTap: (_, __) {
            final pointData = PointPlaceMark(
              latitude: point.latitude,
              longitude: point.longitude,
              description: point.name,
              adress: point.address,
              type: point.type,
              metro: point.nearestMetro ?? '',
              workTime: point.workTime,
              code: point.code
            );
            onPlacemarkTap?.call(pointData);
          },
        );
      }).toList();

      print(points.length);
      notifyListeners();
    } catch (e) {
      print('Ошибка загрузки ПВЗ: $e');
    }
  }
  void _clusterizePoints() {
    clusterizedCollection=ClusterizedPlacemarkCollection(
        mapId: const MapObjectId('0'),
        placemarks: placemarks,
        radius: 50,
        minZoom: 50,
        onClusterAdded: (self, cluster) async {
          return cluster.copyWith(
            appearance: cluster.appearance.copyWith(
              opacity: 1.0,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromBytes(
                    await ClusterIconPainter(cluster.size)
                        .getClusterIconBytes(),
                  ),
                ),
              ),
            ),
          );
        },
        onClusterTap: (self, cluster) async {
          await controller?.moveCamera(
            animation: const MapAnimation(
                type: MapAnimationType.linear, duration: 0.3),
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: cluster.placemarks.first.point,
                zoom: zoom! + 1,
              ),
            ),
          );
        });
    print('new cluster');
    notifyListeners();
  }

  Future<void> onMapCreated(YandexMapController controller) async {
    this.controller = controller;
    await _loadPoints();
    zoom = 10;
    _clusterizePoints();
    print("Кластеры добавлены");
    stations = await fetchMetroStations();
    notifyListeners();
  }

}
