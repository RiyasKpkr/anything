import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_api/constants/icons.dart';
import 'package:weather_api/services/wather_services.dart';

class Header extends StatefulWidget {
  Header(
      {super.key,
      required this.backgroundColor,
      required this.city_name,
      required this.discription,
      required this.discriptionIMG,
      required this.state_name,
      required this.temp, });

  String city_name;
  String state_name;
  double temp;
  String discriptionIMG;
  String discription;
  Color backgroundColor;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  WeatherService weatherService = WeatherService();
  IconData textFieldClearIcon = Icons.clear;
  var _textfieldController = TextEditingController();
  bool isLoading = false;
  bool notFound = false;

  loadFunction() async {
    await weatherService.getWeaterData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: MediaQuery.of(context).size.height / 3,
      backgroundColor: widget.backgroundColor,
      title: Padding(
        padding: EdgeInsets.only(top: 25),
        child: Column(
          children: [
            isLoading
                ? Lottie.network(rainyIcon, height: 50)
                : Container(
                    width: 700,
                    height: 50,
                    child: TextField(
                      controller: _textfieldController,
                      onSubmitted: (value) {
                        setState(() {
                          isLoading = true;
                          city = value;
                          Future.delayed(
                            Duration(seconds: 1),
                            () {
                              loadFunction();
                              _textfieldController.clear();
                            },
                          );
                        },);
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            _textfieldController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          icon: Icon(textFieldClearIcon),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        hintText: 'Search for cities',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(133, 255, 255, 255),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(18, 255, 255, 255),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 25,
            ),
            notFound
                ? Text('Not Found')
                : Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              widget.temp.toString() + '°',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              widget.city_name,
                              style: TextStyle(
                                fontSize: 50,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              widget.state_name,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Container(
                          height: 150,
                          width: 120,
                          child: Column(
                            children: [
                              Lottie.network(
                                widget.discriptionIMG.toString(),
                                fit: BoxFit.cover,
                              ),
                              Text(
                                widget.discription,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
