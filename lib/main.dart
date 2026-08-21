import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


String currentLanguage = "en";

bool darkMode = false;



Map<String, Map<String, String>> translations = {

  "en": {

    "title": "NR-ToDo-List",
    "task": "Write a task",
    "add": "Add Task",
    "settings": "Settings",
    "save": "Save",
    "image": "Image URL",
    "dark": "Dark Mode",

    "study": "Study",
    "work": "Work",
    "personal": "Personal",
    "sport": "Sport",
    "health": "Health",
    "shopping": "Shopping",

  },


  "fr": {

    "title": "NR-ToDo-List",
    "task": "Écrire une tâche",
    "add": "Ajouter une tâche",
    "settings": "Paramètres",
    "save": "Enregistrer",
    "image": "URL de l'image",
    "dark": "Mode sombre",

    "study": "Étude",
    "work": "Travail",
    "personal": "Personnel",
    "sport": "Sport",
    "health": "Santé",
    "shopping": "Achats",

  },


  "ar": {

    "title": "NR-ToDo-List",
    "task": "اكتب مهمة",
    "add": "إضافة مهمة",
    "settings": "الإعدادات",
    "save": "حفظ",
    "image": "رابط الصورة",
    "dark": "الوضع الداكن",

    "study": "دراسة",
    "work": "عمل",
    "personal": "شخصي",
    "sport": "رياضة",
    "health": "صحة",
    "shopping": "تسوق",

  },


  "de": {

    "title": "NR-ToDo-List",
    "task": "Aufgabe schreiben",
    "add": "Aufgabe hinzufügen",
    "settings": "Einstellungen",
    "save": "Speichern",
    "image": "Bild URL",
    "dark": "Dunkler Modus",

    "study": "Studium",
    "work": "Arbeit",
    "personal": "Persönlich",
    "sport": "Sport",
    "health": "Gesundheit",
    "shopping": "Einkaufen",

  },

};



String tr(String key){

  return translations[currentLanguage]![key]!;

}




void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(

    const TodoApp(),

  );

}
class TodoApp extends StatefulWidget {

  const TodoApp({super.key});


  @override
  State<TodoApp> createState() => _TodoAppState();

}



class _TodoAppState extends State<TodoApp> {



  @override
  void initState(){

    super.initState();

    loadSettings();

  }




  Future<void> loadSettings() async {


    final prefs =

    await SharedPreferences.getInstance();



    setState(() {


      currentLanguage =

          prefs.getString("language") ?? "en";



      darkMode =

          prefs.getBool("dark") ?? false;



    });



  }






  void changeTheme(bool value){


    setState(() {


      darkMode = value;


    });


  }





  @override
  Widget build(BuildContext context){


    return MaterialApp(


      debugShowCheckedModeBanner: false,



      themeMode:

      darkMode

          ? ThemeMode.dark

          : ThemeMode.light,



      theme: ThemeData(

        brightness: Brightness.light,

      ),



      darkTheme: ThemeData(

        brightness: Brightness.dark,

      ),



      home: TodoHomePage(

        changeTheme: changeTheme,

      ),


    );


  }


}






class Task {


  String title;

  String date;

  bool done;

  List<String> categories;




  Task({

    required this.title,

    required this.date,

    required this.done,

    required this.categories,

  });






  Map<String,dynamic> toJson(){


    return {

      "title": title,

      "date": date,

      "done": done,

      "categories": categories,


    };


  }






  factory Task.fromJson(Map<String,dynamic> json){


    return Task(


      title: json["title"],


      date: json["date"],


      done: json["done"],


      categories:

      List<String>.from(

          json["categories"]

      ),



    );


  }


}
class TodoHomePage extends StatefulWidget {


  final Function(bool) changeTheme;



  const TodoHomePage({

    super.key,

    required this.changeTheme,

  });





  @override
  State<TodoHomePage> createState() =>

      _TodoHomePageState();



}





class _TodoHomePageState extends State<TodoHomePage>{



  final TextEditingController controller =

  TextEditingController();




  List<Task> tasks = [];



  List<String> selectedCategories = [];



  String backgroundUrl = "";





  final List<String> categories = [


    "study",

    "work",

    "personal",

    "sport",

    "health",

    "shopping",


  ];







  @override

  void initState(){

    super.initState();

    loadData();

  }








  Future<void> loadData() async {



    final prefs =

    await SharedPreferences.getInstance();





    List<String> saved =

    prefs.getStringList("tasks") ?? [];






    setState((){



      tasks = saved.map((e){



        return Task.fromJson(

            jsonDecode(e)

        );



      }).toList();





      backgroundUrl =

      prefs.getString("background") ?? "";



    });



  }







  Future<void> saveTasks() async {



    final prefs =

    await SharedPreferences.getInstance();






    List<String> data =

    tasks.map((e){



      return jsonEncode(

          e.toJson()

      );



    }).toList();






    await prefs.setStringList(

        "tasks",

        data

    );



  }








  Future<void> saveSettings() async {



    final prefs =

    await SharedPreferences.getInstance();






    await prefs.setString(

        "language",

        currentLanguage

    );





    await prefs.setBool(

        "dark",

        darkMode

    );



  }








