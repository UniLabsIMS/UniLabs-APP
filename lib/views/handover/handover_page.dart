import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:unilabs_app/views/handover/step_pages/intial_page.dart';
import 'package:unilabs_app/views/handover/step_pages/item_scan_page.dart';

class HandoverPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<HandoverBloc, HandoverState>(
        buildWhen: (previous, current) => previous.step != current.step,
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                switchInCurve: Curves.ease,
                switchOutCurve: Curves.ease,
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                          begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                layoutBuilder: (currentChild, previousChildren) => currentChild,
                child: pageSwitcher(state.step)),
          );
        });
  }

  Widget pageSwitcher(HandoverProcessStep step) {
    switch (step) {
      case HandoverProcessStep.InitialStep:
        return InitialPage();
        break;
      case HandoverProcessStep.ItemScanStep:
        return ItemScanPage();
        break;
      default:
        return InitialPage();
        break;
    }
  }
}
