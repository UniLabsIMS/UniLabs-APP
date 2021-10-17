import 'package:flutter/material.dart';

class NetworkAvatar extends StatelessWidget {
  final double radius;
  final String src;
  final String err;
  final double borderWidth;

  NetworkAvatar(
      {@required this.radius,
      @required this.src,
      @required this.err,
      this.borderWidth = 2});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: (radius + borderWidth),
      backgroundColor: Colors.black,
      child: ClipOval(
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          child: Image.network(
            src,
            fit: BoxFit.fill,
            width: radius * 2,
            height: radius * 2,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: (loadingProgress.expectedTotalBytes != null)
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Text(
              err,
              style: TextStyle(
                fontSize: radius * 0.75,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
