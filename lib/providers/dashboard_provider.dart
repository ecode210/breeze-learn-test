import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_social/models/feed_model.dart';
import 'package:x_social/models/user_model.dart';
import 'package:x_social/utils/dialogs.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/login.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({this.test = false});

  final bool test;

  @override
  void dispose() {
    thoughtsController.dispose();
    commentController.dispose();
    super.dispose();
  }

  var _pageIndex = 0;

  set setPageIndex(int value) {
    _pageIndex = value;
    notifyListeners();
  }

  int get pageIndex => _pageIndex;

  FirebaseAuth get auth {
    if (test) {
      return MockFirebaseAuth(
        mockUser: MockUser(
          uid: "IVwBza8TjmU408wy26SrWAh7rcD2",
          email: "olawoleaeo@gmail.com",
          displayName: "Olawole Oyedele",
        ),
      );
    } else {
      return FirebaseAuth.instance;
    }
  }

  var user = UserModel();

  CollectionReference<Map<String, dynamic>> get userCollection {
    if (test) {
      return FakeFirebaseFirestore().collection("users");
    } else {
      return FirebaseFirestore.instance.collection("users");
    }
  }

  CollectionReference<Map<String, dynamic>> get feedCollection {
    if (test) {
      return FakeFirebaseFirestore().collection("feed");
    } else {
      return FirebaseFirestore.instance.collection("feed");
    }
  }

  final thoughtsController = TextEditingController();
  final _postImages = <String>[];

  void addPostImage(String value) {
    _postImages.add(value);
    notifyListeners();
  }

  void insertPostImage(int index, String value) {
    _postImages.insert(index, value);
    notifyListeners();
  }

  void removePostImage(int index) {
    _postImages.removeAt(index);
    notifyListeners();
  }

  void clearPostImage() {
    _postImages.clear();
    notifyListeners();
  }

  List<String> get postImages => _postImages;

  final commentController = TextEditingController();

  List<FeedModel> loadFeed(List<QueryDocumentSnapshot<Object?>> data) {
    final List<FeedModel> feeds = [];
    try {
      for (final feed in data) {
        final rawData = feed.data() as Map<String, dynamic>;
        feeds.add(FeedModel.fromJson(rawData));
      }
      feeds.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error parsing cards: $e');
    }
    return feeds;
  }

  Future<XFile?> pickImage(BuildContext context, {required ImageSource source}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      imageQuality: 50,
      requestFullMetadata: false,
    );
    if (context.mounted) context.back();
    if (image == null) {
      if (context.mounted) context.showSnackBar(title: "Unable to select image", isError: true);
    }
    final mimeType = image?.path.split(".").last;
    if (mimeType == null || (mimeType != "jpg" && mimeType != "png" && mimeType != "jpeg")) {
      if (context.mounted) {
        context.showSnackBar(
          title: "Invalid image format (acceptable formats: jpg, png, or jpeg)",
          isError: true,
        );
      }
      return null;
    }

    return image;
  }

  Future<void> addPost(BuildContext context) async {
    if (thoughtsController.text.trim().isEmpty) {
      context.showSnackBar(title: "Cannot post empty thoughts");
      return;
    }

    try {
      AppDialogs.loadingDialog(context);
      final links = <String>[];
      for (final image in postImages) {
        final link = await uploadFile(File(image));
        if (link != null) links.add(link);
      }

      final post = FeedModel(
        userId: user.userID,
        userName: user.name,
        message: thoughtsController.text.trim(),
        images: links,
        comments: [],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      final results = await feedCollection.add(post.toJson());
      await feedCollection.doc(results.id).update(
            FeedModel(
              id: results.id,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ).toJson(),
          );
      if (context.mounted) {
        context.back();
        context.back();
        context.showSnackBar(title: "Post added");
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) context.back();
      if (context.mounted) context.showSnackBar(title: "Network error", isError: true);
    }
  }

  Future<String?> uploadFile(File file) async {
    final random = Random(DateTime.now().millisecondsSinceEpoch).nextInt(9);
    String? link;
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child("post_images/${DateTime.now().millisecondsSinceEpoch}-$random");
      await ref.putFile(file);
      link = await ref.getDownloadURL();
      link = link.replaceAll("post_images/", "post_images%2F");
    } catch (e) {
      debugPrint("Error uploading photo: $e");
    }
    return link;
  }

  Future<void> addComment(BuildContext context, {required FeedModel feed}) async {
    if (commentController.text.trim().isEmpty) {
      context.showSnackBar(title: "Cannot post empty comment");
      return;
    }

    try {
      AppDialogs.loadingDialog(context);
      final comments = feed.comments;
      comments.add(Comments(
        userId: user.userID,
        userName: user.name,
        comment: commentController.text.trim(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
      final post = FeedModel(comments: comments);
      await feedCollection.doc(feed.id).update(post.toJson());
      if (context.mounted) {
        context.back();
        context.back();
        context.showSnackBar(title: "Comment added");
      }
      commentController.clear();
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) context.back();
      if (context.mounted) context.showSnackBar(title: "Network error", isError: true);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      AppDialogs.loadingDialog(context);
      await auth.signOut();
      if (context.mounted) context.back();
      if (context.mounted) context.off(const Login());
    } catch (e) {
      if (context.mounted) context.back();
      if (context.mounted) context.showSnackBar(title: "Something went wrong", isError: true);
    }
  }
}
