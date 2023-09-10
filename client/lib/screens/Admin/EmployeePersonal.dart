  import 'package:flutter/cupertino.dart';
  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:mobelease/screens/Admin/EditEmployee.dart';
  import '../../controllers/auth_controller.dart';
  import '../../globals.dart';
  import '../../models/Employee_Model.dart';
  import '../../widgets/Appbar.dart';
  import '../../widgets/BottomAppBar.dart';
  import '../../widgets/TextFieldWidget.dart';
  import 'package:flutter/src/rendering/box.dart';
  import 'package:http/http.dart' as http;

  import 'Assign.dart';

  class EmployeePersonal extends StatefulWidget {
    final int id;

    const EmployeePersonal({super.key, required this.id});

    @override
    State<EmployeePersonal> createState() => _EmployeePersonalState();
  }

  class _EmployeePersonalState extends State<EmployeePersonal> {
    late EmployeeModel employee = EmployeeModel();
    final AuthController authController = AuthController();
    Future<EmployeeModel> getEmployee() async {
      print(widget.id);
      int ids = widget.id;
      final token = await authController.getToken();
      var url = Uri.https(baseUrl, '/emp/singleemployee');
      final client = http.Client();
      try {
        final response = await client.post(
          url,
          body: jsonEncode({"empid": widget.id}),
          headers: {'Cookie': token!, 'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          // print(response.body);
          final Map<String, dynamic> responseData = jsonDecode(response.body)!['data'!];
          final List<String> sortedKeys1 = responseData.keys!.toList();
          List<int> sortedKeys =  sortedKeys1.map((str) => int.parse(str!)).toList() ..sort();
          // print(sortedKeys);
          final List<EmployeeModel> employees = sortedKeys
              .map((key) => EmployeeModel.fromJson(responseData[key.toString()]))
              .toList();
          employee = employees.first;
          print(employee.firstName);
          // setState(() {
          //   employee = employees.first;
          // });
          return employee;
        } else {
          throw Exception('Failed to load employees');
        }

        // return employees;
      } catch (e) {
        return Future.error(e.toString());
      }
    }
  // @override
  //   void initState() {
  //     // TODO: implement initState
  //     super.initState();
  //     getEmployee();
  //   }

    @override
    Widget build(BuildContext context) {
      String name = employee.firstName ?? "name not available";
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: FutureBuilder(
            future: getEmployee(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Placeholder for loading state
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                else{
                  EmployeeModel employee = snapshot.data!;
                  return Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 11.0, left: 11.0, right: 11.0),
                        child: Appbar(),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 49.5,
                              backgroundImage: AssetImage('assets/images/image1.jpg'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          employee.firstName ?? " ",
                                          style: TextStyle(
                                              color: Color(0xffE96E2B),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: Color(0xffE96E2B),
                                              size: 12,
                                            ),
                                            Text(
                                              employee.phoneNo ?? " ",
                                              style: TextStyle(
                                                  color: Color(0xffE96E2B),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            "Assign Inventory",
                                            style: TextStyle(
                                                color: Color(0xffE96E2B),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Icon(
                                            Icons.arrow_right_alt,
                                            color: Color(0xffE96E2B),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.08,
                            ),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 25.0,
                                      color: Color(0xffE96E2B),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 17.0, vertical: 8),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 17),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Details",
                                            style: TextStyle(
                                                color: Color(0xffE96E2B),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(6))),
                                          // child: GestureDetector(
                                          //   onTap:(){
                                          //     Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //         builder: (context) => EditEmployee(id:employee.id??4),
                                          //       ),
                                          //     );
                                          //   },
                                          //   child: Text(
                                          //     "Edit",
                                          //     style: TextStyle(
                                          //         color: Color(0xffE96E2B),
                                          //         fontSize: 12,
                                          //         fontWeight: FontWeight.w400),
                                          //
                                          //   ),
                                          // ),
                                          child: GestureDetector(
                                            onTap:(){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EditEmployee(id:widget.id??1),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: Color(0xffE96E2B),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),

                                            ),
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("First Name"),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              height: 55,
                                              width:
                                              MediaQuery.of(context).size.width * 0.43,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),
                                                  border: Border.all(color: Color(0xffE96E2B),)
                                              ),
                                              child:Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(employee.firstName?? " "),
                                              ))
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Last Name"),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              height: 55,
                                              width:
                                              MediaQuery.of(context).size.width * 0.43,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),
                                                  border: Border.all(color: Color(0xffE96E2B),)
                                              ),
                                              child:Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(employee.lastName?? " "),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Phone Number"),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),
                                              border: Border.all(color: Color(0xffE96E2B),)
                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(employee.phoneNo?? " "),
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Username or email address"),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),
                                              border: Border.all(color: Color(0xffE96E2B),)
                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(employee.email?? " "),
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Password (more than 8 letters)"),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),
                                              border: Border.all(color: Color(0xffE96E2B),)
                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Password"),
                                          ))
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                    ],
                  );
                }

              },
          )
        ),
        bottomNavigationBar: bottomAppBar(),
      );
    }
  }
