import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/features/activity/data/model/event_item_model.dart';
import 'package:kasm_poc_workspace/features/activity/presentation/widget/activity_event_card_widget.dart';

@Named(RouterName.ActivityPage)
@Injectable(as: NavAble)
class HomeNavigator implements NavAble {
  @override
  Widget get(argument) => const ActivityPage();
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final _appNavigator = getIt<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Upcoming, Past
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'My Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),

              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: SizedBox(width: 100, child: Center(child: Text('Upcoming'))),
                  ),
                  Tab(
                    child: SizedBox(width: 100, child: Center(child: Text('Past'))),
                  ),
                ],
              ),

              const Expanded(child: TabBarView(children: [UpcomingTab(), PastTab()])),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingTab extends StatelessWidget {
  const UpcomingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final data = _mockUpcoming();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ActivityEventCardWidget(
          item: item,
          onTap: () {
            // Dakoow Navigate to details to do
          },
        );
      },
    );
  }

  List<EventItem> _mockUpcoming() => [
    EventItem(
      dateTime: DateTime(DateTime.now().year, 11, 15, 19, 0),
      title: '2025 ZEROBASEONE WORLD TOUR [HERE&NOW] IN SINGAPORE',
      venue: 'Singapore Indoor Stadium',
      imageUrl: null,
      hasTicketQr: true,
    ),
    EventItem(
      dateTime: DateTime(DateTime.now().year, 12, 2, 20, 0),
      title: 'Sample Upcoming Event',
      venue: 'Bangkok Arena',
      imageUrl: 'https://picsum.photos/id/1025/800/450',
      hasTicketQr: false,
    ),
  ];
}

class PastTab extends StatelessWidget {
  const PastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final data = _mockPast();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ActivityEventCardWidget(
          item: item,
          onTap: () {
            // Dakoow Navigate to details to do
          },
        );
      },
    );
  }

  List<EventItem> _mockPast() => [
    EventItem(
      dateTime: DateTime(DateTime.now().year, 9, 12, 14, 0),
      title: 'Past Conference 2025',
      venue: 'Marina Bay Sands',
      imageUrl: 'https://picsum.photos/id/1003/800/450',
      hasTicketQr: false,
    ),
    EventItem(
      dateTime: DateTime(DateTime.now().year, 8, 4, 18, 30),
      title: 'Music Night',
      venue: 'The Playhouse',
      imageUrl: null,
      hasTicketQr: true,
    ),
  ];
}
