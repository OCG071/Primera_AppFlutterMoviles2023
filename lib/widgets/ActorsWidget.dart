import 'package:app1f/models/castmodel.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ActorsWidget extends StatelessWidget {
  ActorsWidget({super.key, required this.castModel});

  CastModel castModel;
  String foto =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS6TPbk510-E4DRjAw_k4G9UempXsAPLoHEQ&usqp=CAU';

  @override
  Widget build(BuildContext context) {
    if (castModel.profile != '' && castModel.profile != null) {
      foto = 'https://image.tmdb.org/t/p/w500/${castModel.profile}';
    }
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0)),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(foto),
                  radius: 50,
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      'Name: ' + castModel.name!,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Character: ' + castModel.character!,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
