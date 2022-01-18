import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Card status
enum CardStatus { like, dislike, superlike }

class CardProvider extends ChangeNotifier {
  //images
  List<String> _urlImages = [];
  //Initial values
  bool _isDragging = false;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  double _angle = 0;

  //getter to get access to above values

  List<String> get urlImages => _urlImages;

  Offset get position => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
  }

// setter to set the screen size
  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  //methods==> when we swipe the cards around

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

// every time we drag our card around the position is updated.
  void updatePosition(DragUpdateDetails details) {
    //updating the position
    _position += details.delta;
    //updating the angle
    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition(DragEndDetails details) {
    _isDragging = false;
    notifyListeners();

    //now to display the status of the card

    final status = getStatus();

    //displaying the popup status

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: status.toString().split('.').last.toUpperCase(), fontSize: 30);
    }

    switch (status) {
      case CardStatus.like:
        like();
        break;

      case CardStatus.dislike:
        dislike();
        break;

      case CardStatus.superlike:
        superlike();
        break;
      default:
    }

    resetPosition();
  }

// return the card to its initial postion
  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  //method to return the status of the card

  CardStatus? getStatus() {
    //determine whether we have dragged to the left or the right side.
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    final delta = 100;
    // if we move our image more than 100px to the right side
    if (x >= delta) {
      return CardStatus.like;
    } else if (x <= -delta) {
      return CardStatus.dislike;
    }
    //if we swipe 50 px up => superlike
    else if (y <= -delta / 2 && forceSuperLike) {
      return CardStatus.superlike;
    }
  }

  //to display the like status

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;
    await Future.delayed(Duration(milliseconds: 200));
    _urlImages.removeLast();

    resetPosition();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superlike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();

    notifyListeners();
  }

  void resetUsers() {
    _urlImages = <String>[
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1600&q=60",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1600&q=60",
      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1528&q=80",
      "https://images.unsplash.com/photo-1543096222-72de739f7917?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1587&q=80",
      "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fHBlb3BsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=1600&q=60",
      "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHBlb3BsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=1600&q=60",
      "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80"
    ].reversed.toList();

    notifyListeners();
  }
}
