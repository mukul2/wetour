import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wetour/fileUploader.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wetour/place_service.dart';
import 'package:wetour/stream.dart';
import 'address_search.dart';
import 'colorConst.dart';
import 'locationManager.dart';
import 'package:http/http.dart' as http;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
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
  double lat = 0;
  double long = 0;

  String nearbyPlaces = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=nature&location=0%2C0&radius=1500&type=point_of_interest&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    nearbySearch.add({"code":"airport","name":"Airport"});
    nearbySearch.add({"code":"amusement_park","name":"amusement_park"});
    nearbySearch.add({"code":"aquarium","name":"aquarium"});
    nearbySearch.add({"code":"art_gallery","name":"art_gallery"});
    nearbySearch.add({"code":"bar","name":"bar"});
    nearbySearch.add({"code":"beauty_salon","name":"beauty_salon"});
    nearbySearch.add({"code":"book_store","name":"book_store"});
    nearbySearch.add({"code":"cafe","name":"cafe"});
    nearbySearch.add({"code":"casino","name":"casino"});
    nearbySearch.add({"code":"cemetery","name":"cemetery"});
    nearbySearch.add({"code":"church","name":"church"});
    nearbySearch.add({"code":"florist","name":"florist"});
    nearbySearch.add({"code":"library","name":"library"});
    nearbySearch.add({"code":"liquor_store","name":"liquor_store"});
    nearbySearch.add({"code":"mosque","name":"mosque"});
    nearbySearch.add({"code":"movie_theater","name":"movie_theater"});
    nearbySearch.add({"code":"museum","name":"museum"});
    nearbySearch.add({"code":"night_club","name":"night_club"});
    nearbySearch.add({"code":"park","name":"park"});
    nearbySearch.add({"code":"restaurant","name":"restaurant"});
    nearbySearch.add({"code":"spa","name":"spa"});
    nearbySearch.add({"code":"tourist_attraction","name":"tourist_attraction"});
    nearbySearch.add({"code":"zoo","name":"zoo"});


  }

  List nearbySearch = [];

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
    FirebaseAuth auth =  FirebaseAuth.instance;
  Widget contentList =   StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("forumPost").orderBy("time",descending: true).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,) {
      if(snapshot.hasData){
     return  ListView.builder(shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {

            return  Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect( borderRadius: BorderRadius.circular(5.0),
                child: InkWell(onTap: (){

                Future  download(String id) async {
            var url = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Cformatted_phone_number&place_id="+id+"&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw");
            final response = await http.get(
                url,
                headers: {
                  "Accept": "application/json",
                  "Access-Control_Allow_Origin": "*"
                });
            print(url);
            print(response.statusCode);
            print("place details key");
            print(response.body);
            dynamic x = jsonDecode(response.body);
            dynamic data = x["result"];
            print(data);
            print("len");
            print(data.length);
            return data;

            }
                Map<String, dynamic> dataMap = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Scaffold(
                      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: height,width: width,child: Stack(
                            children: [
                              Container(child: Image.network( snapshot.data!.docs[index].get("photo", ),height: height,fit: BoxFit.cover,width: width,)),



                              Container(height: height,width: width,decoration: BoxDecoration(
                                //  color: Colors.redAccent,
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                ),
                              ),),
                              Align(alignment: Alignment.bottomLeft,child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 8,top: 15),
                                    child: Text(snapshot.data!.docs[index].get("location", ),style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 8,top: 15),
                                    child: Text(snapshot.data!.docs[index].get("description", ),style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
                                    child: Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[index].get("time", ))),style: TextStyle(fontSize: 12,color: Colors.white),),
                                  ),
                                  dataMap["placeId"]!=null?  FutureBuilder<dynamic>(
                                 // "international_phone_number"
                                  future: download(snapshot.data!.docs[index].get("placeId", )), // async work
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                  if(snapshot.hasData){
                                    return snapshot.data["international_phone_number"]!=null?Text(snapshot.data["international_phone_number"]):Container(height: 0,width: 0,);
                                  }else{
                                    return Container(height: 0,width: 0,);
                                  }
            }):Container(width: 0,height: 0,),

                                ],
                              ),),
                              Positioned(left: 15,top:50,child:  InkWell(onTap: (){
                                Navigator.pop(context);
                              },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(height: 40,width: 40,child:  Center(
                                    child: new ClipRect(
                                      child: new BackdropFilter(
                                        filter: new ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                                        child: new Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20),
                                              color: Colors.grey.withOpacity(0.5)
                                          ),
                                          child: new Center(
                                            child:Icon(Icons.navigate_before_rounded),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),),
                                ),
                              ),),
                            ],
                          )),

                        ],
                      ),
                    )),
                  );
                },
                  child: Container(height: height*0.5,width: width,
                    child: Stack(
                      children: [
                        Image.network( snapshot.data!.docs[index].get("photo",),fit: BoxFit.cover,height: height*0.5,width: width,),
                        // Wrap(
                        //   children: [
                        //
                        //     Container(width: double.infinity,height: height*0.5,child: Container(
                        //     //  color: Colors.grey.withOpacity(0.1),
                        //       child: Center(child: Image.network( snapshot.data!.docs[index].get("photo",),fit: BoxFit.cover,)),),),
                        //     // Padding(
                        //     //   padding: const EdgeInsets.all(8.0),
                        //     //   child: Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[index].get("time", ))),style: TextStyle(fontSize: 12),),
                        //     // )
                        //   ],
                        // ),
                        Container(decoration: BoxDecoration(
                          //  color: Colors.redAccent,
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.transparent,
                              Colors.transparent,
                            ],
                          ),
                        ),),
                       Align(alignment: Alignment.bottomCenter,child:  StreamBuilder<QuerySnapshot>(
                           stream: FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: snapshot.data!.docs[index].get("uid",) ).snapshots(),
                           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUserInfo,) {
                             if(snapshotUserInfo.hasData){
                               // print(snapshotUserInfo.data!.docs.first.data());
                               // print(snapshot.data!.docs[index].data());
                               // return ListTile(subtitle: Text("") ,title:Text("") ,leading: CircleAvatar() ,);

                               return Container(height: 60,
                                 child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10,right: 10),
                                       child: ClipRRect(borderRadius: BorderRadius.circular(5),child: Image.network(snapshotUserInfo.data!.docs.first.get("photo"),width: 50,height: 50,fit: BoxFit.cover,),),
                                     ),
                                     Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,children: [
                                       Text(snapshot.data!.docs[index].get("location", ),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),maxLines: 1,),
                                       Text( snapshot.data!.docs[index].get("description", ),style: TextStyle(color: Colors.white),maxLines: 1,)
                                     ],)

                                   ],
                                 ),
                               );

                               return ListTile(subtitle: Text(snapshot.data!.docs[index].get("location", ),style: TextStyle(color: Colors.white),) ,title:Text( snapshot.data!.docs[index].get("description", ),style: TextStyle(color: Colors.white)) ,
                                   leading: CircleAvatar(backgroundImage: NetworkImage(snapshotUserInfo.data!.docs.first.get("photo")),)
                               );
                             }else{
                               return ListTile(subtitle: Text("") ,title:Text("") ,leading: Center(child: CircleAvatar()) ,);
                             }

                           }),),
                      ],
                    ),
                  ),
                ),
              ),
            );

          },
        );
      }else{
        return Center(child: Text("No Data"),);
      }
      
    });
  Future<List?>  getPlaces() async {
    print("1");
    var value = await  LocationManager().determinePosition();
    print("2");


        nearbyPlaces = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=tourist_attraction&location="+value.latitude.toString()+"%2C"+value.longitude.toString()+"&radius=50000&type=point_of_interest&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";

        print("3");
print(nearbyPlaces);

    lat = value.latitude;
    lat = value.longitude;
    print("4");
     try{
       var url = Uri.parse(nearbyPlaces);
     //  var response = await http.get(url,);
       final response = await http.get(
           url,
           headers: {
             "Accept": "application/json",
             "Access-Control_Allow_Origin": "*"
           });
       print(response.statusCode);
       dynamic x = jsonDecode(response.body);
       List data = x["results"];
       print(data);
       print("len");
       print(data.length);
       return data;
     }catch(e){
       print(e);
     }
    }
    Future<List?>  getPlacesWithLOcation(List data) async {
      print("1");
    


      nearbyPlaces = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=tourist_attraction&location="+data[0].toString()+"%2C"+data[1].toString()+"&radius=50000&type=point_of_interest&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";

      lat = data[0];
      long = data[1];
      print("3");
      print(nearbyPlaces);


      print("4");
      try{
        var url = Uri.parse(nearbyPlaces);
        //  var response = await http.get(url,);
        final response = await http.get(
            url,
            headers: {
              "Accept": "application/json",
              "Access-Control_Allow_Origin": "*"
            });
        print(response.statusCode);
        dynamic x = jsonDecode(response.body);
        List data = x["results"];
        print(data);
        print("len");
        print(data.length);
        return data;
      }catch(e){
        print(e);
      }
    }
    Future<List>  getNearbyItems(String key) async {
      print("1");

      String link = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword="+key+"&location="+lat.toString()+"%2C"+long.toString()+"&radius=5000&type="+key+" &key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";




      print("3");
      print(nearbyPlaces);


      print("4");
      try{
        var url = Uri.parse(link);
        //  var response = await http.get(url,);
        final response = await http.get(
            url,
            headers: {
              "Accept": "application/json",
              "Access-Control_Allow_Origin": "*"
            });
        print(response.statusCode);
        dynamic x = jsonDecode(response.body);
        List data = x["results"];
        print(data);
        print("len");
        print(data.length);
        return data;
      }catch(e){
        return [];
      }
    }
  return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height:  height*0.4,
            child: Stack(children: [
              Container(width: width,height: height*0.4, child: Image.asset("assets/back.jpeg",fit: BoxFit.cover,)),
              Container(height: height*0.09,child: Stack(children: [
                Align(alignment: Alignment.centerLeft,child: IconButton(icon: Icon(Icons.menu,color: Colors.white,),onPressed: (){

                },),),

                Align(alignment: Alignment.centerRight,child:Row(
                  mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  IconButton(onPressed: () async {

                    final sessionToken = Uuid().v4();
                    final Suggestion? result = await showSearch(
                      context: context,
                      delegate: AddressSearch(sessionToken),
                    );
                    // This will change the text displayed in the TextField
                    if (result != null) {
                      final placeDetails = await PlaceApiProvider(sessionToken)
                          .getPlaceDetailFromId(result.placeId);
                      String anotherApi = "https://maps.googleapis.com/maps/api/place/details/json?placeid="+result.placeId+"&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
                      print(anotherApi);
                      var url = Uri.parse(anotherApi);
                      //  var response = await http.get(url,);
                      final response = await http.get(
                          url,
                          headers: {
                            "Accept": "application/json",
                            "Access-Control_Allow_Origin": "*"
                          });
                      print(response.statusCode);
                      print(response.body);
                      dynamic x = jsonDecode(response.body);
                      dynamic data = x["result"];
                      double lat = data["geometry"]["location"]["lat"];
                      double long = data["geometry"]["location"]["lng"];
                      print(data);
                      print("len");
                      print(lat);
                      print(long);
                      LocationSelected.getInstance().dataReload([lat,long]);
                    }



                    // List citys = ["Bath","Birmingham","Bristol","Cambridge"];
                    // List latLngs = [[51.380001,-2.360000],[52.489471,-1.898575],[51.454514,-2.587910],[52.205276,0.119167]];
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Scaffold(
                    //     appBar: AppBar(centerTitle: true,backgroundColor: Colors.white,elevation: 1,title: Text("Update location",style: TextStyle(color: Colors.blue),),iconTheme: IconThemeData(
                    //         color: Colors.blue,
                    //     ),),
                    //     body: SingleChildScrollView(
                    //       child: Expanded(
                    //         child: ListView.builder(shrinkWrap: true,
                    //           itemCount: citys.length,
                    //           itemBuilder: (context, index) {
                    //             return ListTile(onTap: (){
                    //               Navigator.pop(context);
                    //               LocationSelected.getInstance().dataReload(latLngs[index]);
                    //             },
                    //               title: Text(citys[index]),
                    //             );
                    //           },
                    //         ),
                    //         // child: Column(
                    //         //   children: [
                    //         //
                    //         //     ListTile(title: Text("Bath"),),
                    //         //     ListTile(title: Text("Birmingham"),),
                    //         //     ListTile(title: Text("Bristol"),),
                    //         //     ListTile(title: Text("Cambridge"),),
                    //         //     ListTile(title: Text("Derby"),),
                    //         //     ListTile(title: Text("Durham"),),
                    //         //     ListTile(title: Text("Glasgow"),),
                    //         //     ListTile(title: Text("Leeds"),),
                    //         //     ListTile(title: Text("Liverpool"),),
                    //         //     ListTile(title: Text("London"),),
                    //         //     ListTile(title: Text("Manchester"),),
                    //         //     ListTile(title: Text("Oxford"),),
                    //         //     ListTile(title: Text("Oxford"),),
                    //         //   ],
                    //         // ),
                    //       ),
                    //     ),
                    //   )),
                    // );
                  }, icon: Icon(Icons.gps_fixed_rounded ,color: Colors.white,)),
                  StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.userChanges(),
                      builder: (BuildContext context, AsyncSnapshot<User?> snapshot,) {
                        if (snapshot.hasData && snapshot.data!.uid!=null){
                          return IconButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewPostCreateActivity()),
                            );
                          }, icon: Icon(Icons.camera_alt_outlined,color: Colors.white,));

                        }else{
                          return IconButton(onPressed: (){
                            FirebaseAuth auth = FirebaseAuth.instance;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => CupertinoAlertDialog(
                                  title: new Text("Login/Signup require"),
                                  // content: new Text("This is my content"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(onPressed: (){
                                      String email = "";
                                      String password = "";


                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => Dialog(
                                            //title: new Text("Login"),
                                            child:  ClipRRect(borderRadius: BorderRadius.circular(10),
                                              child: Container(child:

                                              Wrap(children: [
                                                // Container(width: double.infinity,child: Padding(
                                                //   padding: const EdgeInsets.all(10.0),
                                                //   child: Center(child: Text("Login")),
                                                // )),
                                                // Container(color: Colors.grey,height: 0.1,width: double.infinity,),


                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 5),
                                                  child: CupertinoTextField(style: TextStyle(fontSize: 16),padding: EdgeInsets.all(8),onChanged: (val){
                                                    setState(() {
                                                      email = val;
                                                    });
                                                  },

                                                    placeholder: 'Email',

                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                                                  child: CupertinoTextField(style: TextStyle(fontSize: 16),padding: EdgeInsets.all(8),onChanged: (val){
                                                    setState(() {
                                                      password = val;
                                                    });
                                                  },

                                                    placeholder: 'Password',

                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                                                  child: CupertinoButton(color: Colors.blue,child: Center(child: Text("Login",style: TextStyle(color: Colors.white),)), onPressed: (){
                                                        FirebaseFirestore firestore =  FirebaseFirestore.instance;
                                                        FirebaseAuth auth =  FirebaseAuth.instance;

                                                        auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
                                                          //navigate to first screen
                                                          Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);

                                                        });
                                                  }),
                                                ),




                                                // Padding(
                                                //   padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                //   child: TextFormField(onChanged: (val){
                                                //     setState(() {
                                                //       email = val;
                                                //     });
                                                //   },decoration: InputDecoration(border: null,hintText: "Email",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                                // ),
                                                // Padding(
                                                //   padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                //   child: TextFormField(onChanged: (val){
                                                //     setState(() {
                                                //       password = val;
                                                //     });
                                                //   },decoration: InputDecoration(border: null,hintText: "Password",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
                                                // ),





                                              ],),),
                                            ),
                                            // actions: <Widget>[
                                            //   CupertinoDialogAction(onPressed: (){
                                            //     FirebaseFirestore firestore =  FirebaseFirestore.instance;
                                            //     FirebaseAuth auth =  FirebaseAuth.instance;
                                            //
                                            //     auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
                                            //       //navigate to first screen
                                            //       Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                                            //
                                            //     });
                                            //   },
                                            //     isDefaultAction: true,
                                            //     child: Text("Login"),
                                            //   ),
                                            //
                                            // ],
                                          )
                                      );




                                    },
                                      isDefaultAction: true,
                                      child: Text("Login"),
                                    ),
                                    CupertinoDialogAction(onPressed: (){




                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String contentText = "Content of Dialog";
                                          Uint8List? photo;
                                          String displayName = "";
                                          String email = "";
                                          String password = "";
                                            Dialog(
                                            child: ClipRRect(borderRadius: BorderRadius.circular(10),child:

                                            Container(color: Colors.white,width: width,
                                              child: Wrap(children: [

                                                Row(
                                                  children: [
                                                    CupertinoButton(child:  photo!=null? CircleAvatar(backgroundImage: MemoryImage(photo!),):Icon(CupertinoIcons.photo), onPressed: () async {
                                                      final ImagePicker _picker = ImagePicker();
                                                      // Pick an image
                                                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                                                      Uint8List photoMetaData =await image!.readAsBytes();
                                                      print(photoMetaData);
                                                      setState(() {
                                                        photo = photoMetaData;
                                                      });
                                                    }),


                                                    Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(displayName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                        Text(email)

                                                      ],
                                                    )

                                                  ],
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                  child: CupertinoTextField(placeholder:"Display name" ,onChanged: (val){
                                                    setState(() {
                                                      displayName = val;
                                                    });
                                                  },
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                  child: CupertinoTextField(placeholder:  "Email",onChanged: (val){
                                                    setState(() {
                                                      email = val;
                                                    });
                                                  },),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                  child: CupertinoTextField(placeholder:  "Password",onChanged: (val){
                                                    setState(() {
                                                      password = val;
                                                    });
                                                  },),
                                                ),



                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                                                  child: CupertinoButton(color: Colors.blue,child: Center(child: Text("Create account",style: TextStyle(color: Colors.white),)), onPressed: (){
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
                                                  }),
                                                ),



                                              ],),
                                            ),),
                                          );
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return  ClipRRect(borderRadius: BorderRadius.circular(10),child:

                                              Container(color: Colors.white,width: width,
                                                child: Wrap(children: [

                                                  AppBar(backgroundColor: Colors.white,iconTheme: IconThemeData(
                                                      color: Colors.blue
                                                  ),elevation: 1,title: Text("Create new account",style: TextStyle(color: Colors.blue),),),

                                                  Row(
                                                    children: [
                                                      CupertinoButton(child:  photo!=null? CircleAvatar(backgroundImage: MemoryImage(photo!),):Icon(CupertinoIcons.photo), onPressed: () async {
                                                        final ImagePicker _picker = ImagePicker();
                                                        // Pick an image
                                                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                                                        Uint8List photoMetaData =await image!.readAsBytes();
                                                        print(photoMetaData);
                                                        setState(() {
                                                          photo = photoMetaData;
                                                        });
                                                      }),


                                                      Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(displayName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                          Text(email)

                                                        ],
                                                      )

                                                    ],
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                    child: CupertinoTextField(placeholder:"Display name" ,onChanged: (val){
                                                      setState(() {
                                                        displayName = val;
                                                      });
                                                    },
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                    child: CupertinoTextField(placeholder:  "Email",onChanged: (val){
                                                      setState(() {
                                                        email = val;
                                                      });
                                                    },),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                    child: CupertinoTextField(placeholder:  "Password",onChanged: (val){
                                                      setState(() {
                                                        password = val;
                                                      });
                                                    },),
                                                  ),



                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                                                    child: CupertinoButton(color: Colors.blue,child: Center(child: Text("Create account",style: TextStyle(color: Colors.white),)), onPressed: (){
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
                                                    }),
                                                  ),



                                                ],),
                                              ),);
                                            },
                                          );
                                        },
                                      );
                                    },
                                      child: Text("Signup"),
                                    )
                                  ],
                                )
                            );
                          }, icon: Icon(Icons.camera_alt_outlined,color: Colors.white,));
                        }

                      }),

                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.userChanges(),
                        builder: (BuildContext context, AsyncSnapshot<User?> snapshot,) {
                          if (snapshot.hasData && snapshot.data!.uid!=null){
                            return CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!.photoURL!),
                            );

                          }else{
                            return Container(height: 0,width: 0,);
                          }

                        }),
                  )
                ],),),
              ],))
            


            ],),
          ),
          Container(height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(children: [
                Align(alignment: Alignment.centerLeft,child: Text("Nearby places",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),),
                Align(alignment: Alignment.centerRight,child: Text("See all",style: TextStyle(color: Colors.blue),),),
              ],),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container( height: MediaQuery.of(context).size.width*0.5,
              child: StreamBuilder<List>(
                    stream:LocationSelected.getInstance().outData,
                    builder: (context, snapshot)  {
                      if(snapshot.hasData){
                        return FutureBuilder<List?>(
                          future: getPlacesWithLOcation(snapshot.data!), // async work
                          builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
                            if(snapshot.hasData){
                              return  ListView.builder(shrinkWrap: true,physics: AlwaysScrollableScrollPhysics(),

                                  itemCount: snapshot.data!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {

                                    if( snapshot.data![index]["photos"]!=null&& snapshot.data![index]["photos"][0]!=null){
                                      String photo = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photo_reference="+snapshot.data![index]["photos"][0]["photo_reference"]+"&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
                                      return  Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect( borderRadius: BorderRadius.circular(5.0),
                                          child: Container(
                                              height: MediaQuery.of(context).size.width*0.5,
                                              width: MediaQuery.of(context).size.width*0.7 ,

                                              child: Stack(children: [
                                                Image.network(photo,fit: BoxFit.cover, height: MediaQuery.of(context).size.width*0.5,
                                                    width: MediaQuery.of(context).size.width*0.7 ),

                                                Container(decoration: BoxDecoration(
                                                  //  color: Colors.redAccent,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.grey,
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),),
                                                Align(alignment: Alignment.bottomLeft,child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(snapshot.data![index]["name"],style: TextStyle(color: Colors.white),),
                                                      RatingBar.builder(
                                                        initialRating: double.parse(snapshot.data![index]["rating"].toString()),
                                                        minRating: double.parse(snapshot.data![index]["rating"].toString()),maxRating: double.parse(snapshot.data![index]["rating"].toString()),
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                        itemBuilder: (context, _) => Icon(
                                                          Icons.star,size: 12,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate: (rating) {
                                                          print(rating);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),),
                                              ],)
                                          ),
                                        ),
                                      );
                                    }else{
                                      return Container(width: 0,height: 0,);
                                    }



                                  }
                              );

                            }else{
                              return Container(height: 0,width:0,);
                            }
                          },
                        );
                      }else{
                        return FutureBuilder<List?>(
                          future: getPlaces(), // async work
                          builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
                            if(snapshot.hasData){
                              return  ListView.builder(shrinkWrap: true,physics: AlwaysScrollableScrollPhysics(),

                                  itemCount: snapshot.data!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {

                                    if( snapshot.data![index]["photos"]!=null&& snapshot.data![index]["photos"][0]!=null){
                                      String photo = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photo_reference="+snapshot.data![index]["photos"][0]["photo_reference"]+"&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
                                      return  Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect( borderRadius: BorderRadius.circular(5.0),
                                          child: Container(
                                              height: MediaQuery.of(context).size.width*0.5,
                                              width: MediaQuery.of(context).size.width*0.7 ,

                                              child: Stack(children: [
                                                Image.network(photo,fit: BoxFit.cover, height: MediaQuery.of(context).size.width*0.5,
                                                    width: MediaQuery.of(context).size.width*0.7 ),

                                                Container(decoration: BoxDecoration(
                                                  //  color: Colors.redAccent,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.grey,
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),),
                                                Align(alignment: Alignment.bottomLeft,child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(snapshot.data![index]["name"],style: TextStyle(color: Colors.white),),
                                                      RatingBar.builder(
                                                        initialRating: double.parse(snapshot.data![index]["rating"].toString()),
                                                        minRating: double.parse(snapshot.data![index]["rating"].toString()),maxRating: double.parse(snapshot.data![index]["rating"].toString()),
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                        itemBuilder: (context, _) => Icon(
                                                          Icons.star,size: 12,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate: (rating) {
                                                          print(rating);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),),
                                              ],)
                                          ),
                                        ),
                                      );
                                    }else{
                                      return Container(width: 0,height: 0,);
                                    }



                                  }
                              );

                            }else{
                              return Container(height: 0,width:0,);
                            }
                          },
                        );
                        
                      }
                    })
             
            ),
          ),
         Container(height: 100,width: width,child:  ListView.builder(shrinkWrap: true,
           scrollDirection: Axis.horizontal,
           // physics: AlwaysScrollableScrollPhysics(),
           itemCount: nearbySearch.length,
           itemBuilder: (context, index) {

             return InkWell(onTap: (){
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) =>SafeArea(child: Scaffold(appBar:  AppBar(backgroundColor: Colors.white,iconTheme: IconThemeData(
                       color: Colors.blue
                   ),elevation: 1,title: Text(nearbySearch[index]["name"].toString().replaceAll("_", " ").toUpperCase(),style: TextStyle(color: Colors.blue),),) ,body:FutureBuilder<List>(
                     future: getNearbyItems(nearbySearch[index]["code"].toString()), // async work
                     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                       if(snapshot.hasData && snapshot.data!.length>0){
                         return ListView.builder(
                           itemCount: snapshot.data!.length,
                           itemBuilder: (context, index) {
                             String photo="";
    if( snapshot.data![index]["photos"]!=null&& snapshot.data![index]["photos"][0]!=null){
     photo = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photo_reference="+snapshot.data![index]["photos"][0]["photo_reference"]+"&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";}

                                return Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: ClipRRect(borderRadius: BorderRadius.circular(5),child:Container(height: height*0.45,
                                 child: Stack(
                                   children: [
                                     Container(height: height*0.45,width: width,decoration: BoxDecoration(
                                       //  color: Colors.redAccent,
                                       gradient: LinearGradient(
                                         begin: Alignment.bottomCenter,
                                         end: Alignment.topCenter,
                                         colors: [
                                           Colors.black,
                                           Colors.transparent,
                                           Colors.transparent,
                                         ],
                                       ),
                                     ),),
                                     photo.length>0?Image.network(photo,fit: BoxFit.cover,height: height*0.45 ,width: width,):Container(height: 0,width: 0,),
                                     Align(alignment: Alignment.bottomLeft,child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child:  Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(snapshot.data![index]["name"],style: TextStyle(color: Colors.white),),
                                           RatingBar.builder(
                                             initialRating: double.parse(snapshot.data![index]["rating"].toString()),
                                             minRating: double.parse(snapshot.data![index]["rating"].toString()),maxRating: double.parse(snapshot.data![index]["rating"].toString()),
                                             direction: Axis.horizontal,
                                             allowHalfRating: true,
                                             itemCount: 5,
                                             itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                             itemBuilder: (context, _) => Icon(
                                               Icons.star,size: 12,
                                               color: Colors.amber,
                                             ),
                                             onRatingUpdate: (rating) {
                                               print(rating);
                                             },
                                           ),
                                         ],
                                       ),
                                     ),),


                                   ],
                                 ),
                               ) ,),
                             );

                           },
                         );
                       }else{
                         return Scaffold(body: Center(child: Text("No Data")),);
                       }

                     },
                   ) ,))));

             },
               child: Container(width: 150,height: 100,
                 child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Container(height: 40,width: 40,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey),),
                     Padding(
                       padding: const EdgeInsets.only(top: 8),
                       child: Text(nearbySearch[index]["name"].toString().replaceAll("_", " ").toUpperCase()),
                     ),
                   ],
                 ),),
             );
           },
         ),),

          Container(height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(children: [
                Align(alignment: Alignment.centerLeft,child: Text("Recent Story",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),),
                Align(alignment: Alignment.centerRight,child: Text("See all",style: TextStyle(color: Colors.blue),),),
              ],),
            ),
          ),
          contentList,
        ],
      ),
    ),),
  );
  // return  StreamBuilder<User?>(
  //     stream: FirebaseAuth.instance.userChanges(),
  //     builder: (BuildContext context, AsyncSnapshot<User?> snapshot,) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.connectionState == ConnectionState.active
  //           || snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.hasError) {
  //           return const Text('Error');
  //         } else   if (snapshot.hasData && snapshot.data!.uid!=null){
  //           print(snapshot.data!);
  //           return   Scaffold(
  //             appBar: AppBar(elevation: 1,iconTheme: IconThemeData(
  //                 color: buttonColor
  //             ),backgroundColor: Colors.white,leading:IconButton(onPressed: () async {
  //
  //               FirebaseAuth auth = FirebaseAuth.instance;
  //
  //
  //
  //                 if(auth.currentUser!=null && auth.currentUser!.uid!=null){
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => NewPostCreateActivity()),
  //                   );
  //
  //
  //                 }else{
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) {
  //                       String contentText = "Content of Dialog";
  //                       Uint8List? photo;
  //                       return StatefulBuilder(
  //                         builder: (context, setState) {
  //                           return Dialog(child: Container(width: 400,child: Wrap(children: [
  //                             Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
  //                               Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
  //                                 Navigator.pop(context);
  //                               },icon: Icon(Icons.close,color:iconColorLight,),),),
  //                               Align(alignment: Alignment.centerLeft,child: Padding(
  //                                 padding: const EdgeInsets.only(left: 15),
  //                                 child: Text("Login or Signup",style: TextStyle(color: Colors.white),),
  //                               ),),
  //
  //                             ],)),
  //
  //
  //
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: InkWell(onTap: () async {
  //
  //                                 showDialog(
  //                                   context: context,
  //                                   builder: (context) {
  //                                     String contentText = "Content of Dialog";
  //                                     Uint8List? photo;
  //                                     String displayName = "";
  //                                     String email = "";
  //                                     String password = "";
  //                                     return StatefulBuilder(
  //                                       builder: (context, setState) {
  //                                         return Dialog(child: Container(width: 400,child: Wrap(children: [
  //                                           Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
  //                                             Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
  //                                               Navigator.pop(context);
  //                                             },icon: Icon(Icons.close,color:iconColorLight,),),),
  //                                             Align(alignment: Alignment.centerLeft,child: Padding(
  //                                               padding: const EdgeInsets.only(left: 15),
  //                                               child: Text("Create new account",style: TextStyle(color: Colors.white),),
  //                                             ),),
  //
  //                                           ],)),
  //                                           ListTile(title: Text(displayName),subtitle: Text(email),leading: photo!=null?InkWell(onTap: () async {
  //                                             Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
  //                                             print(photoMetaData);
  //                                             setState(() {
  //                                               photo = photoMetaData;
  //                                             });
  //                                           },child: CircleAvatar(backgroundImage: MemoryImage(photo!),)):InkWell( onTap: () async {
  //
  //                                           },child: IconButton(onPressed: () async {
  //                                             Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
  //                                             print(photoMetaData);
  //                                             setState(() {
  //                                               photo = photoMetaData;
  //                                             });
  //                                           },icon:Icon(Icons.account_circle_outlined))),),
  //                                           Divider(),
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                             child: TextFormField(onChanged: (val){
  //                                               setState(() {
  //                                                 displayName = val;
  //                                               });
  //                                             },decoration: InputDecoration(border: null,hintText: "Display name",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
  //                                           ),
  //
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                             child: TextFormField(onChanged: (val){
  //                                               setState(() {
  //                                                 email = val;
  //                                               });
  //                                             },decoration: InputDecoration(border: null,hintText: "Email",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
  //                                           ),
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                             child: TextFormField(onChanged: (val){
  //                                               setState(() {
  //                                                 password = val;
  //                                               });
  //                                             },decoration: InputDecoration(border: null,hintText: "Password",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
  //                                           ),
  //                                           InkWell(onTap: (){
  //                                             FirebaseFirestore firestore =  FirebaseFirestore.instance;
  //                                             FirebaseAuth auth =  FirebaseAuth.instance;
  //                                             if(photo!=null){
  //                                               String fileName = "tourApp"+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
  //
  //                                               // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
  //                                               //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
  //                                               firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
  //                                               ref.putData(photo!).then((p0) {
  //                                                 ref.getDownloadURL().then((valuePhotoLink) {
  //                                                   auth.createUserWithEmailAndPassword(email: email, password: password).then((value){
  //                                                     auth.currentUser!.updatePhotoURL(valuePhotoLink);
  //                                                     auth.currentUser!.updateDisplayName(displayName);
  //
  //
  //                                                     firestore.collection("users").add({ "email":auth.currentUser!.email,"displayName":displayName,"uid":auth.currentUser!.uid,"photo":valuePhotoLink}).then((value) {
  //                                                       Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
  //                                                     });
  //
  //                                                   });
  //
  //
  //
  //
  //                                                 });
  //                                               });
  //                                             }
  //
  //
  //                                           },
  //                                             child: Container(height: 50,width: 200,margin: EdgeInsets.all(5),decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
  //                                               padding: const EdgeInsets.all(8.0),
  //                                               child: Text("Create Account",style:TextStyle(color: Colors.white) ,),
  //                                             )),),
  //                                           )
  //
  //
  //                                         ],),),);
  //                                       },
  //                                     );
  //                                   },
  //                                 );
  //
  //                                 // FileUploader().uploadPhoto(image: photoMetaData);
  //                               },
  //                                 child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text("Create Account",style:TextStyle(color: Colors.white) ,),
  //                                 )),),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: InkWell(onTap: () async {
  //
  //                                 Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
  //                                 print(photoMetaData);
  //                                 setState(() {
  //                                   photo = photoMetaData;
  //                                 });
  //
  //                                 // FileUploader().uploadPhoto(image: photoMetaData);
  //                               },
  //                                 child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text("Login",style:TextStyle(color: Colors.white) ,),
  //                                 )),),
  //                               ),
  //                             ),
  //                           ],),),);
  //                         },
  //                       );
  //                     },
  //                   );
  //                 }
  //
  //
  //
  //
  //               // showDialog(
  //               //     context: context,
  //               //     builder: (context) {
  //               //       return Dialog(child: Container(width: 400,child: Wrap(children: [
  //               //         Container(height: 50,child: Stack(children: [
  //               //           Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
  //               //             Navigator.pop(context);
  //               //           },icon: Icon(Icons.close),),),
  //               //           Align(alignment: Alignment.centerLeft,child: Text("Login"),),
  //               //
  //               //         ],)),
  //               //         Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
  //               //           padding: const EdgeInsets.all(8.0),
  //               //           child: Text("Login / Signup",style:TextStyle(color: Colors.white) ,),
  //               //         )),),
  //               //         InkWell(onTap: () async {
  //               //
  //               // Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
  //               // print(photoMetaData);
  //               // FileUploader().uploadPhoto(image: photoMetaData);
  //               //         },
  //               //           child: Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
  //               //             padding: const EdgeInsets.all(8.0),
  //               //             child: Text("Proceed annonymus",style:TextStyle(color: Colors.white) ,),
  //               //           )),),
  //               //         ),
  //               //       ],),),);
  //               //     });
  //
  //
  //
  //
  //             },icon:Icon( Icons.camera_alt_outlined),) ,title: Text("We Tour",style: TextStyle(color: buttonColor,fontSize: height*0.018),) ,centerTitle: true,actions: [
  //               IconButton(onPressed: (){
  //
  //               },icon:CircleAvatar(
  //                backgroundImage: NetworkImage(snapshot.data!.photoURL!),
  //               ),)
  //             ],),
  //
  //             body: Center(
  //               child: Container(width:width>500?500:width ,decoration: BoxDecoration(
  //
  //                 //border: Border.all(color: width>500?Colors.black:Colors.white,width: 1)
  //               ),
  //                 child: contentList,
  //               ),
  //             ),
  //             bottomNavigationBar: Container(color: Colors.white,width: double.infinity,height:  ( height*0.06),
  //               child: Row(children: [
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.home),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.search),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.add_photo_alternate_sharp),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.thumb_up_alt_rounded),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.account_circle_outlined),)),
  //               ],),
  //             ),
  //           );
  //         }else{
  //           return  Scaffold(
  //             appBar: AppBar(elevation: 1,iconTheme: IconThemeData(
  //                 color: buttonColor
  //             ),backgroundColor: Colors.white,leading:IconButton(onPressed: () async {
  //
  //               FirebaseAuth auth = FirebaseAuth.instance;
  //               showDialog(
  //                   context: context,
  //                   builder: (BuildContext context) => CupertinoAlertDialog(
  //                     title: new Text("Login/Signup require"),
  //                    // content: new Text("This is my content"),
  //                     actions: <Widget>[
  //                       CupertinoDialogAction(onPressed: (){
  //                         String email = "";
  //                         String password = "";
  //
  //
  //                         showDialog(
  //                             context: context,
  //                             builder: (BuildContext context) => CupertinoAlertDialog(
  //                               title: new Text("Login"),
  //                                content:  Container(child:
  //
  //                                Wrap(children: [
  //
  //
  //                                  Padding(
  //                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
  //                                    child: CupertinoTextField(style: TextStyle(fontSize: 16),padding: EdgeInsets.all(8),onChanged: (val){
  //                                      setState(() {
  //                                        email = val;
  //                                      });
  //                                    },
  //
  //                                      placeholder: 'Email',
  //
  //                                    ),
  //                                  ),
  //                                  Padding(
  //                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
  //                                    child: CupertinoTextField(style: TextStyle(fontSize: 16),padding: EdgeInsets.all(8),onChanged: (val){
  //                                      setState(() {
  //                                        password = val;
  //                                      });
  //                                    },
  //
  //                                      placeholder: 'Password',
  //
  //                                    ),
  //                                  ),
  //
  //
  //
  //
  //                                  // Padding(
  //                                  //   padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                  //   child: TextFormField(onChanged: (val){
  //                                  //     setState(() {
  //                                  //       email = val;
  //                                  //     });
  //                                  //   },decoration: InputDecoration(border: null,hintText: "Email",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
  //                                  // ),
  //                                  // Padding(
  //                                  //   padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                  //   child: TextFormField(onChanged: (val){
  //                                  //     setState(() {
  //                                  //       password = val;
  //                                  //     });
  //                                  //   },decoration: InputDecoration(border: null,hintText: "Password",fillColor: lightGrey,filled: true,contentPadding: EdgeInsets.all(10),),),
  //                                  // ),
  //
  //
  //
  //
  //
  //                                ],),),
  //                               actions: <Widget>[
  //                                 CupertinoDialogAction(onPressed: (){
  //                                   FirebaseFirestore firestore =  FirebaseFirestore.instance;
  //                                   FirebaseAuth auth =  FirebaseAuth.instance;
  //
  //                                   auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
  //                                     //navigate to first screen
  //                                     Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
  //
  //                                   });
  //                                 },
  //                                   isDefaultAction: true,
  //                                   child: Text("Login"),
  //                                 ),
  //
  //                               ],
  //                             )
  //                         );
  //
  //
  //
  //
  //                       },
  //                         isDefaultAction: true,
  //                         child: Text("Login"),
  //                       ),
  //                       CupertinoDialogAction(onPressed: (){
  //
  //
  //
  //
  //                         showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             String contentText = "Content of Dialog";
  //                             Uint8List? photo;
  //                             String displayName = "";
  //                             String email = "";
  //                             String password = "";
  //                             return StatefulBuilder(
  //                               builder: (context, setState) {
  //                                 return  CupertinoAlertDialog(
  //
  //                                   title: new Text("Signup"),
  //                                   content:  Container(child:
  //
  //                                   Wrap(children: [
  //
  //                                     Row(
  //                                       children: [
  //                                         CupertinoButton(child:  photo!=null? CircleAvatar(backgroundImage: MemoryImage(photo!),):Icon(CupertinoIcons.photo), onPressed: () async {
  //                                           Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
  //                                           print(photoMetaData);
  //                                           setState(() {
  //                                             photo = photoMetaData;
  //                                           });
  //                                         }),
  //
  //
  //                                         Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
  //                                           children: [
  //                                             Text(displayName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
  //                                             Text(email)
  //
  //                                           ],
  //                                         )
  //
  //                                       ],
  //                                     ),
  //
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                       child: CupertinoTextField(placeholder:"Display name" ,onChanged: (val){
  //                                         setState(() {
  //                                           displayName = val;
  //                                         });
  //                                       },
  //                                       ),
  //                                     ),
  //
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                       child: CupertinoTextField(placeholder:  "Email",onChanged: (val){
  //                                         setState(() {
  //                                           email = val;
  //                                         });
  //                                       },),
  //                                     ),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
  //                                       child: CupertinoTextField(placeholder:  "Password",onChanged: (val){
  //                                         setState(() {
  //                                           password = val;
  //                                         });
  //                                       },),
  //                                     ),
  //
  //
  //
  //
  //
  //
  //
  //                                   ],),),
  //                                   actions: <Widget>[
  //                                     CupertinoDialogAction(onPressed: (){
  //                                       FirebaseFirestore firestore =  FirebaseFirestore.instance;
  //                                       FirebaseAuth auth =  FirebaseAuth.instance;
  //                                       if(photo!=null){
  //                                         String fileName = "tourApp"+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
  //
  //                                         // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
  //                                         //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
  //                                         firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
  //                                         ref.putData(photo!).then((p0) {
  //                                           ref.getDownloadURL().then((valuePhotoLink) {
  //                                             auth.createUserWithEmailAndPassword(email: email, password: password).then((value){
  //                                               auth.currentUser!.updatePhotoURL(valuePhotoLink);
  //                                               auth.currentUser!.updateDisplayName(displayName);
  //
  //
  //                                               firestore.collection("users").add({ "email":auth.currentUser!.email,"displayName":displayName,"uid":auth.currentUser!.uid,"photo":valuePhotoLink}).then((value) {
  //                                                 Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
  //                                               });
  //
  //                                             });
  //
  //
  //
  //
  //                                           });
  //                                         });
  //                                       }
  //                                     },
  //                                       isDefaultAction: true,
  //                                       child: Text("Create"),
  //                                     ),
  //
  //                                   ],
  //                                 );
  //                               },
  //                             );
  //                           },
  //                         );
  //                       },
  //                         child: Text("Signup"),
  //                       )
  //                     ],
  //                   )
  //               );
  //
  //               // showDialog(
  //               //   context: context,
  //               //   builder: (context) {
  //               //     String contentText = "Content of Dialog";
  //               //     Uint8List? photo;
  //               //     return StatefulBuilder(
  //               //       builder: (context, setState) {
  //               //
  //               //
  //               //         return Dialog(child: Container(width: 400,child: Wrap(children: [
  //               //           Container(color: buttonTopBarColors,height: 50,child: Stack(children: [
  //               //             Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
  //               //               Navigator.pop(context);
  //               //             },icon: Icon(Icons.close,color:iconColorLight,),),),
  //               //             Align(alignment: Alignment.centerLeft,child: Padding(
  //               //               padding: const EdgeInsets.only(left: 15),
  //               //               child: Text("Login or Signup",style: TextStyle(color: Colors.white),),
  //               //             ),),
  //               //
  //               //           ],)),
  //               //
  //               //
  //               //
  //               //           Padding(
  //               //             padding: const EdgeInsets.all(8.0),
  //               //             child: InkWell(onTap: () async {
  //               //
  //               //
  //               //
  //               //               // FileUploader().uploadPhoto(image: photoMetaData);
  //               //             },
  //               //               child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
  //               //                 padding: const EdgeInsets.all(8.0),
  //               //                 child: Text("Create Account",style:TextStyle(color: Colors.white) ,),
  //               //               )),),
  //               //             ),
  //               //           ),
  //               //           Padding(
  //               //             padding: const EdgeInsets.all(8.0),
  //               //             child: InkWell(onTap: () async {
  //               //
  //               //
  //               //
  //               //
  //               //               // FileUploader().uploadPhoto(image: photoMetaData);
  //               //             },
  //               //               child: Container(margin: EdgeInsets.all(5),width: 200,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(0)),child: Center(child: Padding(
  //               //                 padding: const EdgeInsets.all(8.0),
  //               //                 child: Text("Login",style:TextStyle(color: Colors.white) ,),
  //               //               )),),
  //               //             ),
  //               //           ),
  //               //         ],),),);
  //               //       },
  //               //     );
  //               //   },
  //               // );
  //               //
  //               //
  //               //
  //               //
  //               // showDialog(
  //               //     context: context,
  //               //     builder: (context) {
  //               //       return Dialog(child: Container(width: 400,child: Wrap(children: [
  //               //         Container(height: 50,child: Stack(children: [
  //               //           Align(alignment: Alignment.centerRight,child: IconButton(onPressed: (){
  //               //             Navigator.pop(context);
  //               //           },icon: Icon(Icons.close),),),
  //               //           Align(alignment: Alignment.centerLeft,child: Text("Login"),),
  //               //
  //               //         ],)),
  //               //         Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
  //               //           padding: const EdgeInsets.all(8.0),
  //               //           child: Text("Login / Signup",style:TextStyle(color: Colors.white) ,),
  //               //         )),),
  //               //         InkWell(onTap: () async {
  //               //
  //               // Uint8List photoMetaData = await ImagePickerWeb.getImage(outputType: ImageType.bytes) as Uint8List;
  //               // print(photoMetaData);
  //               // FileUploader().uploadPhoto(image: photoMetaData);
  //               //         },
  //               //           child: Container(margin: EdgeInsets.all(5),width: double.infinity,decoration: BoxDecoration(color: buttonColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
  //               //             padding: const EdgeInsets.all(8.0),
  //               //             child: Text("Proceed annonymus",style:TextStyle(color: Colors.white) ,),
  //               //           )),),
  //               //         ),
  //               //       ],),),);
  //               //     });
  //
  //
  //
  //
  //             },icon:Icon( Icons.camera_alt_outlined),) ,title: Text("We Tour",style: TextStyle(color: buttonColor,fontSize: height*0.018),) ,centerTitle: true,actions: [
  //               IconButton(onPressed: (){
  //
  //               },icon:CircleAvatar(),)
  //             ],),
  //
  //             body: Center(
  //               child: Container(width:width>500?500:width ,decoration: BoxDecoration(
  //
  //                 //border: Border.all(color: width>500?Colors.black:Colors.white,width: 1)
  //               ),
  //                 child:contentList
  //               ),
  //             ),
  //             bottomNavigationBar: Container(color: Colors.white,width: double.infinity,height:  ( height*0.06),
  //               child: Row(children: [
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.home),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.search),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.add_photo_alternate_sharp),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.thumb_up_alt_rounded),)),
  //                 Expanded(child: IconButton(onPressed: (){},icon: Icon(Icons.account_circle_outlined),)),
  //               ],),
  //             ),
  //           );
  //         }
  //       } else {
  //         return Text('State: ${snapshot.connectionState}');
  //       }
  //     },
  //   );

  }

 Widget convertDateTime(param0) {
  return   Text( DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(param0)) );


  }
}
class NewPostCreateActivity extends StatefulWidget {


