import 'package:flutter/material.dart';
import '../HomeScreens/LocalCart.dart';


class CartEvents extends StatefulWidget {
  const CartEvents({super.key});

  @override
  State<CartEvents> createState() => _CartEvents();
}

class _CartEvents extends State<CartEvents> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = LocalCart.instance.getCart();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'), // Задаем фон
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            12.0 * MediaQuery.of(context).devicePixelRatio,
            15.0 * MediaQuery.of(context).devicePixelRatio,
            12.0 * MediaQuery.of(context).devicePixelRatio,
            0.0 * MediaQuery.of(context).devicePixelRatio,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя панель
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Возврат на предыдущий экран
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'AUTOGRAPH',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'CART',
                        style: TextStyle(
                          fontSize: 25.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24), // Для баланса
                ],
              ),
              const SizedBox(height: 30.0),
              // Секция EVENTS
              Expanded(
                child: cartItems.isEmpty ?
                     Center(
                      child: Text(
                        'Your cart is empty :(',
                        style: TextStyle(color: Colors.white,
                            fontSize: 8.0 * MediaQuery.of(context).devicePixelRatio,
                             fontFamily: 'Inria Serif'
                        ),
                      ),
                    )
                :ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final course = cartItems[index]; // Элемент курса
                    final courseName = course['courseName']; // Название курса
                    final webinars = course['webinars'] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название курса
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            courseName,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Inria Serif',
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: webinars.length,
                          itemBuilder: (context, webinarIndex) {
                            final webinar = webinars[webinarIndex];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            LocalCart.instance.removeWebinarFromCourse(courseName, webinar);
                                            LocalCart.instance.getTotalPrice();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        webinar['word'], // Название вебинара
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'Inria Serif',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${webinar['cost']} \$', // Цена вебинара
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontFamily: 'Inria Serif',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              // Общая сумма
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL:',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  Text(
                    '${LocalCart.instance.getTotalPrice()} \$', // Общая сумма
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              // Кнопка BUY
              const Center(
                child: GradientAnimatedButton()
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
class GradientAnimatedButton extends StatefulWidget {
  const GradientAnimatedButton({super.key});

  @override
  State<GradientAnimatedButton> createState() => _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<GradientAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Создаем контроллер анимации
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Длительность одного цикла анимации
      vsync: this,
    );

    // Анимация будет идти от 0.0 до 1.0 и обратно
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {


      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // скругление углов
            ),
            child: InkWell(
              onTap: () {

              },
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.black.withOpacity(0.1),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(Colors.deepOrange, Colors.black, _animation.value)!,
                      Color.lerp(Colors.black, Colors.deepOrange, _animation.value)!,
                    ],
                  ),
                ),
                child: Container(
                  width: 110, // Убираем фиксированную ширину
                  height: 50, // Высота кнопки
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0), // Устанавливаем отступы внутри
                  child: const Text(
                    'BUY',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Inria Serif',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
