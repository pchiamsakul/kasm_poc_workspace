import 'package:injectable/injectable.dart';

import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';

class MockupPageArguments {
  final String? title;
  final String? nextPage;

  MockupPageArguments(this.title, this.nextPage);
}

@Named(RouterName.MockupPage)
@Injectable(as: NavAble)
class MockupPageNavAble implements NavAble {
  @override
  Widget get(dynamic arguments) {
    final args = arguments as MockupPageArguments?;
    return MockupPage(
      title: args?.title,
      nextPage: args?.nextPage,
    );
  }
}

class MockupPage extends StatefulWidget {
  final String? title;
  final String? nextPage;

  const MockupPage({
    super.key,
    this.title,
    this.nextPage,
  });

  @override
  State<MockupPage> createState() => _MockupPageState();
}

class _MockupPageState extends State<MockupPage> {
  
  final _appNavigator = getIt<AppNavigator>();

  void _navigateToNextPage() {
    if (widget.nextPage != null) {
      _appNavigator.pushNamed(widget.nextPage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title ?? 'Mockup Page',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            if (widget.nextPage != null)
              ElevatedButton(
                onPressed: _navigateToNextPage,
                child: const Text('Next'),
              ),
          ],
        ),
      ),
    );
  }
}

