import 'package:daily_space/models/apod.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:photo_view/photo_view.dart';

import '../constants.dart';
import '../services/download_image.dart';
import '../widgets/snackbar_alert.dart';

class ApodDetailView extends ConsumerWidget {
  final Apod apod;
  const ApodDetailView({Key? key, required this.apod}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txtStyle = Theme.of(context).textTheme.displayMedium;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton.filledTonal(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(IconlyLight.arrow_left_2),
            ),
            expandedHeight: 300,
            collapsedHeight: 300,
            actions: [
              const SizedBox(width: 7),
              IconButton.filledTonal(
                tooltip: 'Preview image',
                // onPressed: () {
                //   showImageViewer(context, Image.network(apod.url!).image,
                //       swipeDismissible: true, doubleTapZoomable: true);
                // },
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => Scaffold(
                            appBar: AppBar(
                              leading: const SizedBox(),
                              actions: [
                                IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close))
                              ],
                            ),
                            body: PhotoView(
                              imageProvider: NetworkImage(apod.url!),
                            ),
                          )));
                },
                icon: const Icon(Icons.fullscreen),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                  tooltip: 'Download image',
                  onPressed: () async {
                    snackBarAlert(
                        context, 'Download has started...', Colors.blue);

                    await ref
                        .watch(downloadImageProvider(apod.hdurl!))
                        .download()
                        .then((_) => snackBarAlert(
                            context, 'Download complete', Colors.green));
                  },
                  icon: const Icon(Icons.download)),
              const SizedBox(width: 7),
            ],
            flexibleSpace: FancyShimmerImage(
              boxFit: BoxFit.fill,
              alignment: Alignment.center,
              shimmerHighlightColor: Colors.grey,
              width: double.infinity,
              imageUrl:
                  apod.mediaType == 'image' ? apod.url! : apod.thumbnailUrl!,
              errorWidget: Image.network(AppConstants.errorImageUrl),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    ApodInfoCard(
                      content: apod.date!,
                      icon: IconlyLight.calendar,
                    ),
                    const SizedBox(height: 10),
                    if (apod.copyright != null)
                      ApodInfoCard(
                        content: apod.copyright!,
                        icon: Icons.copyright_rounded,
                      ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apod.title!,
                            style: txtStyle!.copyWith(
                                fontSize: 15, color: Colors.blueGrey.shade400),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            apod.explanation!,
                            style: txtStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.blueGrey.shade100),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ApodInfoCard extends StatelessWidget {
  const ApodInfoCard({
    super.key,
    required this.content,
    required this.icon,
  });

  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.15),
      ),
      child: Row(children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(content.trim()),
      ]),
    );
  }
}
