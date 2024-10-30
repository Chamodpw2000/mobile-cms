import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

TextEditingController namecontroller = TextEditingController();
TextEditingController numbercontroller = TextEditingController();

class _AddContactState extends State<AddContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/b.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment(-0.21, 0),
            opacity: 0.7,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),

                    hintStyle: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7), // Label color
                      fontSize: 20.0, // Label font size
                      fontWeight: FontWeight.bold, // Label font weight
                    ),
                    hintText: "Name of the Contact",
                    fillColor: Colors.white, // Background color
                    filled: true, // Enable the background color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: numbercontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),

                    hintStyle: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7), // Label color
                      fontSize: 20.0, // Label font size
                      fontWeight: FontWeight.bold, // Label font weight
                    ),
                    hintText: "Contact Number",
                    fillColor: Colors.white, // Background color
                    filled: true, // Enable the background color
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  print("Pressed");
                  try {
                    String name = namecontroller.text.trim();
                    String number = numbercontroller.text.trim();
                    User? user = FirebaseAuth.instance.currentUser;
                    String uid = user!.uid;
                    if (name.isNotEmpty && number.isNotEmpty) {
                      FirebaseFirestore.instance.collection('contacts').add({
                        'name': name,
                        'number': number,
                        'addedBy': uid,
                      }).then((value) {
                        namecontroller.clear();
                        numbercontroller.clear();
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.scale,
                            title: 'Success',
                            desc: 'Contact Added Successfully',
                            btnOkOnPress: () {
                              namecontroller.clear();
                              numbercontroller.clear();
                            }).show();
                      });
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.topSlide,
                        title: 'Error',
                        desc: 'Please fill all the fields',
                        btnOkOnPress: () {
                          namecontroller.clear();
                          numbercontroller.clear();
                        },
                        customHeader: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 80,
                        ),
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Center(
                              child: Text("Add Contact",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  )))),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
