// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pref = await SharedPreferences.getInstance();
  //Eğer okunan değişken localde yoksa
  final showLogin = pref.getBool('showLogin') ?? false;
  runApp(MyApp(
    showLogin: showLogin,
  ));
  //runtime üzerinde widget içinde showlogin çağrı kontrolünü yaparız
}

class MyApp extends StatelessWidget {
  final bool showLogin;
  const MyApp({super.key, required this.showLogin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: showLogin ? const LoginPage() : const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Sayfa kontrollerini sağlamak için;
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (value) => setState(() {
          isLastPage = value == 2;
        }),
        controller: controller,
        children: [
          //Burada Gezilecek sayfalar yer almakta Widget olarak tanımlanmış ve bilgileri eklenmiştir.
          buildContainer(
              title: 'Tanıtım Ekranımızın Birinci Sayfası',
              image: 'assets/1.png'),
          buildContainer(
              title: 'Tanıtım Ekranımızın İkinci Sayfası',
              image: 'assets/2.png'),
          buildContainer(
              title: 'Tanıtım Ekranımızın Üçüncü Sayfası',
              image: 'assets/3.png'),
        ],
      ),
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: () async {
                //shared prefernce'ı entegre ettik
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool(
                    'showLogin', true); //değişkeni butona tıklanınca true yap
                //sonraki sayfaya yönlendirme yapılıyor
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text('KEŞFETMEYE BAŞLA'))
          : Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 218, 218),
                  borderRadius: BorderRadius.circular(20)),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(2); //Page 2'ye atla
                      },
                      child: const Text('Atla')),
                  Center(
                    child: SmoothPageIndicator(
                      count: 3, //dots sayısı
                      controller:
                          controller, //sayfa geçiş kontrolünü sağlamak için...
                      //noktaya tıklanma durumunda;
                      //Animisayonlu sayafa geçişi ve saniyesi belirtildi
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceIn),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        //Page Controllerdan çektiğimiz controllerdan sonraki sayfaya geçişimizi sağlıyoruz.
                        controller.nextPage(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.bounceInOut);
                      },
                      child: const Text('İleri')),
                ],
              ),
            ),
    );
  }
}

Widget buildContainer({
  required String image,
  required String title,
}) {
  return Column(
    children: [Image.asset(image), Text(title)],
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
