import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:kwiz_v2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwiz_v2/models/pastAttempt.dart';
import 'package:kwiz_v2/models/questions.dart';
import 'package:kwiz_v2/models/quizzes.dart';
import 'package:kwiz_v2/models/user.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:kwiz_v2/services/mock_database.dart';

void main() {
  test('Get categories', () async {
    final service = MockDataService();
    final List? testCategories = await service.getCategories();

    expect(testCategories, ['Art', 'Science']);
  });
  test('get user and past attempts', () async {
    final service = MockDataService();
    String UserId = "Userid";
    final UserData? userData =
        await service.getUserAndPastAttempts(userID: UserId);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.pastAttemptQuizzes[0].quizID, "id");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizName, "Quiz Test");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizAuthor, "Tester");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizCategory,
        "Test Category");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizDescription,
        "Test Description");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizDateCreated,
        "Test Date");
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizMark, 2);
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizMarks, [1, 2]);
    expect(userData?.pastAttemptQuizzes[0].pastAttemptQuizDatesAttempted,
        ["Test Date 1", "Test Date 2"]);
  });
  test('get user and bookmarks', () async {
    final service = MockDataService();
    String UserId = "Userid";
    final UserData? userData =
        await service.getUserAndBookmarks(userID: UserId);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes[0].quizID, "id");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizName, "Quiz Test");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizAuthor, "Tester");
    expect(
        userData?.bookmarkedQuizzes[0].bookmarkQuizCategory, "Test Category");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDescription,
        "Test Description");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDateCreated, "Test Date");
  });
  test('add bookmarks', () async {
    final service = MockDataService();
    String UserId = "Userid";
    Quiz quizTest = Quiz(
        quizName: "Quiz Test",
        quizCategory: "Test Category",
        quizDescription: "Test Description",
        quizMark: 0,
        quizDateCreated: "Test Date",
        quizQuestions: [],
        quizID: "id",
        quizGlobalRating: 0,
        quizTotalRatings: 0,
        quizAuthor: "Tester");

    final UserData? userData =
        await service.addBookmarks(userID: UserId, quiz: quizTest);

    expect(userData?.bookmarkedQuizzes[0].quizID, "id");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizName, "Quiz Test");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizAuthor, "Tester");
    expect(
        userData?.bookmarkedQuizzes[0].bookmarkQuizCategory, "Test Category");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDescription,
        "Test Description");
    expect(userData?.bookmarkedQuizzes[0].bookmarkQuizDateCreated, "Test Date");
  });
  test('delete bookmarks', () async {
    final service = MockDataService();
    String UserId = "Userid";
    String QuizId = "Quizid";

    final UserData? userData =
        await service.deleteBookmarks(userID: UserId, quizID: QuizId);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes, []);
    expect(userData?.pastAttemptQuizzes, []);
  });
  test('get user', () async {
    final service = MockDataService();
    String uid = "uid";

    final UserData? userData = await service.getUser(uid);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes, []);
    expect(userData?.pastAttemptQuizzes, []);
  });
  test('add user', () async {
    final service = MockDataService();
    OurUser ourUser = OurUser(uid: "uid");
    UserData userDataIn = UserData(
        uID: "",
        userName: "TestDummy",
        firstName: "Test",
        lastName: "Dummy",
        totalScore: ' ',
        totalQuizzes: 0,
        bookmarkedQuizzes: [],
        pastAttemptQuizzes: [],
        ratings: [],
        friends: []);

    final UserData? userData = await service.addUser(userDataIn, ourUser);

    expect(userData?.firstName, "Test");
    expect(userData?.lastName, "Dummy");
    expect(userData?.userName, "TestDummy");
    expect(userData?.bookmarkedQuizzes, []);
    expect(userData?.pastAttemptQuizzes, []);
  });
  test('get quiz and questions', () async {
    final service = MockDataService();
    String quizId = "quizId";
    final Quiz? quiz = await service.getQuizAndQuestions(quizID: quizId);

    expect(quiz?.quizID, "quizId");
  });

  test('get all quizzes', () async {
    final service = MockDataService();
    final List<Quiz>? quizzes = await service.getAllQuizzes();

    expect(quizzes?.length, 2);
  });
  test('get quiz by category', () async {
    final service = MockDataService();
    String category = 'Biology';
    final List<Quiz>? quizzes =
        await service.getQuizByCategory(category: category);

    expect(quizzes?.length, 2);
  });
  test('get quiz information only', () async {
    final service = MockDataService();
    Quiz quizIn = Quiz(
        quizName: 'Biology Quiz',
        quizCategory: 'Biology',
        quizDescription: 'Quiz about Biology',
        quizMark: 10,
        quizDateCreated: '2023-03-31 20:28',
        quizQuestions: [],
        quizID: 'quizID',
        quizGlobalRating: 0,
        quizTotalRatings: 0,
        quizAuthor: 'Biology Quiz Author');
    Quiz? quizOut = await service.getQuizInformationOnly(quizID: 'quizID');

    expect(quizOut?.quizID, quizIn.quizID);
    expect(quizOut?.quizName, quizIn.quizName);
    expect(quizOut?.quizCategory, quizIn.quizCategory);
    expect(quizOut?.quizDescription, quizIn.quizDescription);
    expect(quizOut?.quizMark, quizIn.quizMark);
    expect(quizOut?.quizDateCreated, quizIn.quizDateCreated);
    expect(quizOut?.quizQuestions, quizIn.quizQuestions);
    expect(quizOut?.quizGlobalRating, quizIn.quizGlobalRating);
    expect(quizOut?.quizAuthor, quizIn.quizAuthor);
  });
  test('create past attempt', () async {
    final service = MockDataService();
    int quizMark = 10;
    String quizDateAttempted = '2023-03-31 20:30';

    Quiz quizIn = Quiz(
        quizName: 'Biology Quiz',
        quizCategory: 'Biology',
        quizDescription: 'Quiz about Biology',
        quizMark: 10,
        quizDateCreated: '2023-03-31 20:28',
        quizQuestions: [],
        quizID: 'quizID',
        quizGlobalRating: 0,
        quizTotalRatings: 0,
        quizAuthor: 'Biology Quiz Author');
    PastAttempt? pastAttempt = await service.createPastAttempt(
        userID: 'userID',
        quiz: quizIn,
        quizMark: quizMark,
        quizDateAttempted: quizDateAttempted,
        quizAuthor: quizIn.quizAuthor);

    expect(pastAttempt?.pastAttemptQuizAuthor, quizIn.quizAuthor);
    expect(pastAttempt?.pastAttemptQuizCategory, quizIn.quizCategory);
    expect(pastAttempt?.pastAttemptQuizDateCreated, quizIn.quizDateCreated);
    expect(pastAttempt?.pastAttemptQuizDatesAttempted, [quizDateAttempted]);
    expect(pastAttempt?.pastAttemptQuizDescription, quizIn.quizDescription);
    expect(pastAttempt?.pastAttemptQuizMark, quizIn.quizMark);
    expect(pastAttempt?.pastAttemptQuizMarks, [quizMark]);
  });

  test('add past attempt', () async {
    final service = MockDataService();
    List<int> quizMarks = [10, 12];
    String quizDateAttempted = '2023-03-31 20:32';

    Quiz quizIn = Quiz(
        quizName: 'Biology Quiz',
        quizCategory: 'Biology',
        quizDescription: 'Quiz about Biology',
        quizMark: 10,
        quizDateCreated: '2023-03-31 20:28',
        quizQuestions: [],
        quizID: 'quizID',
        quizGlobalRating: 0,
        quizTotalRatings: 0,
        quizAuthor: 'Biology Quiz Author');
    PastAttempt? pastAttempt = await service.addPastAttempt(
        userID: 'userID',
        quizMarks: quizMarks,
        quizDateAttempted: quizDateAttempted,
        quizID: quizIn.quizID);

    expect(pastAttempt?.pastAttemptQuizAuthor, quizIn.quizAuthor);
    expect(pastAttempt?.pastAttemptQuizCategory, quizIn.quizCategory);
    expect(pastAttempt?.pastAttemptQuizDateCreated, quizIn.quizDateCreated);
    expect(pastAttempt?.pastAttemptQuizDatesAttempted,
        ['2023-03-31 20:28', '2023-03-31 20:32']);
    expect(pastAttempt?.pastAttemptQuizDescription, quizIn.quizDescription);
    expect(pastAttempt?.pastAttemptQuizMark, quizIn.quizMark);
    expect(pastAttempt?.pastAttemptQuizMarks, quizMarks);
  });

  test('create rating', () async {
    final service = MockDataService();
    String quizID = 'quizID';
    String userID = 'userID';
    int rating = 3;

    int expectedRating = await service.createRating(
        userID: userID, rating: rating, quizID: quizID);

    expect(expectedRating, rating);
  });

  test('update rating', () async {
    final service = MockDataService();
    String quizID = 'quizID';
    String userID = 'userID';
    int rating = 3;

    int expectedRating = await service.testUpdateRating(
        userID: userID, newRating: rating, quizID: quizID);

    expect(expectedRating, rating);
  });

  test('ratingAlreadyExists', () async {
    final service = MockDataService();
    String quizID = 'quizID';
    String userID = 'userID';

    bool ratingAlreadyexists =
        await service.ratingAlreadyExists(userID: userID, quizID: quizID);

    expect(ratingAlreadyexists, true);
  });

  test('addToGlobalRating', () async {
    final service = MockDataService();
    String quizID = 'quizID';
    int rating = 3;

    List<int> output =
        await service.addToGlobalRating(rating: rating, quizID: quizID);

    expect(output, [8, 2]);
  });
  test('getOldRating', () async {
    final service = MockDataService();
    String quizID = 'quizID';
    String userID = 'userID';

    int expectedRating =
        await service.getOldRating(userID: userID, quizID: quizID);

    expect(expectedRating, 3);
  });

  test('updateGlobalRating', () async {
    final service = MockDataService();
    String quizID = 'quizID';
    String userID = 'userID';
    int rating = 5;
    int oldRating = 4;

    int expectedRating = await service.updateQuizGlobalRating(
        userID: userID, quizID: quizID, rating: rating, oldRating: oldRating);

    expect(expectedRating, 6);
  });

  test('getUserandFriends', () async {
    final service = MockDataService();
    String userID = 'userID';

    UserData? user = await service.getUserAndFriends(userID: userID);

    expect(user?.friends[0].friendID, "id");
  });

  test('userExists', () async {
    final service = MockDataService();
    String username = "TestUsername";
    bool userExists = await service.userExists(username);
    expect(userExists, true);
  });

  test('getMyUsername', () async {
    final service = MockDataService();
    String userID = "id";
    String? username = await service.getMyUsername(userID);
    expect(username, "Test Dummy");
  });

  test('addFriend', () async {
    final service = MockDataService();
    String? userID = "id";
    String? friendID = "friendid";
    String? frienUsername = "friendUsername";
    String? username = await service.addFriends(
        userID: userID, friendID: friendID, friendUsername: frienUsername);
    expect(username, frienUsername);
  });

  test('alreadyFriends', () async {
    final service = MockDataService();
    String? userID = "id";
    String? friendID = "friendid";
    String? friendUsername = "friendUsername";
    bool? alreadyFriends =
        await service.alreadyFriendsTest(friendUsername, friendID, userID);
    expect(alreadyFriends, true);
  });

  test('getUserandFriendRequests', () async {
    final service = MockDataService();
    String userID = 'userID';

    UserData? user = await service.getUserAndFriendRequests(userID: userID);

    expect(user?.friends[0].friendID, "id");
  });

  test('acceptFriendRequest', () async {
    final service = MockDataService();
    String? userID = "id";
    String? friendID = "friendid";
    String? friendUsername = "friendUsername";

    String? accepted =
        await service.acceptFriendRequest(friendUsername, friendID, userID);

    expect(accepted, "accepted");
  });

  test('removeFriend', () async {
    final service = MockDataService();
    String? userID = "id";
    String? friendID = "friendid";
    String? friendUsername = "friendUsername";

    bool friendStillInDatabase =
        await service.removeFriendTest(friendUsername, friendID, userID);

    expect(friendStillInDatabase, false);
  });
}
