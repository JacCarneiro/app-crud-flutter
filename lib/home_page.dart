import 'package:flutter/material.dart';
import 'user_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
  }

  void _addUser(Map<String, dynamic> user) {
    setState(() {
      users.add(user);
      _filterUsers();
    });
    _showMessage('Usuário cadastrado com sucesso!');
  }

  void _updateUser(Map<String, dynamic> user, int index) {
    setState(() {
      users[index] = user;
      _filterUsers();
    });
    _showMessage('Usuário editado com sucesso!');
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
      _filterUsers();
    });
    _showMessage('Usuário deletado com sucesso!');
  }

  void _filterUsers() {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
              user['email'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openForm({Map<String, dynamic>? user, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserForm(user: user),
      ),
    );

    if (result != null) {
      if (index == null) {
        _addUser(result);
      } else {
        _updateUser(result, index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Cadastro de Usuários'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterUsers();
                });
              },
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(child: Text('Nenhum usuário encontrado.'))
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        title: Text(user['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${user['email']}'),
                            Text('Telefone: ${user['phone']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _openForm(user: user, index: index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteUser(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
