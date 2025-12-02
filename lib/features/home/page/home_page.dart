import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/generated/assets.gen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<int> _carouselItems = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
  }

  Widget carousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 400,
        initialPage: 0,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items:
          _carouselItems.map((i) {
            return Container(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top, 16, 0),
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(child: Assets.images.logo.image()),
                  SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Hi Amanda! $i', style: TextStyle(fontSize: 16.0)),
                            Text('These are today’s picks for you', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.search, size: 24, color: Colors.white),
                      Icon(Icons.notifications, size: 24, color: Colors.white),
                    ],
                  ),
                  Expanded(child: Center(child: Assets.svg.check.svg())),
                  Text(
                    'What’s Big at Kallang This Week'.toUpperCase(),
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text('Hi Amanda! $i', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 14),
                  _buildCarouselIndicator(),
                  SizedBox(height: 14),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          _carouselItems.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: _currentIndex == entry.key ? BoxShape.rectangle : BoxShape.circle,
                color:
                    _currentIndex == entry.key ? Colors.white : Colors.white.withValues(alpha: 0.4),
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: <Widget>[carousel(), Text('Home')]));
  }
}
