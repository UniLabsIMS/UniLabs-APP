import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/common_widgets/warning_dialog_title.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
import 'package:unilabs_app/views/item_search/components/item_different_lab_warning.dart';
import 'package:unilabs_app/views/item_search/components/state_bubble.dart';

import '../../../constants.dart';

class ItemDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final itemSearchBloc = BlocProvider.of<ItemSearchBloc>(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: BlocBuilder<ItemSearchBloc, ItemSearchState>(
          builder: (context, state) {
        return BlocBuilder<RootBloc, RootState>(
          builder: (rootContext, rootState) {
            return (state.item.labName != rootState.user.lab
                ? Center(
                    child: ItemOfDifferentLabWarning(),
                  )
                : Column(
                    children: [
                      NetworkAvatar(
                        radius: 60,
                        src: state.item.parentDisplayItemImageURL.isNotEmpty
                            ? state.item.parentDisplayItemImageURL
                            : Constants.kDefaultItemImageURL,
                        err: "Img",
                      ),
                      SizedBox(height: 10),
                      Text(
                        state.item.parentDisplayItemName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 32),
                      ),
                      SizedBox(height: 10),
                      Text(
                        state.item.id,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 10),
                      StateBubble(
                        stateName: state.item.state,
                        color: Colors.pink[600],
                      ),
                      SizedBox(height: 20),
                      Text(
                        state.item.parentDisplayItemDescription,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      (state.item.state == ItemRepository.AvailableState ||
                              state.item.state == ItemRepository.DamagedState)
                          ? CustomSmallButton(
                              color: Constants.kSuccessColor,
                              text: state.item.state ==
                                      ItemRepository.AvailableState
                                  ? "Mark Item as Damaged"
                                  : "Mark Item as Available",
                              onPressed: () {
                                String newState = state.item.state ==
                                        ItemRepository.AvailableState
                                    ? ItemRepository.DamagedState
                                    : ItemRepository.AvailableState;
                                itemSearchBloc.add(
                                    ChangeItemStateEvent(newState: newState));
                              },
                            )
                          : Container(),
                      (state.item.state == ItemRepository.AvailableState ||
                              state.item.state == ItemRepository.DamagedState
                          ? CustomSmallButton(
                              color: Colors.red,
                              text: "Delete Item",
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => new AlertDialog(
                                    title: WarningDialogTitle(
                                      title: "Are You Sure?",
                                    ),
                                    content: AlertDialogBody(
                                      content:
                                          "Do you want to delete the item permanently from the system? This action can not be reversed.",
                                    ),
                                    actions: <Widget>[
                                      DialogButton(
                                        color: Constants.kSuccessColor,
                                        text: "No",
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      DialogButton(
                                          color: Constants.kErrorColor,
                                          text: "Yes",
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            itemSearchBloc
                                                .add(DeleteItemEvent());
                                          }),
                                    ],
                                  ),
                                );
                              },
                            )
                          : SizedBox(height: 40)),
                      SizedBox(height: 20),
                      CustomIconButton(
                          text: "Scan Another",
                          onTap: () {
                            itemSearchBloc.add(ClearItemEvent());
                          })
                    ],
                  ));
          },
        );
      }),
    );
  }
}
