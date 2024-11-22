import 'package:flutter/material.dart';
import 'package:projekakhirpam_124220134/JSON/users.dart';
import 'package:projekakhirpam_124220134/componen/color.dart';
import 'package:projekakhirpam_124220134/views/Profile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarScreen extends StatefulWidget {
  final Users? profile;
  const CalendarScreen({super.key,this.profile});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};
  Set<DateTime> _holidayDates = {}; // Hari libur
  Map<DateTime, String> _holidayDetails = {}; // Detail liburan

  @override
  void initState() {
    super.initState();
    _fetchHolidays();
  }

  /// Mengambil data hari libur dari API
  Future<void> _fetchHolidays() async {
    const url =
        'https://raw.githubusercontent.com/guangrei/APIHariLibur_V2/main/holidays.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _holidayDates.clear();
          _holidayDetails.clear();

          data.forEach((key, value) {
            if (key != 'info') {
              final date = DateTime.parse(key);
              _holidayDates.add(DateTime(date.year, date.month, date.day));
              _holidayDetails[DateTime(date.year, date.month, date.day)] =
                  value['summary'] ?? '';
            }
          });
        });
      } else {
        print('Failed to fetch holidays: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching holidays: $e');
    }
  }

  /// Menambahkan catatan ke tanggal tertentu
  void _addEvent(String event) {
    setState(() {
      if (_events[_selectedDay] != null) {
        _events[_selectedDay]!.add(event);
      } else {
        _events[_selectedDay] = [event];
      }
    });
  }

  /// Menampilkan catatan atau hari libur untuk tanggal tertentu
  List<String> _getEventsForDay(DateTime day) {
    final events = _events[day] ?? [];
    if (_holidayDates.contains(DateTime(day.year, day.month, day.day))) {
      final holidayDetail =
          _holidayDetails[DateTime(day.year, day.month, day.day)];
      if (holidayDetail != null) {
        return [holidayDetail, ...events];
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalendar kegiatan',style: TextStyle(color: Colors.white),),
      backgroundColor: primaryColor,
      automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Container(
          color: primaryColor,
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarScreen()));
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //icon home
                    Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    Text(
                      'Homepage',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (context) => AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                          )
                      ],
                      title: const Text('Kesan pesan & saran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                      contentPadding: const EdgeInsets.all(20),
                      content: const Text('Menurut saya PAM ini memberikan kesan serba otodidak, dan hal itu membuat banyak mahasiswa yang tertantang untuk mengulik dan mencari informasi, termasuk saya. saya jadi lumayan menyukai ngoding walaupun dahulu saya ga suka ngoding. Saran saya mungkin bisa di buka kelas tambahan di luar jam kuliah pak, hehe',
                      textAlign: TextAlign.justify,),
                    ),
                    );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: Colors.white,
                    ),
                    Text('Kesan Pesan', style: TextStyle(color: Colors.white))
                  ],
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile(profile: widget.profile,)));
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    Text('Profil', style: TextStyle(color: Colors.white))
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                // Tambahkan latar belakang merah untuk hari libur
                final isHoliday = _holidayDates
                    .contains(DateTime(day.year, day.month, day.day));
                if (isHoliday) {
                  return Stack(
                    children: [
                      // Indikator merah di belakang angka tanggal
                      Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  );
                }
                return null;
              },
              selectedBuilder: (context, day, focusedDay) {
                return Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay)
                  .map((event) => ListTile(
                        title: Text(event),
                        leading: Icon(
                          _holidayDates.contains(_selectedDay)
                              ? Icons.flag
                              : Icons.event,
                          color: _holidayDates.contains(_selectedDay)
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController eventController =
                  TextEditingController();
              return AlertDialog(
                title: Text('Add Event'),
                content: TextField(
                  controller: eventController,
                  decoration: InputDecoration(hintText: 'Enter event'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addEvent(eventController.text.trim());
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}