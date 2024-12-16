import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/user_service.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  // Controladores para os campos de entrada de texto
  var userNomeController = TextEditingController();
  var userTelefoneController = TextEditingController();
  var userEmailController = TextEditingController();

  // Variáveis para validação dos campos
  bool validateNome = false;
  bool validateTelefone = false;
  bool validateEmail = false;


  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 17, 56, 88),  //Cor da barra de navegação
        title: Text("Adicionar contato"),  //Título
      ),
      body: SingleChildScrollView(  //Barra de rolagem da tela
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              //Campo para digitar o nome
              TextField(
                controller: userNomeController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Digite o nome',
                    labelText: "Nome",
                    errorText:
                    validateNome ? 'O campo nome não pode ser vazio' : null),  //Mensagem de erro se o campo estiver vazio
              ),
              const SizedBox(height: 20.0),

              //Campo para digitar o número de telefone
              TextField(
                controller: userTelefoneController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Digite o número de telefone',
                    labelText: "Telefone",
                    errorText:
                    validateTelefone ? 'O campo número de telefone não pode ser vazio' : null),
              ),
              const SizedBox(height: 20.0),

              //Campo para digitar o email
              TextField(
                controller: userEmailController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Digite o email',
                    labelText: "Email",
                    errorText: validateEmail
                        ? 'O campo email não pode ser vazio'
                        : null),  //Mensagem de erro
              ),
              const SizedBox(height: 20.0),

              //Botões de Salvar e Limpar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão para salvar as informações do contato
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.blue,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          userNomeController.text.isEmpty
                              ? validateNome = true
                              : false;

                          userTelefoneController.text.isEmpty
                              ? validateTelefone = true
                              : false;

                          userEmailController.text.isEmpty
                              ? validateEmail = true
                              : false;
                        });

                        //Se todos os campos estiverem preenchidos, cria e salva o contato
                        if (validateNome == false &&
                            validateTelefone == false &&
                            validateEmail == false) {
                          print("chamando");
                          var user = User();
                          user.nome = userNomeController.text;
                          user.telefone = userTelefoneController.text;
                          user.email = userEmailController.text;

                          var result = userService.saveUser(user);
                          print(result);
                          Navigator.pop(context, result);
                        }
                      },
                      child: const Text("Salvar")),

                  SizedBox(width: 10.0),

                  //Botão para limpar os campos de texto
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red,
                        textStyle: const TextStyle(fontSize: 15)),
                    child: const Text("Limpar"),
                    onPressed: () {
                      //Limpa os campos de texto
                      userNomeController.text = "";
                      userTelefoneController.text = "";
                      userEmailController.text = "";
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
