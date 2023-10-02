import 'dart:convert';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import 'package:http/http.dart' as http;
import '../../models/Employee_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/AssignCardMain.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/categories.dart';

class Assign extends StatefulWidget {
  final int id;
  EmployeeModel? employee;
  Assign({super.key, required this.id, this.employee});

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  final AuthController authController = AuthController();

  ScrollController _scrollController = ScrollController();
  String selectedCategory = '';
  Map<String, dynamic> devicesFuture = {};

  Future<Map<String, dynamic>> fetchItemsFromApi() async {
    final token = await authController.getToken();
    var url = Uri.parse('$baseUrl/inv/viewassign');
    final response = await http.post(
      url,
      body: jsonEncode({"empid": widget.id}),
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      final List<dynamic> items = data['devices'].toList();
      final Map<String, dynamic> categorizedItems = {};
      print("data: $data");
      print(categorizedItems.containsKey('watch'));
      for (var item in items) {
        print(item['ItemType']);
        if (categorizedItems.containsKey(item['ItemType'])) {
          categorizedItems[item['ItemType']]!.add(item);
        } else {
          categorizedItems[item['ItemType']] = [item];
        }
      }
      devicesFuture = categorizedItems;
      return devicesFuture;
    } else {
      throw Exception('Failed to load items');
    }
  }

  void deleteDevice(int deviceId) async {
    final token = await authController.getToken();
    print(deviceId);
    var url = Uri.https(baseUrl, '/inv/deleteitem');
    final response = await http.post(
      url,
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
      body: jsonEncode({'deviceid': deviceId}),
    );

    if (response.statusCode == 200) {
      // Device deleted successfully
      print('Device deleted successfully');
      setState(() {});
      // Refresh the inventory or update the UI as needed
    } else {
      print('Failed to delete device. Status code: ${response.statusCode}');
      // Handle the error or show a message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = 'phone'; // Set default selected category to Phone
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: fetchItemsFromApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Placeholder for loading state
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, dynamic> categorizedDevices = snapshot.data!;
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 11.0),
                          child: Appbar(),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 23.0, bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Assign to ${widget.employee!.firstName ?? " "} ",
                                  style: TextStyle(
                                      color: Color(0xffE96E2B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/AssigningPage");
                                },
                                child: CircleAvatar(
                                  radius: 12.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Color(0xffE96E2B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: categorizedDevices.keys.map((category) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Categories(
                                  title: category,
                                  svgpath: "assets/svgs/Mobile.svg",
                                  onpress: () {
                                    setState(() {
                                      selectedCategory =
                                          category; // Update the selected category
                                    });
                                  },
                                  selectedCategory:
                                      selectedCategory, // Pass selected category
                                ).buildCategories(),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: categorizedDevices[selectedCategory]
                                      ?.length ??
                                  0,
                              itemBuilder: (BuildContext context, int index) {
                                final device = categorizedDevices[
                                    selectedCategory]![index];
                                print("DEvice: $device");
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: AssignCardMain(
                                      model: device['Name'],
                                      quantity: device['quantity'].toString()),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
      bottomNavigationBar: bottomAppBar(index: 1),
    );
  }
}
