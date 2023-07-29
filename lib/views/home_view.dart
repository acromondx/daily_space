import 'package:daily_space/widgets/error_section.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:daily_space/services/api_service.dart';
import 'package:daily_space/services/db_service.dart';

import '../constants.dart';
import 'apod_detail_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final apodData = ref.watch(dbServiceProvider);
    final selectedDate = ref.watch(selectedDateProvider.notifier).state;
    final txtStyle = Theme.of(context).textTheme.displayMedium;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Space 🚀')),
      body: ref.watch(apodProvider(ref.watch(selectedDateProvider))).when(
            data: (data) {
              // if (data.title == null || data.url == null) {
              //   return const Text('No data available.');
              // }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  ref.read(selectedDateProvider.notifier).state,
                              firstDate: DateTime(2000, 1),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null &&
                                picked !=
                                    ref
                                        .read(selectedDateProvider.notifier)
                                        .state) {
                              ref.read(selectedDateProvider.notifier).state =
                                  picked;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              border: Border.all(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(IconlyLight.calendar),
                                const SizedBox(width: 5),
                                Text(
                                    '${selectedDate.day} ${AppConstants.months[selectedDate.month]}, ${selectedDate.year}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        //Apod Card
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ApodDetailView(apod: data),
                          )),
                          child: Stack(
                            children: [
                              Card(
                                color: const Color.fromARGB(31, 51, 53, 51),
                                elevation: 20,
                                surfaceTintColor: Colors.grey.shade600,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    FancyShimmerImage(
                                      alignment: Alignment.center,
                                      shimmerHighlightColor: Colors.grey,
                                      width: double.infinity,
                                      imageUrl: data.mediaType == 'image'
                                          ? data.url!
                                          : data.thumbnailUrl!,
                                      errorWidget: Image.network(
                                          AppConstants.errorImageUrl),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(data.title!,
                                                style: txtStyle!.copyWith(
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 15.0,
                                top: 20.0,
                                child: IconButton.filledTonal(
                                  icon: ref
                                      .watch(isApodSavedProvider(data))
                                      .when(
                                          skipLoadingOnReload: true,
                                          data: (data) => data
                                              ? Icon(Icons.star,
                                                  color: Colors.amber[700])
                                              : Icon(Icons.star_border_outlined,
                                                  color: Colors.amber[700]),
                                          error: (error, stac) => Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.amber[700]),
                                          loading: () => Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.amber[700])),
                                  color: Colors.red,
                                  onPressed: () async {
                                    if (await apodData.isSavead(data)) {
                                      ref
                                          .read(dbServiceProvider)
                                          .deleteApod(data.apodId);
                                    } else {
                                      ref
                                          .read(dbServiceProvider)
                                          .saveApod(data);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (error, st) {
              print(error.toString());
              return Center(
                child: InternetErrorSection(
                  error: error,
                  onRefreshButtonPressed: () => ref
                      .refresh(apodProvider(ref.watch(selectedDateProvider))),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
