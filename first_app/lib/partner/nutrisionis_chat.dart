import 'package:first_app/customer/edukasi_show.dart';
import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// Simple preloader inside a Center widget
const preloader =
    Center(child: CircularProgressIndicator(color: Colors.orange));

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

class Message {
  Message(
      {required this.id,
      required this.uid,
      required this.content,
      required this.createdAt,
      required this.sender_id});

  /// ID of the message
  final int id;

  /// ID of the user who posted the message
  final String uid;
  final int sender_id;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime createdAt;

  Message.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        uid = map['uid'],
        sender_id = map['sender_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']);
}

class NutrisionisChat extends StatefulWidget {
  const NutrisionisChat({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => NutrisionisChat());
  }

  @override
  State<StatefulWidget> createState() {
    return _NutrisionisChat();
  }
}

class _NutrisionisChat extends State<NutrisionisChat> {
  //late final Stream<List<Message>> _messagesStream;
  //final Map<int, Nutrisionis> _profileCache = {};
  int _senderId = 0;
  //int nid = 0;

  @override
  void initState() {
    super.initState();
  }

/*
  Future<void> _loadProfileCache(int profileId) async {
    if (_profileCache[profileId] != null) {
      return;
    }
    final data =
        await supabase.from('users').select().eq('id', profileId).single();
    final profile = Nutrisionis.fromMap(data);
    setState(() {
      _profileCache[profileId] = profile;
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final int nid = arg["customer_id"];
    final int nid2 = arg["nutrisionis_id"];
    _senderId = nid2;
    final uid = "$nid.$nid2";
    log("$uid");
    late final Stream<List<Message>> _messagesStream = supabase
        .from('konsultasi')
        .stream(primaryKey: ['id'])
        .eq('uid', uid)
        //.eq('nutrisionis_id', _senderId)
        .order('created_at')
        .map((maps) => maps.map((map) => Message.fromMap(map: map)).toList());
    return Scaffold(
        backgroundColor: Color(0xFF2B9EA4),
        appBar: LayoutCustomerAppBar(
            title: Text(arg['nama'],
                style: const TextStyle(
                  fontSize: 34,
                  color: Color(0xFF2B9EA4),
                ))),
        //bottomNavigationBar: LayoutCustomerBottomNav(),
        body: StreamBuilder<List<Message>>(
          stream: _messagesStream,
          builder: (context, snapshot) {
            //if (snapshot.hasData) {
            final messages = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: messages == null
                      ? const Center(
                          child: Text('Mulai percakapan :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            //_loadProfileCache(message.nutrisionis_id);
                            //_loadSenderId();

                            return _ChatBubble(
                              message: message,
                              //profile: _profileCache[message.nutrisionis_id],
                              senderId: _senderId,
                            );
                          },
                        ),
                ),
                _MessageBar(uid: uid, senderId: _senderId),
              ],
            );
            /*} else {
              return preloader;
            }*/
          },
        ));
  }
}

class _MessageBar extends StatefulWidget {
  final String uid;
  final int senderId;
  const _MessageBar({
    Key? key,
    required this.uid,
    required this.senderId,
  }) : super(key: key);

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Ketik Pesan..',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    _submitMessage(context, widget.uid, widget.senderId),
                child: const Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage(BuildContext context, String uid, int senderId) async {
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('konsultasi').insert({
        'uid': uid,
        'sender_id': senderId,
        'content': text,
      });
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }
}

class _ChatBubble extends StatelessWidget {
  final int? senderId;

  const _ChatBubble({
    Key? key,
    required this.message,
    //required this.profile,
    required this.senderId,
  }) : super(key: key);

  final Message message;
  //final Nutrisionis? profile;

  @override
  Widget build(BuildContext context) {
    bool statIsMine = false;
    if (message.sender_id == senderId) {
      statIsMine = true;
    }
    List<Widget> chatContents = [
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: statIsMine ? Colors.white : Colors.grey[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(DateFormat.jm().format(message.createdAt)),
      const SizedBox(width: 60),
    ];
    if (statIsMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 18),
      child: Row(
        mainAxisAlignment:
            statIsMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
