import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tw_assign/modal/image_modal.dart';
import 'package:tw_assign/presentation/ui/detail/detail_screen.dart';

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

  // int _calculateCrossAxisCount(BuildContext context) {
  //   // Calculate number of columns based on screen width
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final itemWidth = 150.0; // Adjust according to your preference
  //   final crossAxisCount = (screenWidth / itemWidth).floor();
  //   return crossAxisCount > 0 ? crossAxisCount : 1;
  // }

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
                        crossAxisSpacing: 10),
                    itemCount: snapshot.data!.hits!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 140,
                            width: 200,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Hero(
                                    tag:
                                        "imagepath-${snapshot.data!.hits![index].webformatURL.toString()}",
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    DetailScreen(
                                                      imageUrl: snapshot
                                                          .data!
                                                          .hits![index]
                                                          .webformatURL
                                                          .toString(),
                                                    )));
                                      },
                                      child: Image.network(
                                        snapshot.data!.hits![index].webformatURL
                                            .toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                          Text(snapshot.data!.hits![index].likes
                                              .toString()),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye,
                                          ),
                                          Text(snapshot.data!.hits![index].views
                                              .toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
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
