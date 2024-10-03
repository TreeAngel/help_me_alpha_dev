import 'package:flutter/material.dart';

import '../models/menu_item_model.dart';
import '../services/api/api_controller.dart';

class MenuItems {
  static const List<MenuItemModel> firstItems = [
    // itemOrderHistory,
    itemProfile,
  ];

  static List<MenuItemModel> secondItems = [
    ApiController.token != null ? itemSignOut : itemSignIn,
  ];

 
  static const itemProfile = MenuItemModel(
    id: 1,
    title: 'Profile',
    icon: Icons.person,
  );
  static const itemSignIn = MenuItemModel(
    id: 2,
    title: 'Sign In',
    icon: Icons.login_sharp,
  );
  static const itemSignOut = MenuItemModel(
    id: 3,
    title: 'Sign Out',
    icon: Icons.logout_sharp,
  );
  // static const itemOrderHistory = MenuItemModel(
  //   id: 5,
  //   title: 'Order History',
  //   icon: Icons.history,
  // );
}
