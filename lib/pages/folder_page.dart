import 'package:flutter/material.dart';

class FoldersPage extends StatefulWidget {
  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(title: Text("Pdf Files"),),
      body: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
         itemBuilder: (context,index){
          return Padding(padding:const EdgeInsets.all(8.0),
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("images/pdf_logo.png",
                  height: 120,
                  width: 100,),
                  Text("Pdf Name",
                  style: TextStyle(
                    fontSize: 18
                  ),)
                ],
              ),
            ),
          ),);
          
         }),
        );
  }
}
