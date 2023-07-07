import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'ChatMessage.dart';
import 'ThreeDots.dart';

class AIBOT extends StatefulWidget {
  const AIBOT({super.key});

  @override
  State<AIBOT> createState() => _AIBOTState();
}

class _AIBOTState extends State<AIBOT> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;
  bool isTyping = false;

  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: "user");

    setState(() {
      _messages.insert(0, message);
      isTyping = true;
    });
    _controller.clear();

    final request = CompleteReq(
        prompt: message.text, model: kTranslateModelV3, max_tokens: 200);

    _subscription = chatGPT!
        .builder("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")
        .onCompleteStream(request: request)
        .timeout(const Duration(seconds: 30))
        .handleError((error) {
      print("Rutvik Patel");
    }).listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: response.choices[0].text, sender: "bot");

      setState(() {
        isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          onSubmitted: (value) => _sendMessage(),
          controller: _controller,
          decoration: InputDecoration.collapsed(hintText: "Send a Message"),
        )),
        IconButton(
            onPressed: () => _sendMessage(), icon: const Icon(Icons.send))
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(9, 26, 46, 1),
          shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
          title: const Text(
            "Chat With BOT",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                      reverse: true,
                      padding: Vx.m8,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _messages[index];
                      })),
              if (isTyping) const ThreeDots(),
              Divider(height: 1.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: _buildTextComposer(),
                ),
              )
            ],
          ),
        ));
  }
}