  Future<void> saveBackground(String url) async {



    final prefs =

    await SharedPreferences.getInstance();






    await prefs.setString(

        "background",

        url

    );






    setState((){


      backgroundUrl = url;



    });



  }








  void addTask(){



    if(controller.text.trim().isEmpty){

      return;

    }





    setState((){



      tasks.add(



        Task(



          title: controller.text.trim(),



          date:

          DateFormat("dd/MM/yyyy")

              .format(DateTime.now()),



          done:false,



          categories:

          selectedCategories,



        ),



      );




      controller.clear();



      selectedCategories = [];




    });





    saveTasks();



  }








  void checkTask(int index){



    setState((){



      tasks[index].done =

      !tasks[index].done;



    });




    saveTasks();



  }







  void deleteTask(int index){



    setState((){



      tasks.removeAt(index);



    });




    saveTasks();



  }
  void openSettings(){


    TextEditingController urlController =

    TextEditingController(

      text: backgroundUrl,

    );



    showDialog(


      context: context,


      builder:(context){



        return AlertDialog(



          title: Text(

            tr("settings"),

          ),




          content: Column(



            mainAxisSize:

            MainAxisSize.min,



            children: [





              TextField(



                controller: urlController,



                decoration: InputDecoration(



                  hintText: tr("image"),



                ),



              ),






              DropdownButton<String>(



                value: currentLanguage,



                items: const [




                  DropdownMenuItem(

                    value:"en",

                    child:Text("English"),

                  ),




                  DropdownMenuItem(

                    value:"fr",

                    child:Text("Français"),

                  ),




                  DropdownMenuItem(

                    value:"ar",

                    child:Text("العربية"),

                  ),




                  DropdownMenuItem(

                    value:"de",

                    child:Text("Deutsch"),

                  ),



                ],





                onChanged:(value){



                  if(value != null){



                    setState((){



                      currentLanguage = value;



                    });



                    saveSettings();



                  }



                },



              ),






              SwitchListTile(



                title: Text(

                  tr("dark"),

                ),



                value: darkMode,



                onChanged:(value){



                  widget.changeTheme(value);



                  setState((){



                    darkMode = value;



                  });



                  saveSettings();



                },



              ),



            ],



          ),






         actions:[

  TextButton(

    onPressed: (){

      showAboutDialog(

        context: context,

        applicationName: "NR-ToDo-List",

        applicationVersion: "1.0.0",

        applicationLegalese:
        "Created by Nayrouz\nFlutter & Dart Project",

      );

    },

    child: const Text("About"),

  ),



  ElevatedButton(

    onPressed: (){

      saveBackground(
        urlController.text.trim(),
      );

      Navigator.pop(context);

    },

    child: Text(
      tr("save"),
    ),

  ),

],

        );



      },



    );



  }









  @override

  Widget build(BuildContext context){



    return Scaffold(



      appBar: AppBar(



        title: Text(

          tr("title"),

        ),




        actions:[



          IconButton(



            icon:

            const Icon(Icons.settings),



            onPressed: openSettings,



          ),



        ],



      ),








      body: Container(



        decoration:

        backgroundUrl.isNotEmpty



            ? BoxDecoration(



          image:

          DecorationImage(



            image:

            NetworkImage(

              backgroundUrl,

            ),



            fit:

            BoxFit.cover,



          ),



        )



            : null,








        child: Padding(



          padding:

          const EdgeInsets.all(16),





          child: Column(



            children:[





              TextField(



                controller: controller,



                decoration: InputDecoration(



                  hintText: tr("task"),



                  filled:true,



                  border:

                  const OutlineInputBorder(),



                ),



              ),








              const SizedBox(height:15),








              Wrap(



                spacing:8,



                children:

                categories.map((category){



                  return FilterChip(



                    label: Text(

                      tr(category),

                    ),




                    selected:

                    selectedCategories

                        .contains(category),




                    onSelected:(value){



                      setState((){



                        if(value){



                          selectedCategories

                              .add(category);



                        }else{



                          selectedCategories

                              .remove(category);



                        }



                      });



                    },



                  );



                }).toList(),



              ),








              const SizedBox(height:15),







              ElevatedButton(



                onPressed:addTask,



                child:Text(

                  tr("add"),

                ),



              ),









              Expanded(



                child:

                ListView.builder(



                  itemCount:

                  tasks.length,





                  itemBuilder:(context,index){





                    return Card(



                      child:ListTile(



                        leading:

                        Checkbox(



                          value:

                          tasks[index].done,



                          onChanged:(_){



                            checkTask(index);



                          },



                        ),






                        title:Text(



                          tasks[index].title,



                          style:TextStyle(



                            decoration:

                            tasks[index].done

                                ? TextDecoration

                                .lineThrough

                                : null,



                          ),



                        ),







                        subtitle:Text(



                          "${tasks[index].categories.map((e)=>tr(e)).join(" • ")}\n${tasks[index].date}",



                        ),








                        trailing:

                        IconButton(



                          icon:

                          const Icon(Icons.delete),



                          onPressed:(){



                            deleteTask(index);



                          },



                        ),




                      ),



                    );



                  },



                ),



              ),



            ],



          ),



        ),



      ),



    );



  }


}