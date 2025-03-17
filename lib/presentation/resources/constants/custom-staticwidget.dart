import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../colors-manager.dart';



Future NavAndRemove ({screen , ctx}) {
  return  Navigator.pushAndRemoveUntil(ctx, MaterialPageRoute(builder:  (ctx) => screen,), (route) => false);
}
Future NormalNav ({screen,ctx}) {
  return  Navigator.push(ctx, MaterialPageRoute(builder:(ctx) => screen,));
}
void lastNav ({ctx}) {
  return  Navigator.pop(ctx);
}
enum StatusCase {SUCCES , ERROR , EARNING}

void toast ({
  required String msg ,
  required StatusCase state ,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: changeColor(state),
      textColor: Colors.white,
      fontSize: 16.0) ;
}

Color changeColor (StatusCase st) {
  Color? c ;
  switch (st) {
    case StatusCase.SUCCES :
      c =  Colors.green ;
      break ;
    case StatusCase.ERROR :
      c =  Colors.red ;
      break ;
    case StatusCase.EARNING :
      c =  Colors.amber ;
      break ;
  }
  return c ;
}
final divider = Divider(color:Colors.white.withOpacity(0.3), height:1);
final dividerList = Divider(color:ColorsManager.greyColor, height: 1);

loading (double size) {
  return LoadingAnimationWidget.hexagonDots(
    size: size,
    color: Colors.grey.withOpacity(0.3),
  );
}


Widget rowDiv (double width) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        color: Colors.grey.shade300,
        height: 1,width: width,
      ),
      SizedBox(width: 8,),
      Text(
        'or',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
          decoration: TextDecoration.none,
        ),
      ),
      SizedBox(width: 8,),
      Container(
        color: Colors.grey.shade300,
        height: 1,width: width,
      ),
    ],
  );

}

Widget search (double radius) {
  return Container(
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.only(left: 20, right: 20),
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.grey.shade300,
    ),
    child: Row(
      children: [
        Icon(Icons.search, color: Colors.grey, size: 25,),
        SizedBox(width: 20,),
        Center(
          child: Text('Search', style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
          ),),
        ),
      ],
    ),
  );
}