import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/model/HomeMachinesMetrics.dart';

class ListCardWidget extends StatelessWidget {
  final HomeMachinesMetrics data;

  ListCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left column (Machine ID and Temperature)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.miAlias,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('${data.mgName}'),
                SizedBox(height: 5),
                Text('${data.miInsideTemp} °C'),
              ],
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '\$${NumberFormat("#,###").format(data.noteAmount)}  '),
                    Icon(Icons.money),
                  ],
                ),
                SizedBox(height: 8), // Add some space between the rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '\$${NumberFormat("#,###").format(data.coinAmount)}  '),
                    Icon(Icons.monetization_on_outlined),
                  ],
                ),
              ],
            ),

            // Right column (Sales)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${NumberFormat("#,###").format(data.saleAmount)}',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
