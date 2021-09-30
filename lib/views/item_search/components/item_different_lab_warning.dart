import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';

class ItemOfDifferentLabWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemSearchBloc = BlocProvider.of<ItemSearchBloc>(context);
    return GestureDetector(
      onTap: () => itemSearchBloc.add(ClearItemEvent()),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(6),
        dashPattern: [8, 4],
        strokeWidth: 2,
        color: Constants.kErrorColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                FontAwesomeIcons.exclamationTriangle,
                color: Constants.kWarningColor,
                size: 64,
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'OOPS!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'The item scanned does not belong to your lab. Please rescan an item belonging to your lab.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'Tap to Go Back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Constants.kErrorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
