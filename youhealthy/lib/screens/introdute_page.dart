import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
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
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                    children: [
                      Text(
                        "youHealthy",
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
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
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  page["image"]!,
                                  height: size.height * 0.40, 
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: size.height * 0.05),
                                Text(
                                  page["text"]!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: _currentPage == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.deepPurple
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign');
                            },
                            child: const Text(
                              "Criar conta",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
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
