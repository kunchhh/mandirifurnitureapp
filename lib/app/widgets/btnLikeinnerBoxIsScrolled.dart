import 'package:flutter/material.dart';

class BtnLikeInnerBoxScrolled extends StatefulWidget {
  final bool innerBoxIsScrolled;

  const BtnLikeInnerBoxScrolled({Key? key, required this.innerBoxIsScrolled}) : super(key: key);

  @override
  _BtnLikeInnerBoxScrolledState createState() => _BtnLikeInnerBoxScrolledState();
}

class _BtnLikeInnerBoxScrolledState extends State<BtnLikeInnerBoxScrolled> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked
            ? Colors.red
            : widget.innerBoxIsScrolled
                ? Colors.black
                : Colors.white,
                size: 18,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
      },
    );
  }
}
