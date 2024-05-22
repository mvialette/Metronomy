import 'package:Metronomy/screen/home_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool _showJoinButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/intro_1.JPG',
            fit: BoxFit.cover,
          ),
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Flex(
                  direction: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? Axis.horizontal
                      : Axis.vertical,
                  mainAxisAlignment: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/metronomy_icon_yellow.png',
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 40.0
                          : 80.0,
                      height: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 40.0
                          : 80.0,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'metronomy',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: const Color(0xFFFFC601),
                          ),
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                items: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.welcomeTextOne,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.welcomeTextOne,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                carouselController: _controller,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enlargeFactor: 0.5,
                  height: 200.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      _showJoinButton = index == 1;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1].map((index) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(index),
                    child: Container(
                      width: 15.0,
                      height: 15.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(_current == index ? 0.9 : 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_showJoinButton)
                Container(
                  alignment: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? Alignment.bottomRight
                      : Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                      label: Text(AppLocalizations.of(context)!.join),
                      backgroundColor: const Color(0xFFFFC601),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
