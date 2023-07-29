import 'package:daily_space/constants.dart';
import 'package:daily_space/services/db_service.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../widgets/snackbar_alert.dart';
import 'apod_detail_view.dart';

class SavedApodsView extends ConsumerWidget {
  const SavedApodsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedApods = ref.watch(savedApodProvider);
    final txtStyle = Theme.of(context).textTheme.displayMedium;
    final db = ref.watch(dbServiceProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Saved'),
        ),
        body: savedApods.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (data) => data.isEmpty
              ? const Center(child: Text('No Bookmars'))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final savedApod = data[index];
                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ApodDetailView(apod: savedApod),
                            )),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurStyle: BlurStyle.outer,
                                        blurRadius: 1)
                                  ],
                                  border: Border.all(
                                      color: Colors.grey.shade900, width: 1),
                                  color: const Color.fromARGB(255, 20, 20, 20),
                                  borderRadius: BorderRadius.circular(10)),
                              child: SizedBox(
                                height: 120,
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: FancyShimmerImage(
                                            alignment: Alignment.center,
                                            shimmerHighlightColor: Colors.grey,
                                            height: double.infinity,
                                            imageUrl:
                                                savedApod.mediaType == 'image'
                                                    ? savedApod.url!
                                                    : savedApod.thumbnailUrl!,
                                            errorWidget: Image.network(
                                                AppConstants.errorImageUrl),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          flex: 14,
                                          child: Container(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(savedApod.title!,
                                                    style: txtStyle!.copyWith(
                                                      color: Colors
                                                          .blueGrey.shade400,
                                                    )),
                                                const SizedBox(height: 10),
                                                Text(savedApod.date!,
                                                    style: txtStyle.copyWith(
                                                        color: Colors
                                                            .blueGrey.shade100,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 10.0,
                                      bottom: 10.0,
                                      child: IconButton(
                                          onPressed: () async => await db
                                              .deleteApod(savedApod.apodId)
                                              .then((_) => snackBarAlert(
                                                    context,
                                                    'Item Removed!',
                                                    Colors.teal,
                                                    const Duration(seconds: 1),
                                                  )),
                                          icon: Icon(IconlyBold.star,
                                              color: Colors.amber.shade800)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 300)
                    ],
                  ),
                ),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ));
  }
}
