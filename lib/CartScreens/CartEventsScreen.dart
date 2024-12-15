import 'package:flutter/material.dart';
import '../Courses.dart';
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
    //final cartItems = LocalCart.instance.getCart();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: LocalCart.instance.getCart().isEmpty
                    ? Center(
                  child: Text(
                    'Your cart is empty :(',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.0 * MediaQuery.of(context).devicePixelRatio,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: LocalCart.instance.getSelectedCourses().length,
                  itemBuilder: (context, index) {
                    final courseName = LocalCart.instance.getSelectedCourses()[index];
                    final webinars = LocalCart.instance.getSelectedWebinars(courseName);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            LocalCart.instance.removeWebinarFromCourse(courseName, webinar);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        webinar['word'],
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
                                    webinar['cost'].toString(),
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
                    '${LocalCart.instance.getTotalPrice()} \$',
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
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

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

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
              borderRadius: BorderRadius.circular(20.0),
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
                  width: 110,
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
