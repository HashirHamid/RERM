import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/widgets/slider.dart';

class PostAd extends StatefulWidget {
  static const routeName = 'post-ad';

  @override
  State<PostAd> createState() => _PostAdState();
}

class _PostAdState extends State<PostAd> {
  File? _image;
  List _imageList = [];
  var _isInit = true;
  ad _editedad = ad(
      owned: false,
      title: '',
      price: 0.0,
      image: [],
      location: '',
      contact: '',
      description: '',
      state: null,
      city: null,
      type: null);

  Future getImage(bool isCamera) async {
    XFile? image;
    if (isCamera) {
      image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (image!.path.isNotEmpty) {
      _imageList.add(image);
    }
    File file = File(image.path);
    setState(() {
      _image = file;
    });
  }

  final _form = GlobalKey<FormState>();
  // FocusNode _descriptionFocusNode;
  var _isLoading = false;
  var _initValues = {
    'image': [],
    'title': '',
    'location': '',
    'price': '',
    "contact": '',
    'description': '',
    'state': null,
    'city': null,
    'type': null
  };
  List image12 = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final adId = ModalRoute.of(context)!.settings.arguments as String?;
      if (adId != null) {
        _editedad = Provider.of<ad>(context).findById(adId);
        _initValues = {
          'title': _editedad.title.toString(),
          'contact': _editedad.contact.toString(),
          'description': _editedad.description.toString(),
          'image': _editedad.image,
          'location': _editedad.location.toString(),
          'price': _editedad.price.toString(),
          'state': _editedad.state,
          'city': _editedad.city,
          'type': _editedad.type
        };

        _myCity = _initValues['city'];
        _myState = _initValues['state'];
        _myType = _initValues['type'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void addData() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    image12 = _initValues['image'] as List;
    _form.currentState!.save();
    if (_image != null) {
      for (var image in _imageList) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("userImage")
            .child(DateTime.now().toString() + ".jpg");
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        image12.add(url);
      }
    }
    print(image12);

    _editedad = ad(
        owned: false,
        id: _editedad.id,
        title: _editedad.title,
        location: _editedad.location,
        price: _editedad.price,
        image: image12,
        contact: _editedad.contact,
        description: _editedad.description,
        state: _editedad.state,
        city: _editedad.city,
        type: _editedad.type);
    // print(url);
    setState(() {
      _isLoading = true;
    });
    if (_editedad.id != null) {
      await Provider.of<ad>(
        context,
        listen: false,
      ).updateAd(_editedad.id.toString(), _editedad);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ad>(
          context,
          listen: false,
        ).addad(_editedad);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  var _myState;
  var _myCity;
  var _myType;

  var types = {
    'type': ["Rent"]
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post an ad'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  addData();
                },
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 400,
                    height: 200,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: (_image == null && _initValues['image'] == [])
                        ? const Center(child: Text("Select an image!"))
                        : SliderImage(1, _imageList),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            getImage(true);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          child: const Text('Camera'),
                        ),
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            getImage(false);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          child: const Text('Gallery'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextFormField(
                initialValue: _initValues['title'].toString(),
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onSaved: (v) {
                  _editedad = ad(
                      id: _editedad.id,
                      title: v.toString(),
                      owned: false,
                      price: _editedad.price,
                      location: _editedad.location,
                      image: _editedad.image,
                      contact: _editedad.contact,
                      description: _editedad.description,
                      state: _editedad.state,
                      city: _editedad.city,
                      type: _editedad.type);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please provide a value.";
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'].toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (v) {
                  _editedad = ad(
                      id: _editedad.id,
                      owned: false,
                      title: _editedad.title,
                      price: double.parse(v!),
                      location: _editedad.location,
                      image: _editedad.image,
                      contact: _editedad.contact,
                      description: _editedad.description,
                      state: _editedad.state,
                      city: _editedad.city,
                      type: _editedad.type);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please provide a value.";
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'].toString(),
                decoration: const InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                // focusNode: _descriptionFocusNode,
                onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (v) {
                  _editedad = ad(
                      id: _editedad.id,
                      title: _editedad.title,
                      owned: false,
                      price: _editedad.price,
                      location: _editedad.location,
                      image: _editedad.image,
                      contact: _editedad.contact,
                      description: v.toString(),
                      state: _editedad.state,
                      city: _editedad.city,
                      type: _editedad.type);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please provide a value.";
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                              value: _myState,
                              iconSize: 30,
                              icon: (null),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: const Text('Select City'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _myState = newValue;
                                  if (_myCity != null) {
                                    _myCity = null;
                                  }
                                });
                                _editedad = ad(
                                    id: _editedad.id,
                                    owned: false,
                                    title: _editedad.title,
                                    price: _editedad.price,
                                    location: _editedad.location,
                                    image: _editedad.image,
                                    contact: _editedad.contact,
                                    description: _editedad.description,
                                    state: newValue,
                                    city: _editedad.city,
                                    type: _editedad.type);
                              },
                              items: states.map((item) {
                                return DropdownMenuItem(
                                  value: item['name'],
                                  child: Text(item['name']!),
                                );
                              }).toList()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: _myCity,
                            iconSize: 30,
                            icon: (null),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: const Text('Select Area'),
                            onChanged: (String? newValue) {
                              setState(() {
                                _myCity = newValue;
                              });
                              _editedad = ad(
                                  id: _editedad.id,
                                  title: _editedad.title,
                                  price: _editedad.price,
                                  location: _editedad.location,
                                  image: _editedad.image,
                                  contact: _editedad.contact,
                                  owned: false,
                                  description: _editedad.description,
                                  state: _editedad.state,
                                  city: newValue,
                                  type: _editedad.type);
                            },
                            items: _myState == null
                                ? null
                                : myStatesData[_myState]!.map((item) {
                                    debugPrint(item);
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: _myType,
                              iconSize: 30,
                              icon: (null),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: const Text('Select Type'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _myType = newValue;
                                });
                                _editedad = ad(
                                    id: _editedad.id,
                                    title: _editedad.title,
                                    owned: false,
                                    price: _editedad.price,
                                    location: _editedad.location,
                                    image: _editedad.image,
                                    contact: _editedad.contact,
                                    description: _editedad.description,
                                    state: _editedad.state,
                                    city: _editedad.city,
                                    type: newValue);
                              },
                              items: types['type']!
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
