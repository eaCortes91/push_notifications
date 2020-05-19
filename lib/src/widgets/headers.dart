import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HeaderDiagonal extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Container(
      height: double.infinity,
      width: double.infinity,
      //color: Color(0xffcc6785),
      child: CustomPaint(
        painter: HeaderCurvoPainter(),
      ),
    );
  }
}

class HeaderCurvoPainter extends CustomPainter{
 
  @override
  void paint(Canvas canvas, Size size){

    final lapiz = Paint();

    //Propiedades de mi lapiz
    lapiz.color = Color(0xff615AAB);
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 5;

    final path = new Path();

    //Dibujo en el path y con el lapiz
    path.moveTo(0, size.height * 0.35);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.35);

    canvas.drawPath(path, lapiz);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}