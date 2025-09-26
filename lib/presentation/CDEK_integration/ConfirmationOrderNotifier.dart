import 'package:autograph_app/core/network/DataConverter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/network/CdekApi.dart';
import '../../core/network/CdekAuth.dart';
import '../../core/services/local_cart_products.dart';
import '../../core/services/user_service.dart';
import '../../core/utils/api_handler.dart';
import '../../data/models/product.dart';
import '../../data/repositories/UserRepository.dart';
import '../../domain/entities/BoxModel.dart';


class ConfirmationOrderNotifier extends ChangeNotifier {
  static const String _clientId = 'NYnDZhNexvHneGnk29cdGpZuAxwFot6J';
  static const String _clientSecret = 'RglJK9tAYIUUhP2Dt3NuBChjm7iESwkf';

  final CDEKApi _cdekApi;
  final LocalCartProducts _localCart = LocalCartProducts.instance;
  final Products _productsProvider;
  final userRepository = UserRepositoryImpl();

  late UserData loadedData;

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
      : _cdekApi = CDEKApi(CdekAuth(clientId: _clientId, clientSecret: _clientSecret)) {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      loadedData = await userRepository.loadUserData();
      final currentPointData = UserData.instance.pointData;
      if (currentPointData.code.isNotEmpty) {
        loadedData.pointData = currentPointData;
      }

      await recalculateCosts();
    } catch (e) {
      _error = 'Ошибка при инициализации: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateBoxSizeAndCartCost() {
    final allProducts = _productsProvider.products.products ?? [];
    final cartIdsMap = _localCart.getCart();
    final cartIds = cartIdsMap.keys.toSet();

    _filteredProducts = allProducts.where((p) => p.id != null && cartIds.contains(p.id)).toList();

    double volume = 0;
    double weight = 0;
    double currentCartCost = 0;

    for (var item in _filteredProducts) {
      final quantity = cartIdsMap[item.id] ?? 0;
      if (quantity > 0) {
        volume += (item.height ?? 0) * (item.length ?? 0) * (item.width ?? 0) * quantity;
        weight += item.weight! * quantity;
        final itemPrice = double.tryParse(item.price ?? '0') ?? 0.0;
        currentCartCost += itemPrice * quantity;
      }
    }

    List<double> dimensions;
    if (volume <= Boxes.XS.volume) {
      dimensions = Boxes.XS.dimensions;
    } else if (volume <= Boxes.S.volume) {
      dimensions = Boxes.S.dimensions;
    } else {
      dimensions = Boxes.M.dimensions;
    }

    final finalWeight = weight <= 0 ? 0.001 : weight;
    _boxCalculationResult = {
      'sizes': [...dimensions, finalWeight],
      'cost': currentCartCost,
      'weight': finalWeight,
    };
  }

  Future<bool> _fetchDeliveryCost() async {
    if ((_boxCalculationResult['sizes'] as List).length < 4) {
      _error = 'Не удалось определить размеры посылки.';
      _deliveryCost = null;
      return false;
    }

    final sizes = _boxCalculationResult['sizes'] as List<double>;

    if (loadedData.pointData.code.isEmpty) {
      _error = 'Пункт выдачи не выбран.';
      _deliveryCost = null;
      return false;
    }

    try {
      final cost = await _cdekApi.calculateDeliveryCost(
        loadedData.pointData,
        sizes[0],
        sizes[1],
        sizes[2],
        sizes[3],
      );

      if (cost != null) {
        _deliveryCost = cost + 100.0;
        _error = null;
        return true;
      } else {
        _error = 'Не удалось рассчитать стоимость доставки.';
        return false;
      }
    } catch (e) {
      _error = 'Ошибка расчета доставки: $e';
      return false;
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
      final deliveryFetched = await _fetchDeliveryCost();
      if (deliveryFetched) {
        _calculateTotalCost();
      }
    } catch (e) {
      _error = 'Произошла ошибка при обновлении данных: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> updateItemQuantity(int productId, int change) async {
  //   final currentQuantity = _localCart.countProductInCart(productId);
  //   final newQuantity = currentQuantity! + change;
  //
  //   if (newQuantity > 0) {
  //     if (change > 0) {
  //       _localCart.addProductToCart(productId);
  //     } else {
  //       _localCart.removeProductFromCart(productId);
  //     }
  //     await recalculateCosts();
  //   }
  // }

  Future<void> removeItem(int productId) async {
    await recalculateCosts();
  }

  Future<void> placeOrder(BuildContext context,void Function(bool) toggle,String fullName,String phoneNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await handleApiCall(
      context: context,
      request: () async {
        final sizes = List<double>.from(_boxCalculationResult['sizes'] ?? []);
        if (sizes.length < 4 || loadedData.pointData.code.isEmpty) {
          throw AppException("Недостаточно данных для оформления заказа.");
        }
        final cartMap = _localCart.getCart();
        final orderItems = _filteredProducts.map((product) {
          final quantity = cartMap[product.id] ?? 1;
          return {
            'product_id': product.id,
            'quantity': quantity,
          };
        }).toList();

        var t =await _cdekApi.createCdekOrder(
          fullName: fullName,
          phoneNumber: phoneNumber,
          point: loadedData.pointData.code,
          items: orderItems,
          length: sizes[0],
          height: sizes[1],
          width: sizes[2],
          weight: sizes[3],
        );

        _localCart.clearCart();
        await recalculateCosts();
      },
      onSuccess: (_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              backgroundColor: Colors.blueGrey,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/confetti.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Заказ оформлен!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Хорошо",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        Navigator.popUntil(context, (route) => route.isFirst);
        toggle(true);
      },
      onUnauthorized: () {
        _error = "Сессия истекла. Повторите вход.";
      },
    );
    _isLoading = false;
    notifyListeners();
  }

}
