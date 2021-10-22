import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UsersPieChart extends StatefulWidget {
  // Variables
  final int totalUsers;
  final int totalActiveUsers;
  final int totalVerifiedUsers;
  final int totalFlaggedUsers;
  final int totalBlockedUsers;

  // Constructor
  const UsersPieChart(
      {required this.totalUsers,
      required this.totalActiveUsers,
      required this.totalVerifiedUsers,
      required this.totalFlaggedUsers,
      required this.totalBlockedUsers});

  @override
  State<StatefulWidget> createState() => _UsersPieChartState();
}

class _UsersPieChartState extends State<UsersPieChart> {
  // Variables
  int? touchedIndex;

  /// Calculate pie chart percentage
  String _showPercentage(int value) {
    final result = ((value / widget.totalUsers) * 100).toStringAsFixed(1);
    return "$result%";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Text("Chart Statistic"),

            /// Pie Chart
            SizedBox(
              width: double.maxFinite,
              height: 300,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                          final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch && pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse.touchedSection?.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      // Old Code
                      // setState(() {
                      //   if (pieTouchResponse.touchInput is FlLongPressEnd ||
                      //       pieTouchResponse.touchInput is FlPanEnd) {
                      //     touchedIndex = -1;
                      //   } else {
                      //     touchedIndex = pieTouchResponse.touchedSectionIndex;
                      //   }
                      // });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    sections: showingSections()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 16;
      final double radius = isTouched ? 110 : 100;
      final titleStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff));

      switch (i) {
        case 0:

          /// Total Active Users
          return PieChartSectionData(
              color: Colors.green,
              value: widget.totalActiveUsers.toDouble(),
              title: _showPercentage(widget.totalActiveUsers),
              radius: radius,
              titleStyle: titleStyle);
        case 1:

          /// Total Verified Users
          return PieChartSectionData(
              color: Colors.blue,
              value: widget.totalVerifiedUsers.toDouble(),
              title: _showPercentage(widget.totalVerifiedUsers),
              radius: radius,
              titleStyle: titleStyle);
        case 2:

          /// Total Flagged Users
          return PieChartSectionData(
              color: Colors.amber,
              value: widget.totalFlaggedUsers.toDouble(),
              title: _showPercentage(widget.totalFlaggedUsers),
              radius: radius,
              titleStyle: titleStyle);
        case 3:

          /// Total Blocked Users
          return PieChartSectionData(
              color: Colors.red,
              value: widget.totalBlockedUsers.toDouble(),
              title: _showPercentage(widget.totalBlockedUsers),
              radius: radius,
              titleStyle: titleStyle);
        default:
          return PieChartSectionData();
      }
    });
  }
}
