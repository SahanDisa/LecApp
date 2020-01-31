// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
      return MaterialApp(

        home: Voicehome(),
      );
  }
}
class Voicehome extends StatefulWidget{
  @override
  _VoicehomeState createState() => _VoicehomeState();
}

class _VoicehomeState extends State<Voicehome> {

  SpeechRecognition _speechRecognition;
  bool _isAvaliable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState(){
    super.initState();
  }

  void initSpeechRecognizer(){
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
            (bool result) => setState(()=>_isAvaliable = result)
    );
    _speechRecognition.setRecognitionStartedHandler(
          ()=> setState(()=>_isListening = true),

    );
    _speechRecognition.setRecognitionResultHandler(
          (String speech)=> setState(()=>resultText = speech),
    );
    _speechRecognition.setRecognitionCompleteHandler(
            ()=>setState(()=>_isListening = false)
    );
    _speechRecognition.activate().then(
            (result)=> setState(()=>_isAvaliable = result)
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
//    key: scaffoldKey,
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('LetMeNote App'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){},
        ),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_alert),
            tooltip: 'Show Notification',
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            tooltip: 'Close recording',
            onPressed: (){
                Navigator.pop(context);
            },
          ),

        ],
      ),
      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition.cancel().then(
                            (result)=>setState((){
                          _isListening = result;
                          resultText = "";
                        }),
                      );
                    }
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  onPressed: (){
                    if(_isAvaliable && !_isListening){
                      _speechRecognition
                          .listen(locale: "en_US")
                          .then((result)=>print('$result'));
                    }
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition
                          .stop()
                          .then((result)=>setState(()=>_isListening=result),
                      );
                    }
                  },
                )
              ],
            ),

            Container(
              width: MediaQuery.of(context).size.width *0.6,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),

              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,

              ),
              child: Text(resultText),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Show Me",
        mini: false,
        backgroundColor: Colors.amber[900],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[800],
        currentIndex: 0,
        onTap: (i) {},
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            title: Text('Add peers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('My History'),
          ),
        ],

      ),
    );
  }
}
