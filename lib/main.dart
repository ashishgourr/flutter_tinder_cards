import 'package:flutter/material.dart';
import 'package:flutter_tinder_clone/provider/card_provider.dart';
import 'package:flutter_tinder_clone/widget/tinder_card.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Tinder Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.purple[100],
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: buildCards()),
      ),
    );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;

    return Stack(
      children: urlImages
          .map((urlImage) => TinderCard(
              urlImage: urlImage, isFront: urlImages.last == urlImage))
          .toList(),
    );
  }
}
