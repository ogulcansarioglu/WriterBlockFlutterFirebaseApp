
import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/enums/menu_action.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/views/notes/notes_list_view.dart';

import '../../services/auth/crud/notes_service.dart';
import '../../utility/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);
  @override 
  _NotesViewState createState() => _NotesViewState();
}
class _NotesViewState extends State<NotesView> {

  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add)
            ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().Logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text("Log Out")),
            ];
          })
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if(snapshot.hasData) {
                      final allNotes = snapshot.data as List<DatabaseNote>;
                      return NotesListView(
                        notes: allNotes, 
                        onDeleteNote: (note) async {
                          await _notesService.deleteNote(id:note.id);
                        });
                     
                      
                    } else {
                      return const CircularProgressIndicator();
                    }
            
                  
                  default: 
                  return CircularProgressIndicator();
                
                }
              }));
        

            default:
              return const CircularProgressIndicator();
          }
        }
    ));
  }
}




