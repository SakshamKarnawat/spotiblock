import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _controller;
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  final _list = List<String>.empty(growable: true);
  String _status = 'Stopped';

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _textController = TextEditingController(text: 'AP Dhillon - Excuses');
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      // setState(() {
      //   _loading = true;
      // });
      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: dotenv.env['SPOTIFY_CLIENT_ID'].toString(),
        redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
      );
      _status = result
          ? 'connect to spotify successful'
          : 'connect to spotify failed';
      // setState(() {
      //   _loading = false;
      // });
    } on PlatformException catch (e) {
      /* setState(() {
        _loading = false;
      }); */
      _status = e.code.toString() + e.message.toString();
    } on MissingPluginException {
      // setState(() {
      //   _loading = false;
      // });
      _status = 'not implemented';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              hintText: 'AP Dhillon - Excuses',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_textController.text.trim().isNotEmpty) {
                  _list.add(_textController.text.trim());
                  _focusNode.unfocus();
                  _textController.clear();
                }
              });
            },
            child: const Text('Add to blocklist'),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_list[index]),
                  value: _list[index].isNotEmpty,
                  onChanged: (val) {
                    setState(() {
                      _list.removeAt(index);
                      if (_list.isEmpty) {
                        _textController.text = 'AP Dhillon - Excuses';
                      }
                    });
                  },
                );
              },
              itemCount: _list.length,
            ),
          ),
          ElevatedButton(
            onPressed: connectToSpotifyRemote,
            child: const Text('Connect to Spotify'),
          ),
          Text('Status: $_status'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.skip_previous),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.play_arrow),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
