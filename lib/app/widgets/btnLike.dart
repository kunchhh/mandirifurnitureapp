import 'package:flutter/material.dart';

class btnLike extends StatefulWidget {
  @override
  _btnLikeState createState() => _btnLikeState();
}

class _btnLikeState extends State<btnLike> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.black,
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