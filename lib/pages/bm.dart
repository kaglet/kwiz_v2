// coverage:ignore-start

import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/bookmark.dart';
import '../models/bookmarks.dart';
import '../models/pastAttempt.dart';
import '../services/database.dart';
import '../pages/quiz_history.dart';

class bm extends StatefulWidget {
  /*final String chosenQuizID;
  final List? chosenQuizMarks;
  final List? chosenQuizDatesCreated;
  final String chosenQuizName; */
  final Bookmarks chosenQuiz;
  const bm(
      {super.key,
      /*required this.chosenQuizID,
                                required this.chosenQuizName,
                                required this.chosenQuizMarks,
                                required this.chosenQuizDatesCreated,*/
      required this.chosenQuiz});
  @override
  // ignore: library_private_types_in_public_api
  _bmState createState() => _bmState();
}

class _bmState extends State<bm> {
  late String quizID;
  late List? quizMarks;
  late List? quizDatesCreated;
  late String quizName;
  late Bookmarks bookmark;
  List? distinctQuizzes;
  int catLength = 0;
  List? _displayedItems = [];
  List? categories;
  int fillLength = 0;
  final TextEditingController _searchController = TextEditingController();

  Future<void> loaddata() async {
    DatabaseService service = DatabaseService();
    categories = await service.getCategories();
    categories!.insert(0, 'All');
    catLength = categories!.length;
    _displayedItems = categories;
    fillLength = _displayedItems!.length;
  }

  @override
  void initState() {
    super.initState();
    // quizID = widget.chosenQuizID;
    // quizMarks = widget.chosenQuizMarks;
    // quizDatesCreated = widget.chosenQuizDatesCreated;
    // quizName = widget.chosenQuizName;
    bookmark = widget.chosenQuiz;

    _displayedItems = categories;
    loaddata().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

//This method is used to control the search bar
  void _onSearchTextChanged(String text) {
    setState(() {
      _displayedItems = distinctQuizzes!
          .where((item) => item.toLowerCase().contains(text.toLowerCase()))
          .toList();
      fillLength = _displayedItems!.length;
    });
  }

  @override
  Widget build(BuildContext contetx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bookmark.bookmarkQuizName + ' Attempts',
          style: TextStyle(
              fontFamily: 'TitanOne',
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        backgroundColor: const Color.fromARGB(255, 27, 57, 82),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 27, 57, 82),
              Color.fromARGB(255, 5, 12, 31),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 45, 64,
                      96), // set the background color to a darker grey
                  hintText: 'Search quizzes',
                  hintStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily:
                        'Nunito', // set the hint text color to a light grey
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: const Color.fromRGBO(192, 192, 192,
                        1), // set the search icon color to a light grey
                    onPressed: () {},
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(81, 95, 87,
                            1)), // set the border color to a darker grey
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors
                            .white), // set the focused border color to white
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onChanged: _onSearchTextChanged,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                  ),
                  _displayedItems == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final List<Color> blueAndOrangeShades = [
                              Colors.orange.shade400,
                              Colors.orange.shade500,
                              Colors.orange.shade600,
                              Colors.orange.shade700,
                            ];

                            final Color color1 = blueAndOrangeShades[
                                index % blueAndOrangeShades.length];

                            return Card(
                              margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(255, 45, 64, 96),
                                      Color.fromARGB(255, 45, 64, 96),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(children: <Widget>[
                                    //Text('Attempt Number ${index+1}'),
                                    //Text('Score: ${bookmark.pastAttemptQuizMarks[index]}' ),
                                    Text(
                                        'Quiz Name: ${bookmark.bookmarkQuizDateCreated}')
                                  ]),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// coverage:ignore-end