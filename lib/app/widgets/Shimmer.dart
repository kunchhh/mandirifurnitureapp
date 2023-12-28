import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHorizontal extends StatelessWidget {
  const ShimmerHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100]!,
              ),
              height: 170,
              width: 165,
            ),
            SizedBox(height: 10,),

            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100]!,
                  ),
                  height: 20,
                  width: 115,
                ),SizedBox(width: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100]!,
                  ),
                  height: 20,
                  width: 30,
                ),
              ],
            ),
            SizedBox(height: 10,),
             Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100]!,
              ),
              height: 40,
              width: 165,
            ),
            SizedBox(height: 10,),
             Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100]!,
              ),
              height: 60,
              width: 165,
            ),
          ],
        ),
      ),
    );
  }
}
