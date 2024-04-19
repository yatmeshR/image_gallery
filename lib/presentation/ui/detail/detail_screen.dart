import 'package:flutter/material.dart';
import 'package:tw_assign/modal/image_modal.dart';

class DetailScreen extends StatefulWidget {
  final String imageUrl;

  const DetailScreen({super.key,required this.imageUrl});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
          Column(
            children: [
              Row(
                children: [
                  Container(
                   child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        )),
                  )
                ],
              ),
      Center(
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.contain,
        ),
      )])
      )
    );
  }
}
