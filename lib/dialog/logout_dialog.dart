import 'package:flutter/material.dart' show BuildContext;
import 'package:multiproviderbloctesting/dialog/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context){
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionBuilder: () =>{
      'Cancle' : false,
      'Log out' :true,
    },
  ).then((value) => value ?? false,
  );
}