import 'package:emogotchi/api/api.dart';
import 'package:emogotchi/provider/uuid_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  final Set<DateTime> dataAvailableDays;
  final Map<String, Map<String, String>> emotionAndSummaryByDate;
  final String animalType;

  const CalendarPage({
    Key? key,
    required this.dataAvailableDays,
    required this.emotionAndSummaryByDate,
    required this.animalType,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDataAvailable(DateTime day) {
    return emotionAndSummaryByDate.containsKey(_formatDate(day));
  }

  String _getEmotion(DateTime day) {
    return emotionAndSummaryByDate[_formatDate(day)]?['emotion'] ?? '';
  }

  String _getSummary(DateTime day) {
    return emotionAndSummaryByDate[_formatDate(day)]?['summary'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDay;
    DateTime focusedDay = DateTime.now(); // 🔹 상태로 분리
    CalendarFormat calendarFormat = CalendarFormat.month;

    return StatefulBuilder(
      builder: (context, setState) {
        final today = DateTime.now();

        return SafeArea(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 8 &&
                  calendarFormat != CalendarFormat.month) {
                setState(() {
                  calendarFormat = CalendarFormat.month;
                });
              }
            },
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime(2024, 1, 1),
                  lastDay: DateTime(2025, 12, 31),
                  focusedDay: focusedDay, // 🔹 수정
                  calendarFormat: calendarFormat,
                  eventLoader: (day) => [],
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedDayPredicate: (day) =>
                      selectedDay != null && _isSameDay(day, selectedDay!),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      focusedDay = focused; // 🔹 주간 이동 반영
                      calendarFormat = CalendarFormat.week;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) =>
                        _buildDayCell(day, selectedDay, today, false, false),
                    todayBuilder: (context, day, _) =>
                        _buildDayCell(day, selectedDay, today, true, false),
                    selectedBuilder: (context, day, _) =>
                        _buildDayCell(day, selectedDay, today, false, true),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: selectedDay == null
                          ? const Text(
                              'Select a date',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isSameDay(selectedDay!, today)) // 오늘 선택
                                    _isDataAvailable(today)
                                        ? Text(
                                            _getSummary(today),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        : Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final uuidProvider = Provider
                                                      .of<DeviceInfoProvider>(
                                                          context,
                                                          listen: false);
                                                  await uuidProvider
                                                      .fetchDeviceUuid();
                                                  final uuid =
                                                      uuidProvider.uuid;

                                                  if (uuid == null ||
                                                      uuid.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "UUID를 불러올 수 없습니다.")),
                                                    );
                                                    return;
                                                  }

                                                  try {
                                                    final api = ApiService();
                                                    final diary = await api
                                                        .generateDiary(uuid);

                                                    final generatedDate =
                                                        diary['date'];
                                                    final summary =
                                                        diary['summary'];
                                                    final emotion =
                                                        diary['emotion'];

                                                    final parts = generatedDate
                                                        .split('-');
                                                    final dateTime = DateTime(
                                                      int.parse(parts[0]),
                                                      int.parse(parts[1]),
                                                      int.parse(parts[2]),
                                                    );

                                                    setState(() {
                                                      dataAvailableDays
                                                          .add(dateTime);
                                                      emotionAndSummaryByDate[
                                                          generatedDate] = {
                                                        'summary': summary,
                                                        'emotion': emotion,
                                                      };
                                                    });

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "일기가 성공적으로 생성되었습니다.")),
                                                    );
                                                  } catch (e) {
                                                    print(
                                                        "Diary generation error: $e");
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "일기 생성에 실패했습니다.")),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                                ),
                                                child: const Text(
                                                  'Generate Journal',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                'Automatically generated daily at midnight',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          )
                                  else // 오늘 아닌 날짜
                                    _isDataAvailable(selectedDay!)
                                        ? Text(
                                            _getSummary(selectedDay!),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            "You don't have a journal on ${_formatDate(selectedDay!)}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCell(
    DateTime day,
    DateTime? selectedDay,
    DateTime today,
    bool isToday,
    bool isSelected,
  ) {
    final isActualToday = _isSameDay(day, today);
    final dateKey = _formatDate(day);
    final bool hasData = emotionAndSummaryByDate.containsKey(dateKey);
    final String emotion =
        emotionAndSummaryByDate[dateKey]?['emotion']?.toLowerCase() ?? '';
    final String imagePath =
        'assets/$animalType/${animalType}_${emotion.isNotEmpty ? emotion : 'eye_open'}.png';

    final image = Image.asset(
      imagePath,
      height: 55,
      width: 55,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/$animalType/${animalType}_eye_open.png',
          height: 55,
          width: 55,
          fit: BoxFit.cover,
        );
      },
    );

    final Widget filteredImage = hasData
        ? image
        : ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color(0xFFDDDDDD),
              BlendMode.srcIn,
            ),
            child: image,
          );

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isActualToday
            ? Colors.orangeAccent.withOpacity(0.8)
            : isSelected
                ? Colors.deepOrangeAccent.withOpacity(0.5)
                : null,
        border: isSelected
            ? Border.all(color: Colors.deepOrangeAccent, width: 3)
            : null,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!isActualToday && !isSelected) filteredImage,
          if (hasData && !isActualToday && !isSelected)
            Positioned(
              bottom: 4,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: isActualToday || isSelected
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
