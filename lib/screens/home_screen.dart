import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:at_commons/at_commons.dart';
import '../service/client_sdk_service.dart';
import 'package:intl/intl.dart';
import '../service/database.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? atSign;
  String? _date;
  String? _mood;

  // Date Variable
  DateTime _dateTime = DateTime.now();

  // lookup
  final TextEditingController? _lookupTextFieldController = TextEditingController();
  String? _lookupKey;
  String? _lookupValue;

  // scan
  List<String?> _scanItems = <String>[];

  // service
  final ClientSdkService _serverDemoService = ClientSdkService.getInstance();

  @override
  Widget build(BuildContext context) {
    String _formattedDate = new DateFormat.yMMMd().format(_dateTime);
    _openDatePicker(BuildContext context) async {
      final DateTime date = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime(2030),
      ) as DateTime;

      if(date != null) {
        setState(() {
          _dateTime = date;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
        _formattedDate,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _openDatePicker(context),
        ),


        ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //update
            Flexible(
              fit: FlexFit.loose,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.create, size: 70),
                      title: const Text(
                        'Update ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          TextField(
                            decoration: const InputDecoration(hintText: 'Enter Date'),
                            onChanged: (String date) {
                              _date = date;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter Value',
                            ),
                            onChanged: (String mood) {
                              _mood = mood;
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        onPressed: () => insert(_date!, _mood!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //scan
            Flexible(
              fit: FlexFit.loose,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.scanner, size: 70),
                      title: const Text(
                        'Scan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: DropdownButton<String>(
                        hint: const Text('Select Key'),
                        items: _scanItems.map((String? key) {
                          return DropdownMenuItem<String>(
                            value: key, //key != null ? key : null,
                            child: Text(key!),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _lookupKey = value;
                            _lookupTextFieldController!.text = value!;
                          });
                        },
                        value: _scanItems.isNotEmpty
                            ? _lookupTextFieldController!.text.isEmpty
                                ? _scanItems[0]
                                : _lookupTextFieldController!.text
                            : '',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextButton(
                        child: const Text(
                          'Scan',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(backgroundColor: Colors.deepOrange),
                        onPressed: _scan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //lookup
            Flexible(
              fit: FlexFit.loose,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.list, size: 70),
                      title: const Text(
                        'LookUp',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            decoration: const InputDecoration(hintText: 'Enter Key'),
                            controller: _lookupTextFieldController,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Lookup Result : ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _lookupValue ?? '',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextButton(
                        child: const Text(
                          'Lookup',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(backgroundColor: Colors.deepOrange),
                        onPressed: read,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  /// getAtKeys() will retrieve keys shared by [widget.atSign].
  /// Strip any meta data away from the retrieves keys. Store
  /// the keys into [_scanItems].
  Future<void> _scan() async {
    List<AtKey> response = await _serverDemoService.getAtKeys(
      sharedBy: atSign,
    );
    if (response.isNotEmpty) {
      List<String?> scanList = response.map((AtKey atKey) => atKey.key).toList();
      setState(() => _scanItems = scanList);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Scanning keys and values done.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Create instance of an AtKey and call get() on it.
  Future<void> _lookup() async {
    if (_lookupKey == null) {
      setState(() => _lookupValue = 'The key is empty.');
    } else {
      AtKey lookup = AtKey();
      lookup.key = _lookupKey;
      lookup.sharedWith = atSign;
      String? response = await _serverDemoService.get(lookup);
      setState(() => _lookupValue = response);
    }
  }
}
