import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:x_social/models/feed_model.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/view_comments.dart';

class FeedPost extends StatelessWidget {
  const FeedPost({super.key, required this.post, this.fromComment = false});
  final FeedModel post;
  final bool fromComment;

  @override
  Widget build(BuildContext context) {
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
                  post.userName.toInitials,
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
                      post.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall,
                    ),
                    Text(
                      post.createdAt.formatTimeDifference,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelMedium!.copyWith(
                        color: context.colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
              if (!fromComment)
                GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    context.to(ViewComments(post: post));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_rounded,
                        color: context.colorScheme.primary,
                        size: 25.sp,
                      ),
                      if (post.comments.isNotEmpty)
                        Positioned(
                          top: 3.h,
                          child: Text(
                            post.comments.length > 99 ? "99+" : post.comments.length.toString(),
                            style: context.textTheme.labelMedium!.copyWith(
                              color: context.colorScheme.background,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
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
            post.message,
            style: context.textTheme.bodySmall,
          ),
          if (post.images.isNotEmpty) ...[
            10.verticalSpace,
            SizedBox(
              height: 150.h,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: post.images.length,
                itemBuilder: (context, index) {
                  final images = post.images[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: images,
                      height: 100.h,
                      width: 150.h,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      errorListener: (value) {
                        debugPrint(value.toString());
                      },
                      errorWidget: (context, error, value) {
                        return Container(
                          height: 150.h,
                          width: 150.h,
                          decoration: BoxDecoration(
                            color: context.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        );
                      },
                      progressIndicatorBuilder: (context, data, value) {
                        return Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: context.colorScheme.primary,
                            size: 30.sp,
                          ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => 5.horizontalSpace,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
