import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/widgets/feed_post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<DashboardProvider>();
    return StreamBuilder<QuerySnapshot>(
        stream: read.feedCollection.snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: context.colorScheme.primary,
                  size: 40.sp,
                ),
              );
            case ConnectionState.active:
              final data = snapshot.requireData.docs;
              final socialFeed = read.loadFeed(data);
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(10.w),
                itemCount: socialFeed.length,
                itemBuilder: (context, index) {
                  final feed = socialFeed[index];
                  return FeedPost(post: feed);
                },
                separatorBuilder: (_, __) => 10.verticalSpace,
              );
            case ConnectionState.none:
            case ConnectionState.done:
              return Center(
                child: Text(
                  "Something went wrong. Please try again later.",
                  style: context.textTheme.bodyMedium,
                ),
              );
          }
        });
  }
}
