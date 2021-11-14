import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:wetour/fileUploader.dart';

import 'colorConst.dart';
import 'locationManager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Md Islam Project',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Md Islam Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
   LocationManager().determinePosition().then((value) {
     print(value);
   });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  Widget contentList =   StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("forumPost").orderBy("time",descending: true).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,) {
      if(snapshot.hasData){
     return  ListView.builder(shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return  Padding(
              padding: const EdgeInsets.all(0.0),
              child: Card(  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),color: Colors.white,child:  Wrap(
                children: [
                  Container(width: double.infinity,height: height*0.07,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: snapshot.data!.docs[index].get("uid",) ).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUserInfo,) {
                          if(snapshotUserInfo.hasData){
                            print(snapshotUserInfo.data!.docs.first.data());
                            print(snapshot.data!.docs[index].data());
                           // return ListTile(subtitle: Text("") ,title:Text("") ,leading: CircleAvatar() ,);

                            return ListTile(trailing: convertDateTime(snapshot.data!.docs[index].get("time", )),subtitle: Text(snapshot.data!.docs[index].get("location", )) ,title:Text( snapshot.data!.docs[index].get("description", )) ,
                               leading: CircleAvatar(backgroundImage: NetworkImage(snapshotUserInfo.data!.docs.first.get("photo")),)
                            );
                          }else{
                            return ListTile(subtitle: Text("") ,title:Text("") ,leading: CircleAvatar() ,);
                          }

                        })
                    // Stack(
                    //   children: [
                    //     Align(alignment: Alignment.centerLeft,child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Icon(Icons.account_circle,color:buttonColor,),
                    //     ),),
                    //     Align(alignment: Alignment.centerRight,child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Icon(Icons.more_horiz_rounded,color: buttonColor,),
                    //     ),),
                    //   ],
                    // ),
                  ),
                  Container(width: double.infinity,height: height*0.5,child: Container(color: Colors.grey.withOpacity(0.2),child: Center(child: Image.network( snapshot.data!.docs[index].get("photo", ),)),),)
                ],
              ),),
            );

          },
        );
      }else{
        return Center(child: Text("No Data"),);
      }
      
    });
  return  StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot,) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.active
            || snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else   if (snapshot.hasData && snapshot.data!.uid!=null){
            print(snapshot.data!);
            return   Scaffold(
              appBar: AppBar(elevation: 1,iconTheme: IconThemeData(
                  color: buttonColor
              ),backgroundColor: Colors.white,leading:IconButton(onPressed: () async {

                FirebaseAuth auth = FirebaseAuth.instance;
                TextEditingController controllerAddress = TextEditingController();
                TextEditingController controllerDescription = TextEditingController();


                  if(auth.currentUser!=null && auth.currentUser!.uid!=null){

                    showDialog(
                      context: context,
                      builder: (context) {
                        String contentText = "Content of Dialog";
                        Uint8List? photo;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Dialog(child: Container(width: 400,child: Wrap(children: [
                              Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
                                Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                                  Navigator.pop(context);
                                },icon: Icon(Icons.close,color:iconColorLight,),),),
                                Align(alignment: Alignment.centerLeft,child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text("Add New Post",style: TextStyle(color: Colors.white),),
                                ),),

                              ],)),

                              ListTile(title: Text(auth.currentUser!.displayName!),subtitle: Text(auth.currentUser!.email!),

                                leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.photoURL!),),),


                              Padding(
                                padding: const EdgeInsets.only(top: 0,left: 5,right: 5),
                                child: Text("Location/Spot",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 0,left: 5,right: 5),
                                child: TextFormField(controller: controllerAddress,decoration: InputDecoration(fillColor: lightGrey,contentPadding: EdgeInsets.all(10),),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0,left: 5,right: 5),
                                child: Text("Description",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 0,left: 5,right: 5),
                                child: TextFormField(controller: controllerDescription,decoration: InputDecoration(fillColor: lightGrey,contentPadding: EdgeInsets.all(10),),),
                              ),

                              SizedBox(height: 15,),

                              Container(child:photo!=null? Container(height: 300,child: Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.memory(photo!),
                              ),)):Center(child: Text(""),),),


                              InkWell(onTap: () async {

                                Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                                print(photoMetaData);
                                setState(() {
                                  photo = photoMetaData;
                                });

                                // FileUploader().uploadPhoto(image: photoMetaData);
                              },
                                child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Add Photo",style:TextStyle(color: Colors.white) ,),
                                )),),
                              ),
                              InkWell(onTap: () async {
                                if(photo!=null){
                                  String fileName = "tourApp"+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

                                  // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
                                  //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
                                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
                                  ref.putData(photo!).then((p0) {
                                    ref.getDownloadURL().then((valuePhotoLink) {
                                      FirebaseFirestore  firestore=   FirebaseFirestore.instance ;
                                      firestore.collection("forumPost").add({"time":DateTime.now().millisecondsSinceEpoch,"photo":valuePhotoLink, "uid":auth.currentUser!.uid,"location":controllerAddress.text,"description":controllerDescription.text}).then((value) {
                                        Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                                      });




                                    });
                                  });
                                }



                                // FileUploader().uploadPhoto(image: photoMetaData);
                              },
                                child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Submit",style:TextStyle(color: Colors.white) ,),
                                )),),
                              ),
                            ],),),);
                          },
                        );
                      },
                    );
                  }else{
                    showDialog(
                      context: context,
                      builder: (context) {
                        String contentText = "Content of Dialog";
                        Uint8List? photo;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Dialog(child: Container(width: 400,child: Wrap(children: [
                              Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
                                Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                                  Navigator.pop(context);
                                },icon: Icon(Icons.close,color:iconColorLight,),),),
                                Align(alignment: Alignment.centerLeft,child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text("Login or Signup",style: TextStyle(color: Colors.white),),
                                ),),

                              ],)),



                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(onTap: () async {

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      String contentText = "Content of Dialog";
                                      Uint8List? photo;
                                      String displayName = "";
                                      String email = "";
                                      String password = "";
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Dialog(child: Container(width: 400,child: Wrap(children: [
                                            Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
                                              Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                                                Navigator.pop(context);
                                              },icon: Icon(Icons.close,color:iconColorLight,),),),
                                              Align(alignment: Alignment.centerLeft,child: Padding(
                                                padding: const EdgeInsets.only(left: 15),
                                                child: Text("Create new account",style: TextStyle(color: Colors.white),),
                                              ),),

                                            ],)),
                                            ListTile(title: Text(displayName),subtitle: Text(email),leading: photo!=null?InkWell(onTap: () async {
                                              Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                                              print(photoMetaData);
                                              setState(() {
                                                photo = photoMetaData;
                                              });
                                            },child: CircleAvatar(backgroundImage: MemoryImage(photo!),)):InkWell( onTap: () async {

                                            },child: IconButton(onPressed: () async {
                                              Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                                              print(photoMetaData);
                                              setState(() {
                                                photo = photoMetaData;
                                              });
                                            },icon:Icon(Icons.account_circle_outlined))),),
                                            Divider(),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                              child: TextFormField(onChanged: (val){
                                                setState(() {
                                                  displayName = val;
                                                });
                                              },decoration: InputDecoration(border: null,hintText: "Display name",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                              child: TextFormField(onChanged: (val){
                                                setState(() {
                                                  email = val;
                                                });
                                              },decoration: InputDecoration(border: null,hintText: "Email",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                              child: TextFormField(onChanged: (val){
                                                setState(() {
                                                  password = val;
                                                });
                                              },decoration: InputDecoration(border: null,hintText: "Password",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                            ),
                                            InkWell(onTap: (){
                                              FirebaseFirestore firestore =  FirebaseFirestore.instance;
                                              FirebaseAuth auth =  FirebaseAuth.instance;
                                              if(photo!=null){
                                                String fileName = "tourApp"+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

                                                // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
                                                //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
                                                firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
                                                ref.putData(photo!).then((p0) {
                                                  ref.getDownloadURL().then((valuePhotoLink) {
                                                    auth.createUserWithEmailAndPassword(email: email, password: password).then((value){
                                                      auth.currentUser!.updatePhotoURL(valuePhotoLink);
                                                      auth.currentUser!.updateDisplayName(displayName);


                                                      firestore.collection("users").add({ "email":auth.currentUser!.email,"displayName":displayName,"uid":auth.currentUser!.uid,"photo":valuePhotoLink}).then((value) {
                                                        Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                                                      });

                                                    });




                                                  });
                                                });
                                              }


                                            },
                                              child: Container(height: 50,width: 200,margin: EdgeInsets.all(5),decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Create Account",style:TextStyle(color: Colors.white) ,),
                                              )),),
                                            )


                                          ],),),);
                                        },
                                      );
                                    },
                                  );

                                  // FileUploader().uploadPhoto(image: photoMetaData);
                                },
                                  child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Create Account",style:TextStyle(color: Colors.white) ,),
                                  )),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(onTap: () async {

                                  Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                                  print(photoMetaData);
                                  setState(() {
                                    photo = photoMetaData;
                                  });

                                  // FileUploader().uploadPhoto(image: photoMetaData);
                                },
                                  child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Login",style:TextStyle(color: Colors.white) ,),
                                  )),),
                                ),
                              ),
                            ],),),);
                          },
                        );
                      },
                    );
                  }




                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return Dialog(child: Container(width: 400,child: Wrap(children: [
                //         Container(height: 50,child: Stack(children: [
                //           Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                //             Navigator.pop(context);
                //           },icon: Icon(Icons.close),),),
                //           Align(alignment: Alignment.centerLeft,child: Text("Login"),),
                //
                //         ],)),
                //         Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text("Login / Signup",style:TextStyle(color: Colors.white) ,),
                //         )),),
                //         InkWell(onTap: () async {
                //
                // Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                // print(photoMetaData);
                // FileUploader().uploadPhoto(image: photoMetaData);
                //         },
                //           child: Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Text("Proceed annonymus",style:TextStyle(color: Colors.white) ,),
                //           )),),
                //         ),
                //       ],),),);
                //     });




              },icon:Icon( Icons.camera_alt_outlined),) ,title: Text("We Tour",style: TextStyle(color: buttonColor,fontSize: height*0.018),) ,centerTitle: true,actions: [
                IconButton(onPressed: (){

                },icon:CircleAvatar(
                 backgroundImage: NetworkImage(snapshot.data!.photoURL!),
                ),)
              ],),

              body: Center(
                child: Container(width:width>500?500:width ,decoration: BoxDecoration(

                  //border: Border.all(color: width>500?Colors.black:Colors.white,width: 1)
                ),
                  child: contentList,
                ),
              ),
              bottomNavigationBar: Container(color: Colors.white,width: double.infinity,height:  ( height*0.06),
                child: Row(children: [
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.home),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.search),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.add_photo_alternate_sharp),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.thumb_up_alt_rounded),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.account_circle_outlined),)),
                ],),
              ),
            );
          }else{
            return  Scaffold(
              appBar: AppBar(elevation: 1,iconTheme: IconThemeData(
                  color: buttonColor
              ),backgroundColor: Colors.white,leading:IconButton(onPressed: () async {

                FirebaseAuth auth = FirebaseAuth.instance;


                showDialog(
                  context: context,
                  builder: (context) {
                    String contentText = "Content of Dialog";
                    Uint8List? photo;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Dialog(child: Container(width: 400,child: Wrap(children: [
                          Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
                            Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                              Navigator.pop(context);
                            },icon: Icon(Icons.close,color:iconColorLight,),),),
                            Align(alignment: Alignment.centerLeft,child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text("Login or Signup",style: TextStyle(color: Colors.white),),
                            ),),

                          ],)),



                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(onTap: () async {

                              showDialog(
                                context: context,
                                builder: (context) {
                                  String contentText = "Content of Dialog";
                                  Uint8List? photo;
                                  String displayName = "";
                                  String email = "";
                                  String password = "";
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Dialog(child: Container(width: 400,child: Wrap(children: [
                                        Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
                                          Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                                            Navigator.pop(context);
                                          },icon: Icon(Icons.close,color:iconColorLight,),),),
                                          Align(alignment: Alignment.centerLeft,child: Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Text("Create new account",style: TextStyle(color: Colors.white),),
                                          ),),

                                        ],)),
                                        ListTile(title: Text(displayName),subtitle: Text(email),leading: photo!=null?InkWell(onTap: () async {
                                          Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                                          print(photoMetaData);
                                          setState(() {
                                            photo = photoMetaData;
                                          });
                                        },child: CircleAvatar(backgroundImage: MemoryImage(photo!),)):InkWell( onTap: () async {

                                        },child: IconButton(onPressed: () async {
                                          Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                                          print(photoMetaData);
                                          setState(() {
                                            photo = photoMetaData;
                                          });
                                        },icon:Icon(Icons.account_circle_outlined))),),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                          child: TextFormField(onChanged: (val){
                                            setState(() {
                                              displayName = val;
                                            });
                                          },decoration: InputDecoration(border: null,hintText: "Display name",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                          child: TextFormField(onChanged: (val){
                                            setState(() {
                                              email = val;
                                            });
                                          },decoration: InputDecoration(border: null,hintText: "Email",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                          child: TextFormField(onChanged: (val){
                                            setState(() {
                                              password = val;
                                            });
                                          },decoration: InputDecoration(border: null,hintText: "Password",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                        ),
                                        InkWell(onTap: (){
                                          FirebaseFirestore firestore =  FirebaseFirestore.instance;
                                          FirebaseAuth auth =  FirebaseAuth.instance;
                                          if(photo!=null){
                                            String fileName = "tourApp"+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

                                            // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
                                            //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
                                            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
                                            ref.putData(photo!).then((p0) {
                                              ref.getDownloadURL().then((valuePhotoLink) {
                                                auth.createUserWithEmailAndPassword(email: email, password: password).then((value){
                                                  auth.currentUser!.updatePhotoURL(valuePhotoLink);
                                                  auth.currentUser!.updateDisplayName(displayName);


                                                  firestore.collection("users").add({ "email":auth.currentUser!.email,"displayName":displayName,"uid":auth.currentUser!.uid,"photo":valuePhotoLink}).then((value) {
                                                    Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                                                  });

                                                });




                                              });
                                            });
                                          }


                                        },
                                          child: Container(height: 50,width: 200,margin: EdgeInsets.all(5),decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Create Account",style:TextStyle(color: Colors.white) ,),
                                          )),),
                                        )


                                      ],),),);
                                    },
                                  );
                                },
                              );

                              // FileUploader().uploadPhoto(image: photoMetaData);
                            },
                              child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Create Account",style:TextStyle(color: Colors.white) ,),
                              )),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(onTap: () async {

                              showDialog(
                                context: context,
                                builder: (context) {
                                  String contentText = "Content of Dialog";
                                  Uint8List? photo;
                                  String displayName = "";
                                  String email = "";
                                  String password = "";
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Dialog(child: Container(width: 400,child: Wrap(children: [
                                        Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
                                          Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                                            Navigator.pop(context);
                                          },icon: Icon(Icons.close,color:iconColorLight,),),),
                                          Align(alignment: Alignment.centerLeft,child: Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Text("Login",style: TextStyle(color: Colors.white),),
                                          ),),

                                        ],)),



                                        Padding(
                                          padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                          child: TextFormField(onChanged: (val){
                                            setState(() {
                                              email = val;
                                            });
                                          },decoration: InputDecoration(border: null,hintText: "Email",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                          child: TextFormField(onChanged: (val){
                                            setState(() {
                                              password = val;
                                            });
                                          },decoration: InputDecoration(border: null,hintText: "Password",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                        ),
                                        InkWell(onTap: (){
                                          FirebaseFirestore firestore =  FirebaseFirestore.instance;
                                          FirebaseAuth auth =  FirebaseAuth.instance;

                                          auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
                                            //navigate to first screen
                                            Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);

                                          });



                                        },
                                          child: Container(height: 50,width: 200,margin: EdgeInsets.all(5),decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Login",style:TextStyle(color: Colors.white) ,),
                                          )),),
                                        )


                                      ],),),);
                                    },
                                  );
                                },
                              );

                              // FileUploader().uploadPhoto(image: photoMetaData);
                            },
                              child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Login",style:TextStyle(color: Colors.white) ,),
                              )),),
                            ),
                          ),
                        ],),),);
                      },
                    );
                  },
                );




                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return Dialog(child: Container(width: 400,child: Wrap(children: [
                //         Container(height: 50,child: Stack(children: [
                //           Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
                //             Navigator.pop(context);
                //           },icon: Icon(Icons.close),),),
                //           Align(alignment: Alignment.centerLeft,child: Text("Login"),),
                //
                //         ],)),
                //         Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text("Login / Signup",style:TextStyle(color: Colors.white) ,),
                //         )),),
                //         InkWell(onTap: () async {
                //
                // Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
                // print(photoMetaData);
                // FileUploader().uploadPhoto(image: photoMetaData);
                //         },
                //           child: Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Text("Proceed annonymus",style:TextStyle(color: Colors.white) ,),
                //           )),),
                //         ),
                //       ],),),);
                //     });




              },icon:Icon( Icons.camera_alt_outlined),) ,title: Text("We Tour",style: TextStyle(color: buttonColor,fontSize: height*0.018),) ,centerTitle: true,actions: [
                IconButton(onPressed: (){

                },icon:CircleAvatar(),)
              ],),

              body: Center(
                child: Container(width:width>500?500:width ,decoration: BoxDecoration(

                  //border: Border.all(color: width>500?Colors.black:Colors.white,width: 1)
                ),
                  child:contentList
                ),
              ),
              bottomNavigationBar: Container(color: Colors.white,width: double.infinity,height:  ( height*0.06),
                child: Row(children: [
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.home),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.search),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.add_photo_alternate_sharp),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.thumb_up_alt_rounded),)),
                  Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.account_circle_outlined),)),
                ],),
              ),
            );
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );

  }

 Widget convertDateTime(param0) {
  return   Text( DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(param0)) );


  }
}
