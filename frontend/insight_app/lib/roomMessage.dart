import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight_app/api.dart';
import 'package:insight_app/functions.dart';
import 'dart:convert';
import 'dart:io';


class RoomMessage extends StatefulWidget {
  RoomMessage({Key? key, required this.roomMember}) : super(key: key);
  Map roomMember;

  @override
  State<RoomMessage> createState() => _RoomMessageState();
}

class _RoomMessageState extends State<RoomMessage> {
  List messages = [];
  bool updating = false;
  TextEditingController msg = TextEditingController();
  File? _image;
  int updateKey = -1;
  FocusNode myFocusNode = FocusNode();
  bool deleting = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoomMessages(widget.roomMember["group_room"]["id"]).then((value) {
      print(value);
      setState(() {
        messages = jsonDecode(value);
      });;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text("Room Message",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          messages.length == 0 ?
          const Expanded(
            child: Center(child: Text("It seems you do not have any messages"),
            ),
          ) :
          Expanded(child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network("$image_url${messages[index]['owner']["member"]["profile"]['picture']}",
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          )
                      ),
                      SizedBox(width: 15.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(messages[index]['owner']["member"]["profile"]["user"]["username"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0
                            ),
                          ),
                          Text("${messages[index]['date_sent'].toString().substring(0, 10)} ${messages[index]['date_sent'].toString().substring(12, 16)}",
                            style: const TextStyle(
                                color: Colors.grey
                            ),
                          ),
                          const SizedBox(height: 5.0,),
                          Text(messages[index]["content"]),
                          messages[index]["image"] == null ? Container() : Image.network(
                            "$image_url${messages[index]["image"]}",
                            width: 200.0,
                          ),
                          Row(
                            children: [
                              messages[index]["owner"]["id"] == widget.roomMember["id"] ?
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updating=true;
                                    msg.text=messages[index]["content"];
                                    updateKey=messages[index]["id"];
                                  });
                                  myFocusNode.requestFocus();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: const Text("Edit",
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),
                                  ),
                                ),
                              ) : Container(),
                              messages[index]["owner"]["id"] == widget.roomMember["id"] ? const SizedBox(width: 10.0,) : Container(),
                              messages[index]["owner"]["id"] == widget.roomMember["id"] ?
                              GestureDetector(
                                onTap: () {
                                  deleting ? const CircularProgressIndicator() : showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Delete Message"),
                                          content: const Text("Are you sure you want to delete this message"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deleting = true;
                                                  });
                                                  // deleteComment(posts[index]["id"]).then((value) {
                                                  //   getPosts(widget.profile["id"]).then((value) {
                                                  //     setState(() {
                                                  //       posts = jsonDecode(value);
                                                  //       deleting = false;
                                                  //     });
                                                  //     Navigator.pop(context);
                                                  //   });
                                                  // });
                                                  // deleteMessage(messages[index]["id"]).then((value) {
                                                  //   getMessages(widget.profile["id"], widget.friend["friend_2"]["id"]).then((value) {
                                                  //     setState(() {
                                                  //       messages = jsonDecode(value);
                                                  //     });
                                                  //     Navigator.pop(context);
                                                  //   });
                                                  // });
                                                  deleteRoomMessage(messages[index]["id"]).then((value) {
                                                    getRoomMessages(widget.roomMember["group_room"]["id"]).then((value) {
                                                      setState(() {
                                                        messages=jsonDecode(value);
                                                      });
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                },
                                                child: const Text("Yes")
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel")
                                            )
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: const Text("Delete",
                                    style: TextStyle(
                                        color: Colors.red
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          )

                        ],
                      )
                    ],
                  ),
                );
              }
          )
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    var currentImage = await getImage(ImageSource.gallery);
                    setState(() {
                      _image=File(currentImage);
                    });
                  },
                  icon: _image == null ? const Icon(Icons.photo) : const Icon(Icons.photo, color: Colors.blue)
              ),
              IconButton(
                  onPressed: () async {
                    var currentImage = await getImage(ImageSource.camera);
                    setState(() {
                      _image=File(currentImage);
                    });
                  },
                  icon: _image == null ? const Icon(Icons.camera_alt) : const Icon(Icons.camera_alt, color: Colors.blue)
              ),
              Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width*0.6,
                child: TextField(
                  controller: msg,
                  focusNode: myFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: "Username",
                      labelText: "Add Message"
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if(updating == false) {
                      print("Not updating");
                      if(msg.text.isNotEmpty) {

                        if(_image == null) {
                          postRoomMessages({"owner_id": widget.roomMember["id"], "room_id": widget.roomMember["group_room"]["id"], "content": msg.text}).then((value) {
                            getRoomMessages(widget.roomMember["group_room"]["id"]).then((value) {
                              setState(() {
                                messages=jsonDecode(value);
                              });
                            });
                          });
                          msg.clear();
                          FocusScope.of(context).unfocus();
                        } else {

                          postRoomMessages({"owner_id": widget.roomMember["id"], "room_id": widget.roomMember["group_room"]["id"], "content": msg.text, "image": _image!.path}).then((value) {
                            getRoomMessages(widget.roomMember["group_room"]["id"]).then((value) {
                              setState(() {
                                messages=jsonDecode(value);
                                _image = null;
                              });
                            });
                          });
                          msg.clear();
                          FocusScope.of(context).unfocus();
                      }
                    }
                    } else {
                      if(msg.text.isNotEmpty) {
                        // updateMessage(updateKey, {"owner_id": widget.profile["id"], "recipient_id": widget.friend["friend_2"]["id"], "content": msg.text}).then((value) {
                        //   getMessages(widget.profile["id"], widget.friend["friend_2"]["id"]).then((value) {
                        //     setState(() {
                        //       messages = jsonDecode(value);
                        //     });
                        //   });
                        // });
                        updateRoomMessage(updateKey, {"content": msg.text}).then((value) {
                          getRoomMessages(widget.roomMember["group_room"]["id"]).then((value) {
                            setState(() {
                              messages=jsonDecode(value);
                            });
                          });
                        });
                        msg.clear();
                        FocusScope.of(context).unfocus();
                      }
                    }

                  },
                  icon: const Icon(Icons.send)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
