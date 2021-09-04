import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
import 'package:unilabs_app/views/item_search/components/state_bubble.dart';

class ItemDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final itemSearchBloc = BlocProvider.of<ItemSearchBloc>(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: BlocBuilder<ItemSearchBloc, ItemSearchState>(
        builder: (context, state) {
          return Column(
            children: [
              NetworkAvatar(
                radius: 60,
                src:
                    "https://www.hallmarknameplate.com/wp-content/uploads/2018/12/AdobeStock_4381957.jpeg",
                err: "Img",
              ),
              Text(
                "Item Name",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Item ID",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              StateBubble(
                stateName: "Available",
                color: Colors.yellow[800],
              ),
              SizedBox(height: 10),
              Text(
                "Description here... Lorem ipsum dolor sit amet. Duis at velit justo. Pellentesque aliquet ante tellus, eu sollicitudin risus porttitor non. Fusce orci nibh, egestas a blandit ac, euismod a urna. Mauris ac magna et erat aliquam scelerisque. Donec lobortis libero vel maximus tincidunt. Morbi rhoncus quis turpis in consequat. Nullam non tortor sed ex aliquet sagittis. Morbi ut ex eu eros facilisis congue.",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              CustomSmallButton(
                color: Colors.grey,
                text: "Toggle State",
                onPressed: () {},
              ),
              CustomSmallButton(
                color: Colors.red,
                text: "Delete Item",
                onPressed: () {
                  itemSearchBloc.add(DeleteItemEvent());
                },
              ),
              SizedBox(height: 20),
              CustomIconButton(
                  text: "Scan Another",
                  onTap: () {
                    itemSearchBloc.add(ClearItemEvent());
                  })
            ],
          );
        },
      ),
    );
  }
}
