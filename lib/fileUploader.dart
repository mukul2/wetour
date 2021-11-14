import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class FileUploader{
  uploadPhoto({required Uint8List image}){
    String fileName = "tourApp"+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

    // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
    //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
    ref.putData(image).then((p0) {
      ref.getDownloadURL().then((value) {
        
      });
    });


  }
}