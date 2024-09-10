import 'package:flutter/material.dart';
import 'package:help_me_client_alpha_ver/models/menu_item_model.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';

class MenuItems {
  static const List<MenuItemModel> firstItems = [
    itemHome,
    itemProfile,
  ];

  static List<MenuItemModel> secondItems = [
    ApiHelper.token.isNotEmpty ? itemSignOut : itemSignIn,
  ];

  static const itemHome = MenuItemModel(
    id: 1,
    title: 'home',
    icon: Icons.home_sharp,
  );
  static const itemProfile = MenuItemModel(
    id: 2,
    title: 'profile',
    icon: Icons.person,
  );
  static const itemSignIn = MenuItemModel(
    id: 3,
    title: 'sign in',
    icon: Icons.login_sharp,
  );
  static const itemSignOut = MenuItemModel(
    id: 4,
    title: 'sign out',
    icon: Icons.logout_sharp,
  );
}
