import 'package:flutter/material.dart';
import 'package:rsms/screens/search-screen.dart';
import 'package:rsms/widgets/app_drawer.dart';
import 'package:rsms/widgets/slider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const routeName = 'welcome';
  static List previousSearchs = [];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 246),
        drawer: AppDrawer(),
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: deviceSize.height * .3,
                  width: deviceSize.width,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.menu),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  }),
                              const Text(
                                "RERM",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(SearchScreen.routeName);
                                },
                                icon: Icon(Icons.search_outlined),
                                color: Colors.white,
                              )
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SearchScreen.routeName);
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Search Properties...",
                            contentPadding: const EdgeInsets.all(20),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.blue,
                  child: Container(
                    height: deviceSize.height * .7,
                    width: deviceSize.width,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 246, 246, 246),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Container(
                        width: deviceSize.width * .9,
                        height: 350,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(3, 2),
                              blurRadius: 8,
                              color: Color.fromARGB(255, 228, 228, 228),
                            )
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Browse Properties",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 110,
                                margin: const EdgeInsets.only(left: 5),
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.blue, width: 2))),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.home_outlined,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "Homes",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 2,
                              ),
                              Container(
                                height: 220,
                                width: 400,
                                child: SliderImage(0, [
                                  'assets/House1.jpg',
                                  'assets/House1.jpg',
                                  'assets/House1.jpg'
                                ]),
                              )
                            ]),
                      )
                    ]),
                  ),
                )
              ],
            ),
          );
        }));
  }
}