  @override
  _NewPostCreateActivityState createState() => _NewPostCreateActivityState();
}

class _NewPostCreateActivityState extends State<NewPostCreateActivity> {
  String placeId = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
   Uint8List? photo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(elevation: 1,backgroundColor: Colors.white, iconTheme: IconThemeData(
        color: Colors.blue
    ),title: Text("Make new post",style: TextStyle(color: Colors.blue),),),


      body:  SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [








        InkWell(onTap: () async {

          final sessionToken = Uuid().v4();
          final Suggestion? result = await showSearch(
            context: context,
            delegate: AddressSearch(sessionToken),
          );
          // This will change the text displayed in the TextField
          if (result != null) {
            final placeDetails = await PlaceApiProvider(sessionToken)
                .getPlaceDetailFromId(result.placeId);
            print(result.description);
            placeId = result.placeId;
            controllerAddress.text= result.description;
            // setState(() {
            //   _controller.text = result.description;
            //   _streetNumber = placeDetails.streetNumber;
            //   _street = placeDetails.street;
            //   _city = placeDetails.city;
            //   _zipCode = placeDetails.zipCode;
            // });
          }
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SearchAddress()),
          // );
        },
          child: Padding(
            padding: const EdgeInsets.only(top: 20,left: 5,right: 5),
            child: TextFormField(enabled: false,controller: controllerAddress,decoration: InputDecoration( border: InputBorder.none,hintText:"Location/Spot" ,filled: true,fillColor: lightGrey,contentPadding: EdgeInsets.all(10),),),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
          child: TextFormField(minLines: 3,maxLines: 5,controller: controllerDescription,decoration: InputDecoration( border: InputBorder.none,hintText: "Description",filled: true,fillColor: lightGrey,contentPadding: EdgeInsets.all(10),),),
        ),

        SizedBox(height: 15,),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: InkWell(onTap: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

              Uint8List photoMetaData =await image!.readAsBytes();
              print(photoMetaData);
              setState(() {
                photo = photoMetaData;
              });
            },
              child: Container(
                child: photo!=null? Container(height: 300,child: Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.memory(photo!),
                ),)):Image.asset("assets/add-image.png"),
              ),
            ),
          ),
        ),






          photo!=null?  Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 8,bottom: 8),
            child: CupertinoButton(color: Colors.blue,child: Center(child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("Submit"),
        ),), onPressed: (){
            if(photo!=null){
              String fileName = "tourApp"+"/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

              // String fileName = firestore.app.options.projectId+"/"+testId+"/"+i.toString()+".mp4";
              //firebase_storage.FirebaseStorage storage = await initCustomerFireStorage(firestore.app.options.projectId);
              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
              ref.putData(photo!).then((p0) {
                ref.getDownloadURL().then((valuePhotoLink) {
                  FirebaseFirestore  firestore=   FirebaseFirestore.instance ;
                  firestore.collection("forumPost").add({"placeId":placeId,"time":DateTime.now().millisecondsSinceEpoch,"photo":valuePhotoLink, "uid":auth.currentUser!.uid,"location":controllerAddress.text,"description":controllerDescription.text}).then((value) {

                  });




                });
              });
              Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
            }

        }),
          ):Container(width: 0,height: 0,),

    ],),
      ),);
  }
}

class SearchAddress extends StatefulWidget {


  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  final _controller = TextEditingController();
  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              readOnly: true,
              onTap: () async {
                // generate a new token here
                final sessionToken = Uuid().v4();
                final Suggestion? result = await showSearch(
                  context: context,
                  delegate: AddressSearch(sessionToken),
                );
                // This will change the text displayed in the TextField
                if (result != null) {
                  final placeDetails = await PlaceApiProvider(sessionToken)
                      .getPlaceDetailFromId(result.placeId);
                  setState(() {
                    _controller.text = result.description;
                    _streetNumber = placeDetails.streetNumber;
                    _street = placeDetails.street;
                    _city = placeDetails.city;
                    _zipCode = placeDetails.zipCode;
                  });
                }
              },
              decoration: InputDecoration(
                icon: Container(
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                ),
                hintText: "Enter your shipping address",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
              ),
            ),
            SizedBox(height: 20.0),
            Text('Street Number: $_streetNumber'),
            Text('Street: $_street'),
            Text('City: $_city'),
            Text('ZIP Code: $_zipCode'),
          ],
        ),
      ),
    );
  }
}
