import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
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
                            : "https://www.hallmarknameplate.com/wp-content/uploads/2018/12/AdobeStock_4381957.jpeg",
                        err: "Img",
                      ),
                      Text(
                        state.item.parentDisplayItemName.toUpperCase(),
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
                      SizedBox(height: 20),
                      StateBubble(
                        stateName: state.item.state,
                        color: Colors.pink[800],
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
                                  : "Mark Item Available",
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
                      (state.item.state == ItemRepository.AvailableState
                          ? CustomSmallButton(
                              color: Colors.red,
                              text: "Delete Item",
                              onPressed: () {
                                itemSearchBloc.add(DeleteItemEvent());
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
