import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tw_assign/modal/image_modal.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    getImage();
  }



  Future<ImageModal> getImage() async {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=43421422-797f971fc089374293a53a208'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return ImageModal.fromJson(data);
    } else {
      throw Exception('Failed to load images');
    }
  }

  int _calculateCrossAxisCount(BuildContext context) {
    // Calculate number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = 150.0; // Adjust according to your preference
    final crossAxisCount = (screenWidth / itemWidth).floor();
    return crossAxisCount > 0 ? crossAxisCount : 1;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<ImageModal>(
            future: getImage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10
                    ),
                    itemCount: snapshot.data!.hits!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                child: Image.network(snapshot.data!.hits![index].webformatURL.toString(),
                                  fit: BoxFit.cover,),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.favorite,color: Colors.red,),
                                      Text(snapshot.data!.hits![index].likes.toString()),
                                    ],
                                  ),
                                  //SizedBox( width: 10,),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye,),
                                      Text(snapshot.data!.hits![index].views.toString()),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                    child: Text(
                      'Loading',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ));
              }
            }),
      ),
    );
  }
}
