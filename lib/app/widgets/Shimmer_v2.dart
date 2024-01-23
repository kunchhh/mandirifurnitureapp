import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerV2 extends StatelessWidget {
  const ShimmerV2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               children: [
                 Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100]!,
                  ),
                  height: 168,
                  width: 375,
                 ),
                 
               ],
             ),

          ],
        ),
      )
    );
  }
}