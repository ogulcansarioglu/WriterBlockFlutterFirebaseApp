# WriterBlock - A New, Innovative Notes App, Proof of Concept

This app allows writers to write and store their notes, and then, share them on "Git" like system where everybody can contribute to and the writers gets to decide as an "admin" which changes to keep. 

This app is developed for both IOS&Android with Flutter & Dart and Firebase. 

## Milestones

- Basic UI, done
- Firebase Initilazation, done
- Login with Firebase, done
- Local Database with SQLlite, done
- Custom Auth System that allows Firebase, Google Cloud etc, done
- Notes writing, storing and deleting functionalities, done
- Notes Sharing Fundementals, done
- Full Firebase Imigration, done
- Ready, as an note keeping app, to be shared on Google and Apple Store, done

## Next Steps

- Creating the feed where users can modify and read shared notes
- Scores and Gamification based on Contributions and ReadCounts
- User Testing
- Sharing on Google Store and Apple Store 

## Login Screen: 

![loginscreen](https://user-images.githubusercontent.com/93154247/193502352-0566515c-fa65-4464-b022-3ab2c59608d5.PNG)
```dart
body: Column(
        children: [
          TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here')),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: true,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here')),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .logIn(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //e-mail verified

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, (route) => false);
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  "User not found",
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Wrong credentials",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered? Register here!'))
        ],
      ),
    );
  }
}
```


## Notes Screen with Deletion and Update:

![Notes UI](https://user-images.githubusercontent.com/93154247/193502437-7c345454-731f-41fa-9d0d-a6ed7c7589d2.PNG)
```dart
 @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemExtent: 106.0,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.rectangle),
                child: ListTile(
                  onTap: () {
                    onTap(note);
                  },
                  hoverColor: Colors.blueAccent,
                  title: Text(
                    note.text,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                      onPressed: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteNote(note);
                        }
                      },
                      icon: const Icon(Icons.delete)),
                ),
              ));
        });
  }
}
```


## Sharing:

![SharingFunction](https://user-images.githubusercontent.com/93154247/193502571-ee2cf552-6753-45f0-9df8-52c181dd9877.PNG)

Firebase Integration Code Snippet:

```dart
class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId)));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
```


