import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String title;
  final Function onTap;
  final AssetImage image;

  const MenuTile({
    @required this.title,
    @required this.onTap,
    @required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap,
          splashColor: Colors.grey.withOpacity(0.5),
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
