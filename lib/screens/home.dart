import 'package:flutter/material.dart';
import 'package:flutter_app/screens/view_user.dart';
import '../model/user.dart';
import '../services/user_service.dart';
import 'add_user.dart';
import 'edit_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<User> userList = <User>[];  //Lista que armazenará os contatos
  final userService = UserService();


  getAllUserDetails() async {
    var users = await userService.readAllUsers();
    userList = <User>[];

    if (users == null) {
      setState(() {
        userList = [];
      });
    } else {

      users.forEach((user) {
        setState(() {
          var userModel = User();
          userModel.id = user['id'];
          userModel.nome = user['nome'];
          userModel.telefone = user['telefone'];
          userModel.email = user['email'];
          userList.add(userModel);  //Adiciona o contato à lista
        });
      });
    }
  }

  @override
  void initState() {
    getAllUserDetails();  //Chama a função para obter os contatos quando a tela for inicializada
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 17, 56, 88),  //Cor de fundo da AppBar
        title: const Text(
          "Lista de contatos",
          style: TextStyle(color: Colors.white),  //Cor do texto da AppBar
        ),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewUser(
                          user: userList[index],
                        ))).then((data) => {getAllUserDetails()});
              },
              leading: const Icon(Icons.person),
              title: Text(userList[index].nome ?? "", style: TextStyle(color: Colors.white)),
              subtitle: Text(userList[index].telefone ?? "", style: TextStyle(color: Colors.white)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Ícone para editar o contato
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditUser(
                                  user: userList[index],
                                ))).then((data) => {getAllUserDetails()});
                      },
                      icon: Icon(Icons.edit, color: Colors.blue)),
                  //Ícone para excluir o contato
                  IconButton(
                      onPressed: () {
                        deleteFormDialog(context, userList[index].id);  //Chama a função para excluir o contato
                      },
                      icon: Icon(Icons.delete, color: Colors.red))
                ],
              ),
            ),
          );
        },
      ),
      //Botão flutuante para adicionar um novo contato
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddUser()))
              .then((data) => {getAllUserDetails()});
        },
        backgroundColor: Color.fromARGB(255, 17, 56, 88),  //Cor do botão
        child: Icon(
          Icons.add,
          color: Colors.white,  //Cor do ícone do botão
        ),
      ),
    );
  }

  //Exibir a caixa de confirmação de exclusão
  deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text("Você tem certeza que deseja excluir?",
                style: TextStyle(color: Colors.teal, fontSize: 20)),
            actions: [
              //Botão para confirmar a exclusão
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red,
                    textStyle: const TextStyle(fontSize: 15)),
                child: const Text("Excluir"),
                onPressed: () async {
                  var result = await userService.deleteUser(userId);  //Chama o serviço para excluir o usuário
                  if (result != null) {
                    Navigator.pop(context);
                    getAllUserDetails();  //Atualiza a lista de contatos
                  }
                },
              ),
              //Botão para fechar a caixa
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 15)),
                child: const Text("Fechar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}

