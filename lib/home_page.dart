import 'package:flutter/material.dart';
import 'package:notekeeper/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DBHelper? dbRef;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
    print("got notes");
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    titleController.text=allNotes[index]["title"];
                    descController.text=allNotes[index]["desc"];
                    addUpdateAlert(isAdd:false,sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                  },
                  trailing: IconButton(icon: Icon(Icons.delete,color: Colors.red,),onPressed: (){
                    dbRef?.deleteNode(sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                    getNotes();
                  },),
                  leading: Text(
                      allNotes[index][DBHelper.COLUMN_NOTE_SNO].toString()),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                );
              })
          : Center(
              child: Text("No Notes Yet!!!"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
addUpdateAlert(isAdd:true);
        },
        child: Icon(Icons.add),
      ),
    );
  }
  void addUpdateAlert({required bool isAdd,int? sno}){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("${isAdd?"Add":"Update"} Note", style: TextStyle(fontSize: 25)),
            content: Column(
              spacing: 20,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    label: Text("TItle"),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                      label: Text("Description"),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                ElevatedButton(
                    onPressed: () async {
                      bool? check;
                      if (titleController.text.isNotEmpty &&
                          titleController.text.isNotEmpty) {
                        if(isAdd)
                         check = await dbRef?.addNote(
                            mtitle: titleController.text,
                            mDesc: descController.text);
                        else
                          check = await dbRef?.updateNote(title: titleController.text, desc: descController.text, sno:sno! );
                        if (check!) {
                          getNotes();
                        } else {
                          print("didnt add");
                        }
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text("${isAdd?"Add":"Update"}"))
              ],
            ),
          );
        });
  }
}
