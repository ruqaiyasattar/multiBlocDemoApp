import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiproviderbloctesting/bloc/app_bloc.dart';
import 'package:multiproviderbloctesting/bloc/app_event.dart';
import 'package:multiproviderbloctesting/dialog/delet_account_dialog.dart';
import 'package:multiproviderbloctesting/dialog/logout_dialog.dart';

enum MenuAction { logout, deletAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
        onSelected: (value) async {
          switch(value){
            case MenuAction.logout:
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                context.read<AppBloc>().add(
                  const AppEventLogOut(),
                );
              }
              break;
            case MenuAction.deletAccount:
              final shouldDeleteAccount = await showDeleteAccountDialog(context);
              if (shouldDeleteAccount) {
                context.read<AppBloc>().add(
                  const AppEventDeleteAccount(),
                );
              }
              break;
          }
        },
        itemBuilder: (context){
          return [
            const PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log out',
              ),
            ),
            const PopupMenuItem<MenuAction>(
              value: MenuAction.deletAccount,
              child: Text('Delete Account'),
            ),
      ];
    });
  }
}
