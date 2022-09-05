import 'package:flutter/material.dart' show BuildContext;
import 'package:multiproviderbloctesting/dialog/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context){
  return showGenericDialog<bool>(
      context: context,
      title: 'Delete account',
      content: 'Are you sure you want to delete your account? You cannot undo this operation!',
      optionBuilder: () =>{
        'Cancle' : false,
        'Delete account' :true,
      },
  ).then((value) => value ?? false,
  );
}