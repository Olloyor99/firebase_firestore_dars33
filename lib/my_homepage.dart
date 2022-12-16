import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase33/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseFirestore firebaseFirestore;
  late List<User> users;
  late bool isLoading;
  @override
  void initState() {
    firebaseFirestore = FirebaseFirestore.instance;
    isLoading = true;
    users = [];
    getData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: FloatingActionButton(onPressed: getData),
      appBar: AppBar(
        title: const Text("Cloud Firestore"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: isLoading ? null : addDataToCloud,
              child: isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : const Text("ok")),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: ((context, index) {
                final user = users[index];
                return ListTile(
                    leading: Text(user.id.toString()),
                    title: Text(user.name.toString()),
                    subtitle: Text(user.email.toString()),
                    trailing: IconButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              deletFromCloud(user.documentId);
                            },
                      icon: const Icon(Icons.remove),
                    ));
              }),
            ),
          ),
        ],
      ),
    );
  }

  addDataToCloud() async {
    isLoading = true;
    setState(() {});
    Map<String, dynamic> map = {};
    map['id'] = 1;
    map['name'] = 'John';
    map['email'] = 'john@gmail.com';
    map['isloged'] = false;
    await firebaseFirestore.collection('users').add(map);
    getData();
  }

  getData() async {
    isLoading = true;
    setState(() {});
    final body = await firebaseFirestore.collection('users').get();
    users = body.docs.map((e) => User.fromQuerySnapshot(e)).toList();
    isLoading = false;
    setState(() {});
  }

  deletFromCloud(String id) async {
    isLoading = true;
    setState(() {});
    await firebaseFirestore.collection('users').doc(id).delete();
    getData();
  }
}
