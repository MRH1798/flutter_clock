// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF494949),
  _Element.text: Color(0xFFCF734A),
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Color(0xFF494949),
  _Element.text: Color(0xFFCF734A),
  _Element.shadow: Colors.black,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _temperatureUnit = '';
  var _temperatureRangeHigh = '';
  var _temperatureRangeLow = '';
  var _degreeSign = '';

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      _temperature = widget.model.temperatureString.split('.')[0];
      _temperatureUnit = widget.model.temperatureString.substring(
          widget.model.temperatureString.length - 1,
          widget.model.temperatureString.length);
      _degreeSign = widget.model.temperatureString.substring(
          widget.model.temperatureString.length - 2,
          widget.model.temperatureString.length - 1);
      _temperatureRangeLow = widget.model.low.toString();
      _temperatureRangeHigh = widget.model.highString.split('°')[0];
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 6;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Alata',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 10,
          color: colors[_Element.text],
          offset: Offset(2, 2),
        ),
      ],
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: Container(
          // width: 300,
          // height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: 10,
              color: colors[_Element.background],
            ),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: colors[_Element.shadow].withOpacity(0.45),
                offset: const Offset(5.0, 5.0),
                spreadRadius: 1,
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.15),
                offset: const Offset(-5.0, -5.0),
                spreadRadius: 1,
                blurRadius: 15,
              ),
              BoxShadow(
                color: colors[_Element.shadow].withOpacity(0.25),
                offset: const Offset(0.0, 0.0),
              ),
              BoxShadow(
                color: colors[_Element.background],
                offset: const Offset(0.0, 0.0),
                spreadRadius: -8.0,
                blurRadius: 15.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DefaultTextStyle(
                    style: defaultStyle, child: Text(hour + ":" + minute)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 6.0,
                      color: colors[_Element.background],
                    ),
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: colors[_Element.shadow].withOpacity(0.4),
                        offset: const Offset(3.0, 3.0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        offset: const Offset(-3.0, -3.0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: colors[_Element.shadow].withOpacity(0.15),
                        offset: const Offset(0.0, 0.0),
                      ),
                      BoxShadow(
                        color: colors[_Element.background],
                        offset: const Offset(0.0, 0.0),
                        spreadRadius: -5.0,
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 12.0, left: 48, right: 48),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$_temperature' +
                              '$_degreeSign' +
                              '$_temperatureUnit',
                          style: TextStyle(
                              color: Color(0xFF707070),
                              fontFamily: 'Typewriter',
                              fontSize: MediaQuery.of(context).size.width / 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 1),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                '$_temperatureRangeHigh' +
                                    '$_degreeSign' +
                                    '$_temperatureUnit',
                                style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontFamily: 'Typewriter',
                                    fontSize:
                                        MediaQuery.of(context).size.width / 50,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '$_temperatureRangeLow' +
                                    '$_degreeSign' +
                                    '$_temperatureUnit',
                                style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontFamily: 'Typewriter',
                                    fontSize:
                                        MediaQuery.of(context).size.width / 50,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // child: Center(
      //   child: DefaultTextStyle(
      //     style: defaultStyle,
      //     child: Stack(
      //       children: <Widget>[
      //         Positioned(left: offset, top: 0, child: Text(hour)),
      //         Positioned(right: offset, bottom: offset, child: Text(minute)),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
