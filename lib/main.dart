import 'package:beautiful_textfields/beautiful_textfields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  TextEditingController taskController = TextEditingController();
  String selectedPriority = 'I should';
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', tasks);
  }

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(
            'Before I get out from AKGEC $selectedPriority ${taskController.text}');
        taskController.clear();
        saveTasks();
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks();
    });
  }

  void completeTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text('What you want after AKGEC?'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // const SizedBox(
                  //   height: 50,
                  // ),
                   DropdownButton<String?>(
                    elevation: 8,
                    iconEnabledColor: Colors.white,
                    iconDisabledColor: Colors.white,
                    focusColor: Colors.white,
                    dropdownColor: const Color.fromARGB(255, 13, 70, 78),
                    value: selectedPriority,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPriority = newValue;
                        });
                      }
                    },
                    items: ['I should', 'I must', 'I will', 'I want to']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                   const SizedBox(width: 16.0),
                  Expanded(
                      child: MyTextField(
                          hintText: 'Let your intrusive thoughts win',
                          inputType: TextInputType.name,
                          labelText2:
                              'Only you and your local storage know what you want :)',
                          secure1: false,
                          capital: TextCapitalization.characters,
                          nameController1: taskController)),
                 

                  // DropdownButton<String?>(
                  //   elevation: 8,
                  //   iconEnabledColor: Colors.white,
                  //   iconDisabledColor: Colors.white,
                  //   focusColor: Colors.white,
                  //   dropdownColor: const Color.fromARGB(255, 13, 70, 78),
                  //   value: selectedPriority,
                  //   onChanged: (String? newValue) {
                  //     if (newValue != null) {
                  //       setState(() {
                  //         selectedPriority = newValue;
                  //       });
                  //     }
                  //   },
                  //   items: ['I should', 'I must', 'I will', 'I want to']
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(
                  //         value,
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                ],
              ),
            ),
            // ElevatedButton(
            //   onPressed: addTask,
            //   child: const Text('Add Task'),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, bottom: 20, top: 10),
              child: Login(
                  buttonName: 'Add',
                  onTap: addTask,
                  bgColor: const Color.fromARGB(255, 94, 221, 237),
                  textColor: Colors.white),
            ),
            const SizedBox(height: 16.0),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        completeTask(index);
                      },
                      child: ListTile(
                        title: Text(
                          tasks[index],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 207, 88, 80)),
                          onPressed: () {
                            deleteTask(index);
                          },
                        ),
                      ),
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
}

class Login extends StatelessWidget {
  const Login({
    Key? key,
    required this.buttonName,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  final String buttonName;
  final VoidCallback onTap;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(12),
          shadowColor: MaterialStateProperty.all(Colors.black),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => Colors.transparent,
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 20, color: textColor),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hintText,
    required this.inputType,
    required this.labelText2,
    required this.secure1,
    required this.capital,
    required this.nameController1,
  }) : super(key: key);

  final String hintText;
  final TextInputType inputType;
  final String labelText2;
  final bool secure1;
  final TextCapitalization capital;
  final TextEditingController nameController1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        cursorColor: Colors.cyan,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        controller: nameController1,
        keyboardType: inputType,
        obscureText: secure1,
        textInputAction: TextInputAction.next,
        textCapitalization: capital,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan.shade200, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          labelText: labelText2,
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 12),
        ),
      ),
    );
  }
}
