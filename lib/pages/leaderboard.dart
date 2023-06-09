// coverage:ignore-start

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/pages/start_quiz.dart';
import 'package:kwiz_v2/shared/loading.dart';
import '../models/bookmarks.dart';
import '../models/quizzes.dart';
import 'home.dart';
// import 'start_quiz.dart';
import '../services/database.dart';

class Leaderboard extends StatefulWidget {
  final OurUser user;
  const Leaderboard({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<UserData>? filteredUsers;
  List<UserData>? users;
  Map<int, UserData> sortedMap = {};
  bool rankings = false;

  int filLength = 0;
  int usersLength = 0;
  UserData? userData;
  List<bool> isBookmarkedList = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //  _startLoading();
    loadData().then((value) {
      setState(() {});
    });
  }

  // loads data from DB
  Future<void> loadData() async {
    DatabaseService service = DatabaseService();
    userData = await service.getUserAndBookmarks(userID: widget.user.uid);

    users = await service.getAllUsers(); //user.uid

    filteredUsers = users;
    print(users!.elementAt(0).userName);
    usersLength = users!.length;
    filLength = usersLength;
    //maxSort(filteredUsers!);
    bubbleSortDescending(filteredUsers!);

    setState(() {
      _isLoading = false;
    });
  }

// This function is used to filter the quizzes by doing a linear search of the quizzes retrieved from the database,
// it is moved to normal lists first as this caused issues
  void filterQuizzes(String searchTerm) {
    setState(() {
      
      filteredUsers = users!
          .where((item) =>
              item.userName.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

      filLength = filteredUsers!.length;

      //Keep bookmarks vaild
    });
    bubbleSortDescending(filteredUsers!);
  }

  void _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _isLoading = false;
    });
  }


  //This function calculates the weigthed score for the leaderboard based on the
  //number of quizzes and a users total score
  double weightedScore(int index) {
    double wSum = 0;

    double score = double.parse(filteredUsers!.elementAt(index).totalScore);
    int quizzes = filteredUsers!.elementAt(index).totalQuizzes;

    if (quizzes == 0) {
      return 0;
    }

    // Give a higher weight to users who have taken more quizzes
    double weight = 1 + (quizzes / 10);

    wSum = (score / quizzes) * weight;

    return double.parse(wSum.toStringAsFixed(2));
  }


  //Used to sort the list of users based on their weigthed score
  void bubbleSortDescending(List<UserData> arr) {
    int n = arr.length;

    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (weightedScore(j) < weightedScore(j + 1)) {
          // swap arr[j] and arr[j+1]
          UserData temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
      }
    }

    // create a map to store the sorted items with their index as the key
    // loop through the sorted list and add each item to the map with its index as the key
    if (rankings == false) {
      for (int i = 0; i < arr.length; i++) {
        sortedMap[i] = arr[i];
      }
      rankings = true;
    }
  }

  //Used in the sorting process as a map is used to store users along with their score
  int findKeyByValue(Map<int, UserData> map, UserData value) {
    for (final entry in map.entries) {
      if (entry.value.uID == value.uID) {
        return entry.key;
      }
    }
    // If no matching entry is found, return -1 or some other default value
    return -1;
  }


  //Widget tree
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading() //Loading indicator if contents are not loaded
        : Scaffold(
          //Appbar
            appBar: filteredUsers == null && _isLoading
                ? null
                : AppBar(
                    title: const Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'TitanOne',
                      ),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
            body: filteredUsers == null && _isLoading
                ? Loading()
                : Container(
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
                              hintText: 'Find a friend',
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
                                onPressed: () {
                                  filterQuizzes(_searchController.text);
                                },
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
                            onChanged: (value) {
                              filterQuizzes(value);
                            },
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(),
                              ),
                              filteredUsers == null && _isLoading
                                  ? Loading()
                                  : ListView.builder(
                                      itemCount: filLength,
                                      itemBuilder: (context, index) {
                                        
                                        //Colours for the alternating card borders
                                        final List<Color> blueAndOrangeShades =
                                            [
                                          // Colors.blueGrey.shade400,
                                          // Colors.blueGrey.shade500,
                                          // Colors.blueGrey.shade600,
                                          // Colors.blueGrey.shade700,
                                          Colors.blue.shade500,
                                          Colors.blue.shade600,
                                          Colors.blue.shade700,
                                          Colors.blue.shade800,
                                         
                                        ];

                                        final Color color1 =
                                            blueAndOrangeShades[index %
                                                blueAndOrangeShades.length];

                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: filteredUsers!
                                                        .elementAt(index)
                                                        .uID ==
                                                    userData?.uID
                                                ? Colors.orange
                                                : color1,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 3.0,
                                                spreadRadius: 2.0,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            color: const Color.fromARGB(
                                                240, 45, 64, 96),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                filteredUsers!
                                                    .elementAt(index)
                                                    .userName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                              leading: Text(
                                                (findKeyByValue(
                                                            sortedMap,
                                                            filteredUsers!
                                                                .elementAt(
                                                                    index)) +
                                                        1)
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                              textColor: Colors.white,
                                              subtitle: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    //Data displayed in each card
                                                    Text(
                                                      'Quizzes: ${filteredUsers!.elementAt(index).totalQuizzes} |',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white,
                                                        fontFamily: 'Nunito',
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Total score: ${double.parse(filteredUsers!.elementAt(index).totalScore).toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white,
                                                        fontFamily: 'Nunito',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              trailing: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      color1,
                                                      const Color.fromARGB(
                                                          255, 59, 98, 172),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                                child: ElevatedButton(
                                                  //Displayes the score
                                                  onPressed: (){},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  child: Text(
                                                    '${weightedScore(index).toStringAsFixed(2)} pts',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.orange,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                ),
                                              ),
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