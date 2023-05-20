// coverage:ignore-start
import 'package:flutter/material.dart';
import 'package:kwiz_v2/models/user.dart';

class ViewChallenges extends StatefulWidget {
  final OurUser user;

  const ViewChallenges({super.key, required this.user});
  @override
  ViewChallengesState createState() => ViewChallengesState();
}

class ViewChallengesState extends State<ViewChallenges>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Challenges',
          style: TextStyle(
              fontFamily: 'TitanOne',
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.orange,
            indicatorWeight: 7,
            // indicator: BoxDecoration(
            // borderRadius: BorderRadius.circular(50), // Creates border
            // color: Colors.orange),
            labelStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito'),
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(text: 'Active'),
              Tab(
                text: 'Closed',
              )
            ]),
        backgroundColor: const Color.fromARGB(255, 27, 57, 82),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
            //Might need to do navigator.push because might lose user data
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
        child: TabBarView(controller: _tabController, children: [
          // Pending widgets --------------------------------------------------------------------------------------------------------------------
          SingleChildScrollView(
            child: SizedBox(
              height: 100.0,
              child: Card(
                margin: const EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
                child: Container(
                  decoration: const BoxDecoration(
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
                    child: Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          // Active widgets --------------------------------------------------------------------------------------------------------------------
          SingleChildScrollView(
            child: SizedBox(
              height: 100.0,
              child: Card(
                margin: const EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
                child: Container(
                  decoration: const BoxDecoration(
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
                    child: Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              'Take quiz',
                              style: TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          // Closed widgets --------------------------------------------------------------------------------------------------------------------
          SingleChildScrollView(
            child: SizedBox(
              height: 100.0,
              child: Card(
                margin: const EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 0),
                child: Container(
                  decoration: const BoxDecoration(
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
                    child: Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              'Review',
                              style: TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
// coverage:ignore-end
