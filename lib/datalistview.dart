import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Datalistview extends StatefulWidget {
  const Datalistview({super.key});

  @override
  State<Datalistview> createState() => _DatalistviewState();
}

class _DatalistviewState extends State<Datalistview> {
  final databasereference = FirebaseDatabase.instanceFor(
    databaseURL: "https://appfirebase2-96e60-default-rtdb.firebaseio.com/",
    app: Firebase.app(),
  ).ref();

  List<Map<dynamic, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    databasereference.child('items').onChildAdded.listen((event) {
      final value = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        items.add({
          'key': event.snapshot.key,
          'name': value['name'],
          'email': value['email'],
        });
      });
    });

    databasereference.child('items').onChildChanged.listen((event) {
      final value = Map<String, dynamic>.from(event.snapshot.value as Map);
      final index = items.indexWhere(
        (item) => item['key'] == event.snapshot.key,
      );
      if (index != -1) {
        setState(() {
          items[index]['name'] = value['name'];
          items[index]['email'] = value['email'];
        });
      }
    });

    databasereference.child('items').onChildRemoved.listen((event) {
      setState(() {
        items.removeWhere((item) => item['key'] == event.snapshot.key);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ListTile(
            title: Text(item['name']),
            subtitle: Text(item['email']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final nameController = TextEditingController(
                          text: item['name'],
                        );
                        final emailController = TextEditingController(
                          text: item['email'],
                        );

                        return AlertDialog(
                          title: const Text('Edit Item'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                ),
                              ),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final newName = nameController.text;
                                final newEmail = emailController.text;

                                if (newName.isNotEmpty && newEmail.isNotEmpty) {
                                  databasereference
                                      .child('items/${item['key']}')
                                      .update({
                                        'name': newName,
                                        'email': newEmail,
                                      });
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),

                IconButton(
                  onPressed: () {
                    databasereference.child('items/${item['key']}').remove();
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
