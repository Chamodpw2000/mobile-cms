
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilecms/pages/EditContact.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Map<String, dynamic>> contacts = []; // Array to store contacts
  List<Map<String, dynamic>> filteredContacts =
      []; // Array for filtered contacts
  TextEditingController searchController =
      TextEditingController(); // Controller for search input
  bool isLoading = true; // Variable to indicate if data is still loading

  @override
  void initState() {
    super.initState();
    fetchContacts(); // Fetch contacts when the page loads
  }

  Future<void> fetchContacts() async {
    setState(() {
      isLoading = true; // Set loading to true when fetching starts
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        FirebaseFirestore.instance
            .collection('contacts')
            .where('addedBy', isEqualTo: uid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          setState(() {
            contacts.clear(); // Clear the list before adding new contacts
            for (var doc in querySnapshot.docs) {
              contacts.add({
                'id': doc.id,
                'name': doc['name'],
                'number': doc['number'],
              });
            }
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterContacts(String query) {
    List<Map<String, dynamic>> filtered = contacts.where((contact) {
      return contact['name'].toLowerCase().contains(query.toLowerCase()) ||
          contact['number'].contains(query);
    }).toList();

    setState(() {
      filteredContacts = filtered;
    });
  }

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
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) // Show loading indicator while loading
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                filterContacts(value);
                              },
                              decoration: InputDecoration(
                                labelText: 'Search Contacts',
                                labelStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .black), // Border color set to black
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .black), // Black border when enabled
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.black,
                                      width:
                                          2), // Thicker black border on focus
                                ),
                              ),
                            ),
                          )),
                      if (searchController.text.isNotEmpty)
                        Expanded(
                          child: filteredContacts.isEmpty
                              ? const Center(
                                  child: Text("No Matching Contacts"),
                                )
                              : buildContactList(filteredContacts),
                        )
                      else
                        Expanded(
                          child: contacts.isEmpty
                              ? const Center(
                                  child: Text("No Contacts Yet"),
                                )
                              : buildContactList(contacts),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContactList(List<Map<String, dynamic>> contactList) {
    return ListView.builder(
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        final contact = contactList[index];
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact['name'],
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  )),
              Text(contact['number'],
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            child: Text(contact['name'][0],
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
          ),
          trailing: SizedBox(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: const Icon(Icons.edit),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Editcontact(contact: contact),
                      ),
                    );
                    if (result == true) {
                      fetchContacts();
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.scale,
                      title: 'Delete Contact',
                      desc: 'Are you sure you want to delete this contact?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        FirebaseFirestore.instance
                            .collection('contacts')
                            .doc(contact['id'])
                            .delete()
                            .then((value) {
                          fetchContacts();
                        });
                      },
                    ).show();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
