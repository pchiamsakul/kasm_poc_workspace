import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/generated/assets.gen.dart';

class CarouselItem {
  final Image bannerImage;
  final String? bannerText;
  final String? bannerDescription;

  CarouselItem({required this.bannerImage, this.bannerText, this.bannerDescription});
}

class Carousel extends StatelessWidget {
  final int currentIndex;
  final List<CarouselItem> carouselItems;
  final Function(int, CarouselPageChangedReason)? onPageChanged;

  const Carousel({
    super.key,
    required this.currentIndex,
    required this.carouselItems,
    this.onPageChanged,
  });

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(carouselItems.length, (index) {
        return Container(
          width: currentIndex == index ? 16 : 6,
          height: 6,
          margin: EdgeInsets.only(right: 2),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: currentIndex == index ? Colors.white : Colors.white.withValues(alpha: 0.4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarouselSlider(
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
            onPageChanged: onPageChanged,
          ),
          items: List.generate(carouselItems.length, (index) {
            final item = carouselItems[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(child: Assets.images.placeholder.image(color: Colors.grey)),
                  ),
                  if (item.bannerText != null) ...[
                    Text(
                      item.bannerText ?? '',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  if (item.bannerDescription != null) ...[
                    Text(
                      item.bannerDescription ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    SizedBox(height: 36),
                  ],
                ],
              ),
            );
          }),
        ),
        Positioned(bottom: 16, left: 0, right: 0, child: _buildCarouselIndicator()),
      ],
    );
  }
}
