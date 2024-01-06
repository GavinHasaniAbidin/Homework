import 'package:habitapp/habit_data.dart';
import 'package:habitapp/helpers.dart';
import 'package:habitapp/provider.dart';
import 'package:habitapp/widgets/text_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditHabitScreen extends StatefulWidget {
  EditHabitScreen({Key key, this.habitData}) : super(key: key);

  final HabitData habitData;

  @override
  _EditHabitScreenState createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController cue = TextEditingController();
  TextEditingController routine = TextEditingController();
  TextEditingController reward = TextEditingController();
  TimeOfDay notTime = TimeOfDay(hour: 12, minute: 0);
  bool twoDayRule = false;
  bool showReward = false;
  bool advanced = false;
  bool notification = false;

  Future<void> setNotificationTime(context) async {
    TimeOfDay selectedTime;
    TimeOfDay initialTime = notTime;
    selectedTime = await showTimePicker(
        context: context,
        initialTime: (initialTime != null)
            ? initialTime
            : TimeOfDay(hour: 20, minute: 0));
    if (selectedTime != null) {
      setState(() {
        notTime = selectedTime;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    title.text = widget.habitData.title;
    cue.text = widget.habitData.cue;
    routine.text = widget.habitData.routine;
    reward.text = widget.habitData.reward;
    twoDayRule = widget.habitData.twoDayRule;
    showReward = widget.habitData.showReward;
    advanced = widget.habitData.advanced;
    notification = widget.habitData.notification;
    notTime = widget.habitData.notTime;
  }

  @override
  void dispose() {
    title.dispose();
    cue.dispose();
    routine.dispose();
    reward.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '編輯習慣',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.delete,
              semanticLabel: '刪除',
            ),
            color: HaboColors.red,
            tooltip: 'Delete',
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Bloc>(context, listen: false)
                  .deleteHabit(widget.habitData.id);
            },
          ),
        ],
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            if (title.text.length != 0) {
              Provider.of<Bloc>(context, listen: false).editHabit(
                HabitData(
                    id: widget.habitData.id,
                    title: title.text.toString(),
                    twoDayRule: twoDayRule,
                    cue: cue.text.toString(),
                    routine: routine.text.toString(),
                    reward: reward.text.toString(),
                    showReward: showReward,
                    advanced: advanced,
                    notification: notification,
                    notTime: notTime),
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  behavior: SnackBarBehavior.floating,
                  content: Text("習慣名稱不得為空。"),
                ),
              );
            }
          },
          child: Icon(
            Icons.check,
            semanticLabel: 'Save',
            color: Colors.white,
            size: 35.0,
          ),
        );
      }),
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                TextContainer(
                  title: title,
                  hint: '例：運動',
                  label: '習慣',
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            twoDayRule = value;
                          });
                        },
                        value: twoDayRule,
                      ),
                      Text("用兩天法則"),
                      Tooltip(
                        child: const Icon(
                          Icons.info,
                          color: Colors.grey,
                          size: 18,
                        ),
                        message:
                            "你想培養的習慣的休息日不可以連續超過一天。",
                      ),
                    ],
                  ),
                ),
                Container(
                  child: ExpansionTile(
                    title: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        "高級習慣設置",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    initiallyExpanded: advanced,
                    onExpansionChanged: (bool value) {
                      advanced = value;
                    },
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Center(
                          child: const Text(
                            "本節幫助您更好地定義您的習慣。 您應該為每個習慣定義時間、例程與獎勵。",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      TextContainer(
                        title: cue,
                        hint: '例：早上7點',
                        label: '時間',
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 25),
                        title: Text("提醒"),
                        trailing: Switch(
                            value: notification,
                            onChanged: (value) {
                              notification = value;
                              setState(() {});
                            }),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 25),
                        enabled: notification,
                        title: Text("提醒時間"),
                        trailing: InkWell(
                          onTap: () {
                            if (notification) {
                              setNotificationTime(context);
                            }
                          },
                          child: Text(
                            notTime.hour.toString().padLeft(2, '0') +
                                ":" +
                                notTime.minute.toString().padLeft(2, '0'),
                            style: TextStyle(
                                color: (notification)
                                    ? null
                                    : Theme.of(context).disabledColor),
                          ),
                        ),
                      ),
                      TextContainer(
                        title: routine,
                        hint: '例：做50次俯臥撐',
                        label: '習慣',
                      ),
                      TextContainer(
                        title: reward,
                        hint: '例：可以打游戲15分鐘',
                        label: '獎勵',
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (bool value) {
                                setState(() {
                                  showReward = value;
                                });
                              },
                              value: showReward,
                            ),
                            Text("顯示獎勵"),
                            Tooltip(
                              child: Icon(
                                Icons.info,
                                semanticLabel: 'Tooltip',
                                color: Colors.grey,
                                size: 18,
                              ),
                              message:
                                  "習慣成功後可以提醒獎勵。",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
