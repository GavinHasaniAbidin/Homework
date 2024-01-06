import 'package:habitapp/helpers.dart';
import 'package:habitapp/provider.dart';
import 'package:habitapp/statistics.dart';
import 'package:habitapp/widgets/empty_statistics_image.dart';
import 'package:habitapp/widgets/overall_statistics_card.dart';
import 'package:habitapp/widgets/statistics_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    // var tmp = compute(calculateStatistics, Provider.of<Bloc>(context).allHabits);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '歷史',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: FutureBuilder(
          future: Provider.of<Bloc>(context).getFutureStatsData(),
          builder:
              (BuildContext context, AsyncSnapshot<AllStatistics> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.habitsData.length == 0) {
                return EmptyStatisticsImage();
              } else {
                return ListView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    OverallStatisticsCard(
                      total: snapshot.data.total,
                      habits: snapshot.data.habitsData.length,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data.habitsData
                          .map(
                            (index) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: StatisticsCard(data: index),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: HaboColors.primary,
                ),
              );
            }
          }),
    );
  }
}
