import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:x_social/models/feed_model.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/widgets/app_text_field.dart';
import 'package:x_social/views/widgets/feed_post.dart';

class ViewComments extends StatefulWidget {
  const ViewComments({super.key, required this.post});

  final FeedModel post;

  @override
  State<ViewComments> createState() => _ViewCommentsState();
}

class _ViewCommentsState extends State<ViewComments> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().commentController.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<DashboardProvider>();
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        backgroundColor: context.colorScheme.background,
        centerTitle: true,
        title: Text(
          "Comments",
          style: context.textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    FeedPost(
                      post: widget.post,
                      fromComment: true,
                    ),
                    20.verticalSpace,
                    Text(
                      "Comments",
                      style: context.textTheme.bodyMedium,
                    ),
                    10.verticalSpace,
                    if (widget.post.comments.isNotEmpty)
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: widget.post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = widget.post.comments[index];
                          return Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: context.colorScheme.onBackground.withOpacity(0.25),
                                width: 1.w,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                        color: context.colorScheme.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        comment.userName.toInitials,
                                        style: context.textTheme.labelMedium!.copyWith(
                                          color: context.colorScheme.primary,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.userName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.textTheme.bodySmall,
                                          ),
                                          Text(
                                            comment.createdAt.formatTimeDifference,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.textTheme.labelMedium!.copyWith(
                                              color: context.colorScheme.onBackground,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                1.verticalSpace,
                                Divider(
                                  color: context.colorScheme.onBackground.withOpacity(0.25),
                                ),
                                1.verticalSpace,
                                Text(
                                  comment.comment,
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => 10.verticalSpace,
                      )
                    else ...[
                      50.verticalSpace,
                      Center(
                        child: Text(
                          "No comments",
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: read.commentController,
                      label: "Comment",
                      hint: "Enter comment",
                    ),
                  ),
                  10.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      Feedback.forTap(context);
                      read.addComment(context, feed: widget.post);
                    },
                    child: Container(
                      height: 60.h,
                      width: 60.h,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.send_rounded,
                        color: context.colorScheme.background,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
