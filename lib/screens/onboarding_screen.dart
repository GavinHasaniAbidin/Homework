import 'package:habitapp/helpers.dart';
import 'package:habitapp/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      titleWidget: Text(
        '定義您的習慣',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      image: Container(
        child: SvgPicture.asset(
          'assets/images/onboard/1.svg',
          semanticsLabel: 'Empty list',
          width: 250,
        ),
      ),
      bodyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '為了更好地堅持您的習慣，您可以定義：',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. 時間',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '2. 習慣',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '3. 獎勵',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      titleWidget: Text(
        '記錄您的日子',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      image: Container(
        child: SvgPicture.asset(
          'assets/images/onboard/2.svg',
          semanticsLabel: 'Empty list',
          width: 250,
        ),
      ),
      bodyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    color: HaboColors.primary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '成功',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.close,
                    color: HaboColors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '失敗',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.last_page,
                    color: HaboColors.skip,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '跳過（不影響接連記錄）',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: HaboColors.orange,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '留言',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "觀察你的進步",
      image: Container(
        child: SvgPicture.asset(
          'assets/images/onboard/3.svg',
          semanticsLabel: 'Empty list',
          width: 250,
        ),
      ),
      bodyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '您可以在每個習慣或歷史頁面上通過日曆視圖跟踪您的進度。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      done: const Text("完成", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        if (Provider.of<Bloc>(context, listen: false).getSeenOnboarding) {
          Navigator.pop(context);
        } else {
          Provider.of<Bloc>(context, listen: false).setSeenOnboarding = true;
        }
      },
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text("跳過"),
    );
  }
}
