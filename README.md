# WriterBlock - A New, Innovative Notes App, Proof of Concept

This app allows writers to write and store their notes, and then, share them on "Git" like system where everybody can contribute to and the writers gets to decide as an "admin" which changes to keep.

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

##Next Steps

- Creating the feed where users can modify and read shared notes
- Scores and Gamification based on Contributions and ReadCounts
- User Testing
- Sharing on Google Store and Apple Store 

Login Screen: 

![loginscreen](https://user-images.githubusercontent.com/93154247/193502352-0566515c-fa65-4464-b022-3ab2c59608d5.PNG)


Notes Screen with Deletion and Update:

![Notes UI](https://user-images.githubusercontent.com/93154247/193502437-7c345454-731f-41fa-9d0d-a6ed7c7589d2.PNG)


Sharing:

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


