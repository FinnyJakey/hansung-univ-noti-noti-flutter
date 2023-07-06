import 'package:flutter/material.dart';

Widget scheduleWidget(int month, List schedule) {
  return schedule[month].length != 0
      ? ListView.builder(
          itemBuilder: (context, index) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(left: 15.0, bottom: 10.0),
                  width: 10,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      bottomLeft: Radius.circular(25.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.only(bottom: 10.0, right: 15.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          schedule[month][index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          schedule[month][index].content,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: schedule[month].length,
        )
      : const Center(child: Text('조회된 데이터가 없어요!'));
}
