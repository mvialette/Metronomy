import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class LoaderScreen extends StatefulWidget {
  @override
  _LoaderScreenState createState() => _LoaderScreenState();
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
          // Background image for the loader
          Image.asset(
            'assets/images/bkg1.JPG',
            fit: BoxFit.cover,
          ),
          // Content for the loader
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Metronomy text centered and slightly higher
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo1.png',
                      width: 80.0, // Slightly smaller
                      height: 80.0, // Slightly smaller
                    ),
                    SizedBox(height: 10.0), // Additional space
                    Text(
                      'Metronomy',
                      style: GoogleFonts.molle(
                        fontSize: 25.0, // Smaller font size
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100.0), 
              // Carousel with two parts of text
              CarouselSlider(
                items: [
                  // First part of the text
                  Container(
                    padding: EdgeInsets.only(right: 35.0),
                    child: Center(
                      child: Text(
                        'Batteurs passionnés, rejoignez notre communauté en vous inscrivant pour découvrir ce monde exceptionnel.',
                        style: GoogleFonts.nunito(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Second part of the text
                  Container(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Center(
                      child: Text(
                        'Frappez avec nous et laissez votre rythme résonner et créez de la musique qui fait vibrer !',
                        style: GoogleFonts.nunito(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                carouselController: _controller,
                options: CarouselOptions(
                  height: 200.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      _showJoinButton = index == 1; // Show button on the second page
                    });
                  },
                ),
              ),
              // SizedBox to add space between the button and the indicator bar
              SizedBox(height: 20.0),
              // Indicator bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1].map((index) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(index),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(_current == index ? 0.9 : 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Join button at the bottom center
              if (_showJoinButton)
                  
                  FloatingActionButton.extended(
                    elevation: 25.0,
                    label: Text('Rejoindre'),
                    onPressed: () {
                      // Handle button press
                    },
                    backgroundColor: Color(0xFFFFC601), // Background color
                    foregroundColor: Colors.black, // Text color
                   
                   
                      
                    
                  ),
                
            ],
          ),
        ],
      ),
    );
  }
}
