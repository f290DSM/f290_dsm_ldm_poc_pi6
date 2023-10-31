import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late FirebaseFirestore _firestore;

  final Stream<QuerySnapshot> _artefactStream =
      FirebaseFirestore.instance.collection('artefacts').snapshots();

  @override
  void initState() {
    _firestore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _firestore
          .collection('artefacts')
          .add({
            "artefato": {
              "id": "1c6a31d1-9255-4dfa-80da-cb7a5b983c1a",
              "id_tipo": "1c6a31d1-9255-4dfa-80da-cb7a5b983c1a",
              "id_entidade": "1c6a31d1-9255-4dfa-80da-cb7a5b983c1a",
              "descricao": "semaforo",
              "ativo": true,
              "comportamentos": {"a": "b"},
              "criado_em": "2023-03-10T19:34:00Z"
            },
            "corpo": {"mensagem": "teste"}
          })
          .then((value) => print('Success! ID: ${value.id}'))
          .catchError((error) => print('$error'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _artefactStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          var data = snapshot.data.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var artefact = data[index] as DocumentSnapshot;
              return Text(artefact.data().toString());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
