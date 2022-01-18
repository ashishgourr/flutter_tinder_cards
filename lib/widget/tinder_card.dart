import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tinder_clone/provider/card_provider.dart';
import 'package:provider/provider.dart';

class TinderCard extends StatefulWidget {
  final String urlImage;
  final bool isFront;
  const TinderCard({Key? key, required this.urlImage, required this.isFront})
      : super(key: key);

  @override
  _TinderCardState createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      //adding the size of the screen in our card provider

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? buildFrontCard() : buildCard(),
    );
  }

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            //position from card provider
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            //duration
            final milliseconds = provider.isDragging ? 0 : 450;

            //center position of the image
            final center = constraints.smallest.center(Offset.zero);

            //angle to rotate the card if swiped left or right

            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: milliseconds),
                transform: rotatedMatrix..translate(position.dx, position.dy),
                child: buildCard());
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.endPosition(details);
        },
      );

  Widget buildCard() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.urlImage),
                fit: BoxFit.cover,
                alignment: const Alignment(-0.3, 0)),
          ),
        ),
      );
}
