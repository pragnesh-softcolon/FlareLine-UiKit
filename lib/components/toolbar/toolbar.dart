library flareline_uikit;

import 'package:flareline_uikit/components/badge/anim_badge.dart';
import 'package:flareline_uikit/components/buttons/button_widget.dart';
import 'package:flareline_uikit/components/forms/search_widget.dart';
import 'package:flareline_uikit/core/theme/flareline_colors.dart';
import 'package:flareline_uikit/service/localization_provider.dart';
import 'package:flareline_uikit/service/theme_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ToolBarWidget extends StatelessWidget {
  bool? showMore;
  bool? showChangeTheme;
  bool showSearch = false;
  final Widget? userInfoWidget;

  ToolBarWidget(
      {super.key,
      this.showMore,
      this.showChangeTheme,
      required this.showSearch,
      this.userInfoWidget});

  @override
  Widget build(BuildContext context) {
    return _toolsBarWidget(context);
  }

  _toolsBarWidget(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        ResponsiveBuilder(builder: (context, sizingInformation) {
          // Check the sizing information here and return your UI
          if ((showMore ?? false) ||
              sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
            return InkWell(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 1)),
                alignment: Alignment.center,
                child: const Icon(Icons.more_vert),
              ),
              onTap: () {
                if (Scaffold.of(context).isDrawerOpen) {
                  Scaffold.of(context).closeDrawer();
                  return;
                }
                Scaffold.of(context).openDrawer();
              },
            );
          }

          return const SizedBox();
        }),
        showSearch
            ? ResponsiveBuilder(builder: (context, sizingInformation) {
                // Check the sizing information here and return your UI
                if (!(showMore ?? false) &&
                    sizingInformation.deviceScreenType ==
                        DeviceScreenType.desktop) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 280,
                    child: const SearchWidget(),
                  );
                }

                return const SizedBox();
              })
            : const SizedBox(),
        const Spacer(),
        if (userInfoWidget != null)
          InkWell(
            child: Container(
              child: userInfoWidget!,
            ),
            onTap: () async {
              await showMenu(
                color: Colors.white,
                context: context,
                position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 100, 80, 0, 0),
                items: <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('My Profile'),
                    onTap: () {
                      onProfileClick(context);
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Log out'),
                  ),
                ],
                // Handle the selected item
              ).then((selectedValue) async {
                if (selectedValue == 'profile') {
                  onProfileClick(context);
                }
                if (selectedValue == 'logout') {
                  await onLogoutClick(context);
                }
              });
            },
          ),
        SizedBox(width: 10),
      ]),
    );
  }

  void onProfileClick(BuildContext context) {
    Navigator.of(context).popAndPushNamed('/profile');
  }

  Future<void> onLogoutClick(BuildContext context) async {
    Navigator.of(context).popAndPushNamed('/login');
  }
}

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeProvider>().isDark;
    return InkWell(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
          decoration: BoxDecoration(
              color: FlarelineColors.background,
              borderRadius: BorderRadius.circular(45)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: isDark ? Colors.transparent : Colors.white,
                child: SvgPicture.asset('assets/toolbar/sun.svg',
                    width: 18,
                    height: 18,
                    color: isDark
                        ? FlarelineColors.darkTextBody
                        : FlarelineColors.primary),
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: isDark ? Colors.white : Colors.transparent,
                child: SvgPicture.asset('assets/toolbar/moon.svg',
                    width: 18,
                    height: 18,
                    color: isDark
                        ? FlarelineColors.primary
                        : FlarelineColors.darkTextBody),
              ),
            ],
          )),
      onTap: () {
        context.read<ThemeProvider>().toggleThemeMode();
      },
    );
  }
}
