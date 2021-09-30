import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/classes/utils.dart';
import 'dart:async';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';

class DatePicker extends StatelessWidget {
  final String selectedDate;
  final double fontSize;

  DatePicker({this.selectedDate, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 3),
            child: GestureDetector(
              onTap: (() {
                _chooseDate(
                  context,
                  selectedDate,
                );
              }),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                padding: EdgeInsets.all(6),
                dashPattern: [8, 4],
                strokeWidth: 2,
                color: Colors.black,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.calendarDay,
                              size: 24,
                              color: Constants.kHintText,
                            ),
                            SizedBox(width: 5),
                            BlocBuilder<HandoverBloc, HandoverState>(
                              builder: (context, state) {
                                return Text(
                                  "Due Date: " + state.dueDate.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontSize,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Tap to Edit Due Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize,
                            color: Constants.kHintText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    // ignore: close_sinks
    final handoverBloc = BlocProvider.of<HandoverBloc>(context);
    var now = new DateTime.now();
    var initialDate = Util.convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isAfter(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2050),
    );
    if (result != null) {
      handoverBloc.add(
        UpdateDueDateEvent(
          dateString: Util.convertToString(result),
        ),
      );
    }
    return;
  }
}
