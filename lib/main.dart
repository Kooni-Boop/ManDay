import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2020, 10, 27): ['holiday example'],
};

void main() => initializeDateFormatting().then((_) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Title'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _events = {
      _selectedDay.subtract(Duration(days: -1)): ['D-Day1'],
    };
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {print('CALLBACK: _onDaySelected');
    setState(() {_selectedEvents = events;}
    );
  }
  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    setState(() {
      _MyHomePageState();
    });
  }
  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  // DateTime now = DateTime.now();
  // String _formattedDate = DateFormat('yyyy년 MMMM', 'ko_KR').format(DateTime.now());
  // DateTime _focusedDay;
  // DateTime get focusedDay => _focusedDay;
  // void dateFormatter() {
  //   _calendarController.focusedDay;
  // }
  //todo:implement appbar title rebuild
  String _formattedDate = DateFormat('yyyy년 MMMM', 'ko_KR').format(DateTime.now());
  // String _formattedDate = DateFormat('yyyy년 MMMM', 'ko_KR').format(dateFormatter());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_formattedDate)
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildButtons(),
          const SizedBox(height: 8.0),
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    final dateTime = DateTime.now();
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('월별'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2주씩'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('1주씩'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
            RaisedButton(
              child: Text('오늘'),
              onPressed: () {
                _calendarController.setSelectedDay(
                  DateTime(dateTime.year, dateTime.month, dateTime.day),
                  runCallback: true,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TableCalendar(
        headerVisible: false,
        locale: 'ko_KR',
        rowHeight: 80,
        calendarController: _calendarController,
        events: _events,
        holidays: _holidays,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          selectedColor: Colors.deepOrange[400],
          todayColor: Colors.blue,
          markersColor: Colors.red,
          outsideDaysVisible: true,
        ),
        headerStyle: HeaderStyle(
          formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepOrange[400],
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onDaySelected: _onDaySelected,
        onVisibleDaysChanged: _onVisibleDaysChanged,
        onCalendarCreated: _onCalendarCreated,
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      )
      ).toList(),
    );
  }
}