import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Editcontact extends StatefulWidget {
  final Map<String, dynamic> contact; // Define contact as a parameter

  const Editcontact({super.key, required this.contact});

  @override
  State<Editcontact> createState() => _EditcontactState();
}

class _EditcontactState extends State<Editcontact> {
  late TextEditingController namecontroller;
  late TextEditingController numbercontroller;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the contact data passed from the previous screen
    namecontroller = TextEditingController(text: widget.contact['name']);
    numbercontroller = TextEditingController(text: widget.contact['number']);
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is destroyed
    namecontroller.dispose();
    numbercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
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
            padding: const EdgeInsets.all(12.0),
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
                      hintText: "Email",
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
                      hintText: "Number",
                      fillColor: Colors.white, // Background color
                      filled: true, // Enable the background color
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    String name = namecontroller.text.trim();
                    String number = numbercontroller.text.trim();
                    User? user = FirebaseAuth.instance.currentUser;
                    String uid = user!.uid;

                    if (name.isNotEmpty && number.isNotEmpty) {
                      // Update the contact in Firestore using the document ID from the contact
                      FirebaseFirestore.instance
                          .collection('contacts')
                          .doc(widget.contact['id'])
                          .update({
                        'name': name,
                        'number': number,
                        'addedBy': uid,
                      }).then((value) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.scale,
                          title: 'Success',
                          desc: 'Contact Updated Successfully',
                          btnOkOnPress: () {
                            Navigator.pop(
                                context, true); // Go back and indicate success
                          },
                        ).show();
                      });
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.topSlide,
                        title: 'Error',
                        desc: 'Please fill all the fields',
                        btnOkOnPress: () {
                          // Handle empty field error
                        },
                        customHeader: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 80,
                        ),
                      ).show();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Center(
                                child: Text("Update Contact",
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Center(
                                child: Text("Cancle",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
