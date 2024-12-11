import 'package:flutter/material.dart';


class EventsOnlineOffline extends StatefulWidget {
  const EventsOnlineOffline({super.key});

  @override
  State<EventsOnlineOffline> createState() => _EventsOnlineOfflineState();
}

class _EventsOnlineOfflineState extends State<EventsOnlineOffline> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              // Верхняя панель с кнопкой назад
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0 * MediaQuery.of(context).devicePixelRatio), // Отступ сверху только для кнопки
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Возврат на предыдущий экран
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 10.0 * MediaQuery.of(context).devicePixelRatio,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: 6.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'EVENTS',
                        style: TextStyle(
                          fontSize: 20.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24), // Пустое место справа для баланса
                ],
              ),
              SizedBox(height: 60.0 * MediaQuery.of(context).devicePixelRatio),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/EventsOnline');
                      },
                      child: Text(
                        'ONLINE',
                        style: TextStyle(
                          fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 70.0 * MediaQuery.of(context).devicePixelRatio),
                    Text(
                      'OFFLINE',
                      style: TextStyle(
                        fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
