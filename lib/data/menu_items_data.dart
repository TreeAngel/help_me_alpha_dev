import 'package:flutter/material.dart';
import 'package:help_me_client_alpha_ver/models/menu_item_model.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';

class MenuItems {
  static const List<MenuItemModel> firstItems = [
    itemHome,
    itemCategories,
    itemOrderHistory,
    itemProfile,
  ];

  static List<MenuItemModel> secondItems = [
    ApiHelper.token.isNotEmpty ? itemSignOut : itemSignIn,
  ];

  static const itemHome = MenuItemModel(
    id: 1,
    title: 'Home',
    icon: Icons.home_sharp,
  );
  static const itemProfile = MenuItemModel(
    id: 2,
    title: 'Profile',
    icon: Icons.person,
  );
  static const itemSignIn = MenuItemModel(
    id: 3,
    title: 'Sign In',
    icon: Icons.login_sharp,
  );
  static const itemSignOut = MenuItemModel(
    id: 4,
    title: 'Sign Out',
    icon: Icons.logout_sharp,
  );
  static const itemOrderHistory = MenuItemModel(
    id: 5,
    title: 'Order History',
    icon: Icons.history,
  );
  static const itemCategories = MenuItemModel(
    id: 6,
    title: 'Categories',
    icon: Icons.category,
  );
}
