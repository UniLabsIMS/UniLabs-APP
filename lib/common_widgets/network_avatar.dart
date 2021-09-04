import 'package:flutter/material.dart';
import 'package:unilabs_app/constants.dart';

class NetworkAvatar extends StatelessWidget {
  final double radius;
  final String src;
  final String err;
  final bool removeBorder;

  NetworkAvatar(
      {@required this.radius,
      @required this.src,
      @required this.err,
      this.removeBorder = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: removeBorder ? radius : radius + 1,
      backgroundColor: Colors.black12,
      child: ClipOval(
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Constants.kSecondary,
          child: Image.network(
            src,
            fit: BoxFit.cover,
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
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
