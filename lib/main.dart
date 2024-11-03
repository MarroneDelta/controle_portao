import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Gate> gates = [];

  TextEditingController ipController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void addGate() {
    setState(() {
      gates.add(Gate(nameController.text, ipController.text));
      ipController.clear();
      nameController.clear();
    });
  }

  void removeGate(int index) {
    setState(() {
      gates.removeAt(index);
    });
  }

  void sendCommand(String ip, String command) async {
    var url = Uri.parse('http://$ip/$command');
    await http.get(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Portões'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome do Portão'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ipController,
                decoration: InputDecoration(labelText: 'IP do Portão'),
              ),
            ),
            ElevatedButton(
              onPressed: addGate,
              child: Text('Adicionar Portão'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: gates.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(gates[index].name),
                      subtitle: Text(gates[index].ip),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeGate(index),
                      ),
                      onTap: () => _showGateControlDialog(gates[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGateControlDialog(Gate gate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Controle do ${gate.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () => sendCommand(gate.ip, 'ABRIR'),
                icon: Icon(Icons.lock_open),
                label: Text('Abrir Portão'),
              ),
              ElevatedButton.icon(
                onPressed: () => sendCommand(gate.ip, 'FECHAR'),
                icon: Icon(Icons.lock),
                label: Text('Fechar Portão'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Gate {
  String name;
  String ip;

  Gate(this.name, this.ip);
}
