import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/home/bloc/home_bloc.dart';
import 'package:unilabs_app/views/home/bloc/home_event.dart';
import 'package:unilabs_app/views/home/bloc/home_state.dart';
import 'package:unilabs_app/views/home/components/menu_tile.dart';
import 'package:unilabs_app/views/home/components/profile_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final homeBloc = BlocProvider.of<HomeBloc>(context);
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
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return (state.loading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 5),
                    BlocBuilder<RootBloc, RootState>(
                      builder: (context, state) {
                        return ProfileCard(
                          firstName: state.user.firstName != null &&
                                  state.user.firstName.isNotEmpty
                              ? state.user.firstName
                              : 'First',
                          lastName: state.user.lastName != null &&
                                  state.user.lastName.isNotEmpty
                              ? state.user.lastName
                              : 'Last',
                          labName: state.user.lab != null &&
                                  state.user.lab.isNotEmpty
                              ? state.user.lab
                              : 'Lab Name',
                          imgSrc: state.user.imageURL != null
                              ? state.user.imageURL
                              : Constants.kDefaultProfileImageURL,
                        );
                      },
                    ),
                    SizedBox(height: 20),
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
                                  image: AssetImage(Constants.kSearchItemImage),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, "/search");
                                  },
                                ),
                                MenuTile(
                                  title: 'Handover Items',
                                  image:
                                      AssetImage(Constants.kHandoverItemsImage),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, "/handover");
                                  },
                                ),
                                MenuTile(
                                  title: 'Temporary Handover',
                                  image: AssetImage(
                                      Constants.kTemporaryHandoverImage),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      "/temp-handover",
                                    );
                                  },
                                ),
                                MenuTile(
                                  title: 'Returning Items',
                                  image:
                                      AssetImage(Constants.kReturnItemsImage),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      "/item-return",
                                    );
                                  },
                                ),
                              ],
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 50,
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
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        homeBloc.add(LogoutEvent());
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
                );
        },
      ),
    );
  }
}
