import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../services/api/api_controller.dart';

class MenuItems {
  static const List<MenuItemModel> firstItems = [
    itemHome,
    itemOrderHistory,
    itemProfile,
  ];

  static List<MenuItemModel> secondItems = [
    ApiController.token != null ? itemSignOut : itemSignIn,
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
}
