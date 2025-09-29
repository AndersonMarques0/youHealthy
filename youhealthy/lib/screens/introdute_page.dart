import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youhealthy/widgets/intro_content_card.dart';
import 'package:youhealthy/widgets/intro_dot_indicator.dart';
import 'package:youhealthy/widgets/intro_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = const [
    {
      "image": "assets/images/saude.png",
      "text": "Crie hábitos saudáveis em seu dia a dia."
    },
    {
      "image": "assets/images/exercicios.png",
      "text": "Informações sobre exercícios físicos e treinos."
    },
    {
      "image": "assets/images/frutas.png",
      "text": "Aprenda sobre vida e alimentação saudável."
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final double responsiveTitleFontSize = (titleStyle?.fontSize ?? 24.0) + size.width * 0.02;
    final double imageAreaHeight = size.height * 0.40;


    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "youHealthy",
                        style: titleStyle?.copyWith(
                          fontSize: responsiveTitleFontSize,
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        height: size.height * 0.60, 
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: pages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final page = pages[index];
                            return IntroContentCard(
                              imagePath: page["image"]!,
                              text: page["text"]!,
                              imageHeight: imageAreaHeight,
                            );
                          },
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => IntroDotIndicator(
                            index: index,
                            currentPage: _currentPage,
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),
                      const IntroButton(),
                      
                      SizedBox(height: size.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: const [
                              TextSpan(text: "Você tem uma conta? "),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
