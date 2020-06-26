import 'package:flutter/material.dart';
import 'package:include/models/event.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EventTab extends StatelessWidget {
  EventTab({this.eventData, this.delete, this.index});

  final Newevent eventData;
  final Function delete;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(
              height: 170.0,
            ),
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Center(
                      child: SpinKitThreeBounce(
                    color: Colors.black,
                    size: 20,
                  )),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: eventData.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/eventModal', arguments: {
                  'eventData': this.eventData,
                  'delete': this.delete,
                  'index': this.index,
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
