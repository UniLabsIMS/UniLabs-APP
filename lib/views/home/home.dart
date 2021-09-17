import 'package:flutter/material.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/home/components/menu_tile.dart';
import 'package:unilabs_app/views/home/components/profile_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double marginHorizontal = screenWidth - 40 < Constants.kMaxHomeDetailWidth
        ? 20
        : (screenWidth - Constants.kMaxHomeDetailWidth) / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UniLabs',
          style: TextStyle(letterSpacing: 1.5),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileCard(
            firstName: 'First',
            lastName: 'Last',
            labName: 'Lab Name',
            imgSrc: '',
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: marginHorizontal,
                vertical: 25,
              ),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 10,
                    children: [
                      MenuTile(
                        title: 'Search Item',
                        image: AssetImage('assets/images/search_item.jpg'),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/search");
                        },
                      ),
                      MenuTile(
                        title: 'Handover Items',
                        image: AssetImage('assets/images/handover_items.jpg'),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/handover");
                        },
                      ),
                      MenuTile(
                        title: 'Temporary Handover',
                        image:
                            AssetImage('assets/images/temporary_handover.jfif'),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            "/temp-handover",
                          );
                        },
                      ),
                      MenuTile(
                        title: 'Returning Items',
                        image: AssetImage('assets/images/accept_items.jfif'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: marginHorizontal - 20,
                          ),
                          child: TextButton(
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              elevation: null,
                              primary: Constants.kDarkPrimary,
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
