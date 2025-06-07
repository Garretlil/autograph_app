import 'package:autograph_app/core/network/DataConverter.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import '../../core/network/CdekApi.dart';
import '../../core/network/CdekAuth.dart';
import '../../core/services/local_cart_products.dart';
import '../../core/services/user_service.dart';
import '../../data/models/product.dart';

enum Boxes {
  XS(volume: 1836, dimensions: [17.0, 12.0, 9.0]),
  S(volume: 8740, dimensions: [23.0, 19.0, 10.0]),
  M(volume: 12375, dimensions: [33.0, 25.0, 15.0]);

  final double volume;
  final List<double> dimensions;
  const Boxes({
    required this.volume,
    required this.dimensions,
  });
}

class ConfirmationOrderNotifier extends ChangeNotifier {
  static const String _clientId = 'NYnDZhNexvHneGnk29cdGpZuAxwFot6J';
  static const String _clientSecret = 'RglJK9tAYIUUhP2Dt3NuBChjm7iESwkf';
  final CdekApi _cdekApi;
  final UserData _userData = UserData.instance;
  final LocalCartProducts _localCart = LocalCartProducts.instance;
  final Products _productsProvider;

  Map<String, dynamic> _boxCalculationResult = {'sizes': [], 'cost': 0.0, 'weight': 0.0};
  double? _deliveryCost;
  double? _totalCost;
  bool _isLoading = false;
  String? _error;
  List<Product> _filteredProducts = [];

  double get cartCost => _boxCalculationResult['cost'] ?? 0.0;
  double? get deliveryCost => _deliveryCost;
  double? get totalCost => _totalCost;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get cartItems => _filteredProducts;
  Map<int, int> get cartQuantities => _localCart.getCart();

  ConfirmationOrderNotifier(this._productsProvider)
      : _cdekApi = CdekApi(CdekAuth(clientId: _clientId, clientSecret: _clientSecret)) {

    _initialize();
  }

  Future<void> _initialize() async {
    await recalculateCosts();
  }

  void _calculateBoxSizeAndCartCost() {
    final allProducts = _productsProvider.products.products ?? [];
    final cartIdsMap = _localCart.getCart();
    final cartIds = cartIdsMap.keys.toSet();
    _filteredProducts = allProducts
        .where((p) => p.id != null && cartIds.contains(p.id))
        .toList();

    double volume = 0;
    double weight = 0;
    double currentCartCost = 0;

    for (var item in _filteredProducts) {
      final quantity = cartIdsMap[item.id] ?? 0;
      if (quantity > 0) {

        final itemHeight = item.height;
        final itemLength = item.length;
        final itemWidth = item.width;
        final itemWeight = item.weight;
        final itemPrice = double.tryParse(item.price ?? '0') ?? 0.0;

        volume += itemHeight! * itemLength! * itemWidth! * quantity;
        weight += itemWeight! * quantity;
        currentCartCost += itemPrice * quantity;
      }
    }

    List<double> dimensions = [];
    if (volume <= Boxes.XS.volume) {
      dimensions = Boxes.XS.dimensions;
    } else if (volume <= Boxes.S.volume) {
      dimensions = Boxes.S.dimensions;
    } else if (volume <= Boxes.M.volume) {
      dimensions = Boxes.M.dimensions;
    } else {
      dimensions = Boxes.M.dimensions;

    }
    final finalWeight = weight <= 0 ? 0.001 : weight;
    _boxCalculationResult = {
      'sizes': [...dimensions, finalWeight],
      'cost': currentCartCost,
      'weight': finalWeight
    };
  }

  Future<void> _fetchDeliveryCost() async {
    if (_boxCalculationResult['sizes'] == null || (_boxCalculationResult['sizes'] as List).length < 4) {
      _error = 'Не удалось определить размеры посылки.';
      _deliveryCost = null;
      return;
    }
    final sizes = _boxCalculationResult['sizes'] as List<double>;
    if (_userData.pointData.code.isEmpty) {
      _error = 'Пункт выдачи не выбран.';
      _deliveryCost = null;
      return;
    }
    try {
      final cost = await _cdekApi.calculateDeliveryCost(
        _userData.pointData,
        sizes[0],
        sizes[1],
        sizes[2],
        sizes[3],
      );
      if (cost != null) {

        _deliveryCost = cost + 100.0;
        _error = null;
      } else {
        _error = 'Не удалось рассчитать стоимость доставки (null).';
        _deliveryCost = null;
      }
    } catch (e) {
      _error = 'Ошибка расчета доставки: ${e.toString()}';
      _deliveryCost = null;
    }
  }
  void _calculateTotalCost() {
    if (_deliveryCost != null) {
      _totalCost = cartCost + _deliveryCost!;
    } else {
      _totalCost = null;
    }
  }

  Future<void> recalculateCosts() async {
    _isLoading = true;
    _error = null;
    _deliveryCost = null;
    _totalCost = null;
    notifyListeners();
    try {
      _calculateBoxSizeAndCartCost();
      if (_error == null) {
        await _fetchDeliveryCost();
      }
      _calculateTotalCost();
    } catch (e) {
      _error = 'Произошла ошибка при обновлении данных.';
    } finally {
      _isLoading = false;
      notifyListeners();

    }
  }

  Future<void> updateItemQuantity(int productId, int change) async {
    final currentQuantity = _localCart.countProductInCart(productId);
    final newQuantity = currentQuantity! + change;

    if (newQuantity <= 0) {
      //await removeItem(productId);
    } else {
      if (change > 0) {
        _localCart.addProductToCart(productId);
      } else {
        _localCart.removeProductFromCart(productId);
      }
      await recalculateCosts();
    }
  }

  Future<void> removeItem(int productId) async {
    //_localCart.removeAllInstancesOfProduct(productId);
    await recalculateCosts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> placeOrder( ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final sizes = List<double>.from(_boxCalculationResult['sizes'] ?? []);
      if (sizes.length < 4 || _userData.pointData.code.isEmpty) {
        throw Exception("Недостаточно данных для оформления заказа");
      }

      final cartMap = _localCart.getCart();
      final orderItems = _filteredProducts.map((product) {
        final quantity = cartMap[product.id] ?? 1;
        return {
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': quantity,
        };
      }).toList();
      final backendResponse = await _cdekApi.sendOrderToServer(
        userId: _userData.id.toString(),
        pointCode: _userData.pointData.code,
        items: orderItems,
        deliveryCost: _deliveryCost ?? 0,
        totalCost: _totalCost ?? 0,
      );
      final trackingNumber =backendResponse;

      if (trackingNumber == '') {
        return true;
      }

      _localCart.clearCart();
      await recalculateCosts();
      notifyListeners();
      return true;

    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}