import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../date_util.dart';

Widget  dateTimeRangeField(
    BuildContext context,
    TextEditingController textControllerMin,
    TextEditingController textControllerMax,
    String? datetimeValue,
    String? datetimeValue2,
    ValueChanged<String> onChanges,
    ValueChanged<String> onChanges2,
    String label,
    {IconData? fieldIcon}
    ) {

  DateTime mDate1 = DateTime.now();
  DateTime mDate2 = DateTime(mDate1.year,mDate1.month,mDate1.day,mDate1.hour,mDate1.minute,
      mDate1.second,mDate1.millisecond,mDate1.microsecond);

  if(datetimeValue != null && datetimeValue.isNotEmpty){
    mDate1 = DateTime.parse(datetimeValue.toString());
    textControllerMin.text = DateUtil().getDatetimeFormatDisplay().format(mDate1);
  } else {
    datetimeValue = DateUtil().getDatetimeFormatServer().format(mDate1);
    textControllerMin.text = DateUtil().getDatetimeFormatDisplay().format(mDate1);
  }

  if(datetimeValue2 != null && datetimeValue2.isNotEmpty){
    mDate1 = DateTime.parse(datetimeValue2.toString());
    textControllerMax.text = DateUtil().getDatetimeFormatDisplay().format(mDate2);
  } else {
    datetimeValue2 = DateUtil().getDatetimeFormatServer().format(mDate2);
    textControllerMax.text = DateUtil().getDatetimeFormatDisplay().format(mDate2);
  }

  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          color: Colors.white,
          padding: EdgeInsets.only(top: 12, left: 14, bottom: 10, right: 14),
          child: Row(
            children: [
              Icon(
                fieldIcon ?? Icons.feed,
                color: Colors.grey,
                size: 18,
              ),
              SizedBox(width: 10),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    text: label,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    children: [
                      TextSpan(
                          text: '*',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.red),
                          )),
                    ]))
              )
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 12),
                  padding: EdgeInsets.only(left: 12),
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!)
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Marquee(
                        animationDuration: const Duration(milliseconds: 3300),
                        backDuration: const Duration(milliseconds: 3300),
                        pauseDuration: const Duration(milliseconds: 1000),
                        child: Text(textControllerMin.text.isEmpty ? 'From' : textControllerMin.text,
                            style: TextStyle(
                                color: textControllerMin.text.isEmpty ? Colors.grey : Colors.black,
                                fontWeight: FontWeight.w500)),
                      )),
                      textControllerMin.text.isEmpty ? IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                        onPressed: (){},
                      ) : IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.cancel, color: Colors.grey),
                        onPressed: (){
                          textControllerMin.clear();
                          onChanges('');
                        },
                      )
                    ],
                  )
              ).onTap(() async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: mDate1,
                  firstDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
                  lastDate: DateTime.now().add(Duration(days: 900)),
                );

                if (newDate != null) {
                  final newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: mDate1.hour, minute: mDate1.minute)
                  );

                  if (newTime != null) {
                    mDate1 = DateTime(newDate.year,newDate.month,newDate.day,newTime.hour,newTime.minute);
                    datetimeValue = DateUtil().getDatetimeFormatServer().format(mDate1);

                    if(mDate2.isAtSameMomentAs(mDate1.add(Duration(hours: 2))) || mDate2.isBefore(mDate1.add(Duration(hours: 2)))){
                      if(textControllerMax.text.isNotEmpty) {
                        mDate2 = mDate1.add(Duration(hours: 2));
                        textControllerMax.text = DateUtil().getDatetimeFormatServer().format(mDate2);
                        datetimeValue2 = DateUtil().getDatetimeFormatServer().format(mDate2);
                      }
                    }
                    onChanges(datetimeValue!);
                    onChanges2(datetimeValue2!);
                  }
                }
              }),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.only(left: 12),
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!)
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Marquee(
                        animationDuration: const Duration(milliseconds: 3300),
                        backDuration: const Duration(milliseconds: 3300),
                        pauseDuration: const Duration(milliseconds: 1000),
                        child: Text(textControllerMax.text.toString().isEmpty ? 'To' : textControllerMax.text,
                            style: TextStyle(
                                color: textControllerMax.text.toString().isEmpty ? Colors.grey : Colors.black,
                                fontWeight: FontWeight.w500)),
                      )),
                      textControllerMax.text.isEmpty ? IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                        onPressed: (){},
                      ) : IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.cancel, color: Colors.grey),
                        onPressed: (){
                          textControllerMax.clear();
                          datetimeValue2 = '';
                          onChanges2('');
                        },
                      )
                    ],
                  )
              ).onTap(() async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: mDate2.isAtSameMomentAs(mDate1.add(Duration(hours: 2))) || mDate2.isBefore(mDate1.add(Duration(hours: 2))) ? textControllerMin.text.isNotEmpty ? mDate1.add(Duration(hours: 2)) : DateTime.now() : mDate2,
                  firstDate: textControllerMin.text.isNotEmpty ? mDate1.add(Duration(hours: 2)) : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
                  lastDate: mDate1.add(Duration(days: 900)),
                );

                if (newDate != null) {
                  final newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: mDate2.hour, minute: mDate2.minute)
                  );

                  if (newTime != null) {
                    mDate2 = DateTime(newDate.year,newDate.month,newDate.day,newTime.hour,newTime.minute);
                    datetimeValue2 = DateUtil().getDatetimeFormatServer().format(mDate2);

                    if(mDate2.isAtSameMomentAs(mDate1.add(Duration(hours: 2))) || mDate2.isBefore(mDate1.add(Duration(hours: 2)))){
                      if(textControllerMin.text.isNotEmpty) {
                        mDate1 = mDate2.subtract(Duration(hours: 2));
                        datetimeValue2 = DateUtil().getDatetimeFormatServer().format(mDate1);
                      }
                    }

                    onChanges(datetimeValue!);
                    onChanges2(datetimeValue2!);
                  }
                }
              }),
            ),
          ],
        ),
        Divider(height: 6, thickness: 6, color: Colors.white)
      ],
    ),
  );
}
