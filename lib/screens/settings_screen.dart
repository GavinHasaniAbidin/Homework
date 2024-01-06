import 'package:habitapp/helpers.dart';
import 'package:habitapp/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  Future<void> testTime(context) async {
    TimeOfDay selectedTime;
    TimeOfDay initialTime =
        Provider.of<Bloc>(context, listen: false).getDailyNot;
    selectedTime = await showTimePicker(
        context: context,
        initialTime: (initialTime != null)
            ? initialTime
            : TimeOfDay(hour: 20, minute: 0));
    if (selectedTime != null)
      Provider.of<Bloc>(context, listen: false).setDailyNot = selectedTime;
  }

  showRestoreDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: "注意！",
      desc: "所有習慣都將被備份的習慣所取代。",
      btnOkText: "恢復",
      btnCancelText: "取消",
      btnCancelColor: Colors.grey,
      btnOkColor: HaboColors.primary,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        context.loaderOverlay.show();
        await Provider.of<Bloc>(context, listen: false).loadBackup();
        context.loaderOverlay.hide();
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: CircularProgressIndicator(
          color: HaboColors.primary,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '設定',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          backgroundColor: Colors.transparent,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("主題"),
                trailing: DropdownButton<String>(
                  items: Provider.of<Bloc>(context)
                      .getThemeList
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                  value: Provider.of<Bloc>(context).getTheme,
                  onChanged: (value) {
                    Provider.of<Bloc>(context, listen: false).setTheme = value;
                  },
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("一周的第一天"),
                    SizedBox(width: 5),
                    Tooltip(
                      child: Icon(
                        Icons.info,
                        color: Colors.grey,
                        size: 18,
                      ),
                      message:
                          "該設置將在應用重啟後生效。",
                    ),
                  ],
                ),
                trailing: DropdownButton<String>(
                  alignment: Alignment.center,
                  items: Provider.of<Bloc>(context)
                      .getWeekStartList
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      alignment: Alignment.center,
                      value: value,
                      child: new Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                  value: Provider.of<Bloc>(context).getWeekStart,
                  onChanged: (value) {
                    Provider.of<Bloc>(context, listen: false).setWeekStart =
                        value;
                  },
                ),
              ),
              ListTile(
                title: Text("提醒"),
                trailing: Switch(
                  value: Provider.of<Bloc>(context).getShowDailyNot,
                  onChanged: (value) {
                    Provider.of<Bloc>(context, listen: false).setShowDailyNot =
                        value;
                  },
                ),
              ),
              ListTile(
                enabled: Provider.of<Bloc>(context).getShowDailyNot,
                title: Text("提醒時間"),
                trailing: InkWell(
                  onTap: () {
                    if (Provider.of<Bloc>(context, listen: false)
                        .getShowDailyNot) {
                      testTime(context);
                    }
                  },
                  child: Text(
                    Provider.of<Bloc>(context)
                            .getDailyNot
                            .hour
                            .toString()
                            .padLeft(2, '0') +
                        ":" +
                        Provider.of<Bloc>(context)
                            .getDailyNot
                            .minute
                            .toString()
                            .padLeft(2, '0'),
                    style: TextStyle(
                        color: (Provider.of<Bloc>(context).getShowDailyNot)
                            ? null
                            : Theme.of(context).disabledColor),
                  ),
                ),
              ),
              ListTile(
                title: Text("提醒聲音"),
                trailing: Switch(
                  value: Provider.of<Bloc>(context).getSoundEffects,
                  onChanged: (value) {
                    Provider.of<Bloc>(context, listen: false).setSoundEffects =
                        value;
                  },
                ),
              ),
              ListTile(
                title: Text("顯示月份名稱"),
                trailing: Switch(
                  value: Provider.of<Bloc>(context).getShowMonthName,
                  onChanged: (value) {
                    Provider.of<Bloc>(context, listen: false).setShowMonthName =
                        value;
                  },
                ),
              ),
              ListTile(
                title: Text("備份"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        Provider.of<Bloc>(context, listen: false)
                            .createBackup();
                      },
                      child: Text(
                        '創建',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        showRestoreDialog(context);
                      },
                      child: Text(
                        '恢復',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("歡迎頁面"),
                onTap: () {
                  navigateToOnboarding(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
