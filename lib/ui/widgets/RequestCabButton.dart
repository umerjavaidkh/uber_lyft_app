


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


typedef TapListener = void Function();



class RequestButton extends StatelessWidget{

  TapListener _onTap;

  String _buttonText="";

  RequestButton(String buttonText,{TapListener onTap}){
    this._onTap=onTap;
    _buttonText=buttonText;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x40000000),
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 53,
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffffff).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.black),
        child: InkWell(
          onTap: () {
            _onTap();
          },
          child: Text(
            _buttonText.toUpperCase(),
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }


}