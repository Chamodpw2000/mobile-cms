import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilecms/pages/screens/Addcontact.dart';
import 'package:mobilecms/pages/screens/Profile.dart';
import 'package:mobilecms/pages/screens/Search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Dashboard(), // Your Dashboard widget
    );
  }
}

TextEditingController fnamec = TextEditingController();
TextEditingController lnamec = TextEditingController();
bool userDetails = false;
bool loading = true; // Loading state

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> fetchUserDetails() async {
    if (user != null) {
      try {
        // Fetch user document from Firestore where the document ID matches the user's UID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email)
            .get();

        setState(() {
          userDetails = querySnapshot.docs.isNotEmpty;
          loading = false; // Stop loading indicator
        });
      } catch (e) {
        setState(() {
          loading = false; // Stop loading indicator in case of an error
        });
        print('Error fetching user details: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  int currentIndex = 1;
  final screens = [
    const AddContact(),
    const Search(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : userDetails
              ? screens[currentIndex]
              : Center(
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: fnamec,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: "First Name",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: lnamec,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: "Last Name",
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await addDetails();
                              } catch (e) {
                                print('Error saving details: $e');
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
                                          child: Text("Save Data",
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
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
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
                                      child: Text("Logout",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
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
      bottomNavigationBar: userDetails
          ? BottomNavigationBar(
              onTap: (value) => setState(() {
                currentIndex = value; // Update the selected screen
              }),
              iconSize: 30,
              selectedFontSize: 20,
              currentIndex: currentIndex,
              backgroundColor: Colors.grey.withOpacity(0.3),
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: "Add Contact",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search ",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            )
          : null,
    );
  }

  Future<void> addDetails() async {
    await FirebaseFirestore.instance.collection("users").add({
      "email": user!.email,
      "fname": fnamec.text,
      "lname": lnamec.text,
    }).then((value) {
      fnamec.clear();
      lnamec.clear();
      setState(() {
        userDetails = true;
      });
    });
  }
}
