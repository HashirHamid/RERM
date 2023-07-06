import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/screens/welcome-screen.dart';

import '../providers/products_provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search-screen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  var _myState;
  var _myCity;

  var myStatesData = {
    "Islamabad": [
      "F7",
      "F8",
      "F9",
      "I8",
      "Gulberg Greens",
      "Soan Gardens",
    ],
    "Rawalpindi": [
      "Raja bazaar",
      "Saddar",
      "Rawat",
      "Marir Hassan",
    ],
    "Lahore": [],
    "Multan": [],
    "Peshawar": [],
    "Karachi": []
  };

  var states = [
    {
      "name": "Islamabad",
    },
    {
      "name": "Rawalpindi",
    },
    {
      "name": "Lahore",
    },
    {
      "name": "Peshawar",
    },
    {
      "name": "Karachi",
    },
    {
      "name": "Multan",
    },
  ];
  Future? openDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          title: const Text("Filter"),
          children: [
            SimpleDialogOption(
                child: Center(
              child: Column(
                children: [
                  DropdownButton<String>(
                      hint: const Text("Select City"),
                      value: _myState,
                      items: states.map((item) {
                        return DropdownMenuItem(
                          value: item['name'],
                          child: Text(item['name']!),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _myState = newVal;
                          if (_myCity != null) {
                            _myCity = null;
                          }
                        });
                      }),
                  DropdownButton<String>(
                      hint: const Text("Select Area"),
                      value: _myCity,
                      items: _myState == null
                          ? null
                          : myStatesData[_myState]!.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _myCity = newVal;
                        });
                      }),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _myCity = null;
                        _myState = null;
                      });
                    },
                    child: Text("Reset"),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color.fromRGBO(241, 245, 254, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.cancel_sharp),
                                  onPressed: () {
                                    searchController.clear();
                                  },
                                ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onEditingComplete: () {
                          if (!searchController.text.isEmpty) {
                            WelcomeScreen.previousSearchs
                                .add(searchController.text);
                            _myState != null && _myCity != null
                                ? Navigator.of(context).pushReplacementNamed(
                                    'list-screen',
                                    arguments: {
                                        'search': searchController.text,
                                        'state': _myState.toString(),
                                        'city': _myCity.toString()
                                      })
                                : _myState != null
                                    ? Navigator.of(context)
                                        .pushReplacementNamed('list-screen',
                                            arguments: {
                                            'search': searchController.text,
                                            'state': _myState.toString(),
                                            'city': ''
                                          })
                                    : Navigator.of(context)
                                        .pushReplacementNamed('list-screen',
                                            arguments: {
                                            'search': searchController.text,
                                            'state': '',
                                            'city': ''
                                          });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        openDialog();
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.grey,
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: WelcomeScreen.previousSearchs.length,
                    itemBuilder: (context, index) =>
                        previousSearchedItems(index)),
              ),
              const SizedBox(
                height: 8,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  previousSearchedItems(int index) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Dismissible(
          key: GlobalKey(),
          onDismissed: (DismissDirection dir) {
            setState(() {});
            WelcomeScreen.previousSearchs.removeAt(index);
          },
          child: Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                WelcomeScreen.previousSearchs[index].toString(),
                style: const TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              const Icon(
                Icons.call_made_outlined,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  searchSuggestions(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 222, 222, 222),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color.fromARGB(255, 98, 98, 98)),
      ),
    );
  }
}
