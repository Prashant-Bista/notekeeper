import 'package:flutter/material.dart';
import 'package:notekeeper/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String,dynamic>>allNotes=[];
  DBHelper? dbRef;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef= DBHelper.getInstance;
    getNotes();
    print("got notes");

  }
  void getNotes()async{
   setState(() async{
     allNotes = await dbRef!.getAllNotes();
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: allNotes.isNotEmpty?ListView.builder(itemCount:allNotes.length,itemBuilder: (context,index){
       return ListTile(
         leading: Text(allNotes[index][DBHelper.COLUMN_NOTE_SNO].toString()),
         title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
         subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
       );
      }):Center(child: Text("No Notes Yet!!!"),),
      floatingActionButton: FloatingActionButton(onPressed: (){
          dbRef?.addNote(mtitle: "New note1 ", mDesc: "This is my first node just to see if it is working");

        setState(() {
        });
      },child: Icon(Icons.add),),
    );
  }
}
