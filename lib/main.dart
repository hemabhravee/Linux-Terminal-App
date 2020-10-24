import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyDockerApp());
}

class MyDockerApp extends StatefulWidget {
  @override
  _MyDockerAppState createState() => _MyDockerAppState();
}

class _MyDockerAppState extends State<MyDockerApp> {
  String cmd;

  String imageName;

  bool waiting = false;

  List history = ["docker run -it centos:7"];

  int count;

  String output = "";

  List commands = [
    "docker ps",
    "docker images",
    "docker network ls",
    "docker volume ls",
    "docker inspect <enter_name>",
    "docker run -dit --name <enter_name> centos:7",
    "docker stop <enter_name>",
    "docker rm -f \$(docker ps -a -q)"
  ];

  List cmdnames = [
    "List all docker containers",
    "List all docker images",
    "List all docker networks",
    "List all docker volumes",
    "Inspect",
    "Launch new docker",
    "Stop a docker",
    "Delete all dockers"
  ];

  final myController = TextEditingController();

  var ip = "192.168.0.107";

  @override
  initState() {
    count = 0;
  }

  web() async {
    String newcmd = cmd?.replaceAll(" ", "_");

    var url = "http://$ip/cgi-bin/script.py?x=${newcmd}";
    setState(() {
      waiting = true;
      myController.text = "";
    });
    var response = await http.get(url);
    setState(() {
      waiting = false;
    });
    print(response.body);
    var temp = jsonDecode(response.body.toString());
    output = temp['output'];
    print(cmd);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Docker App"),
        ),
        body: Center(
          child: Stack(children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 350,
                    child: Flexible(
                      child: new ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Bash \$: ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (history.length - index == 1)
                                  Flexible(
                                      child: TextField(
                                    controller: myController,
                                    maxLines: null,
                                    onChanged: (value) {
                                      cmd = value;
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ))
                                else
                                  Flexible(
                                      child: Text(
                                    history[index + 1],
                                    style: TextStyle(color: Colors.white),
                                  )),
                                SizedBox(
                                  height: 25,
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 40),
                      color: Colors.grey,
                      height: 348.5,
                      width: 380,
                      child: Column(
                        children: <Widget>[
                          Text("OUTPUT"),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            height: 250,
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black, blurRadius: 20.0)
                              ],
                            ),
                            child: Flex(
                                direction: Axis.vertical,
                                children: <Widget>[
                                  Expanded(
                                      child: SingleChildScrollView(
                                          child: waiting
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Text(output == ""
                                                  ? "Enter a Command"
                                                  : output))),
                                ]),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Positioned(
              top: 344,
              left: 0,
              child: Builder(
                builder: (context) => FlatButton(
                  child: Container(
                    height: 35,
                    width: 175,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        new BoxShadow(color: Colors.black, blurRadius: 20.0)
                      ],
                    ),

                    child: Text(
                      "List of Commands",
                      style: TextStyle(color: Colors.black),
                    ),
                    //alignment: Alignment(1, 1),
                  ),
                  onPressed: () {
                    showBottomSheet(
                        backgroundColor: Colors.black,
                        context: context,
                        builder: (context) {
                          return Container(
                              alignment: Alignment(1, -1),
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue[300],
                              ),
                              //padding: EdgeInsets.only(top: 100, left: 100),
                              child: new ListView.builder(
                                  itemCount: commands.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue[700],
                                        borderRadius: BorderRadius.circular(13),
                                        boxShadow: [
                                          new BoxShadow(
                                              color: Colors.lightBlue[900],
                                              blurRadius: 20.0)
                                        ],
                                      ),
                                      child: new FlatButton(
                                        child: Text(cmdnames[index]),
                                        onPressed: () {
                                          myController.text = commands[index];
                                          cmd = myController.text;
                                        },
                                      ),
                                    );
                                  }));
                        });
                  },
                  // {
                  //   myController.text = "docker container ls";
                  // },
                ),
              ),
            ),
            Positioned(
              top: 350,
              left: 200,
              child: GestureDetector(
                onTap: () {
                  web();
                  if (cmd != null) {
                    history.add(cmd);
                    setState() {
                      count++;
                    }

                    cmd = null;
                    print(history);
                  }
                },
                child: Container(
                  // margin: EdgeInsets.only(top: 352, left: 20),
                  width: 175,
                  alignment: Alignment.center,
                  height: 35,
                  child: Text("Run"),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      new BoxShadow(color: Colors.black, blurRadius: 20.0)
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
        // floatingActionButton: Builder(builder: (context)=> FloatingActionButton(onPressed: (){
        //   showBottomSheet(
        //               context: context,
        //               builder: (context) {
        //                 return Container(
        //                   alignment: Alignment.center,
        //                   height: 300,
        //                   width: 375,
        //                   padding: EdgeInsets.only(top: 100, left: 100),
        //                   child: Text("BottomSheet"),
        //                 );
        //               });
        // },),
      ),
    );
  }
}
