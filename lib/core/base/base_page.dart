import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:kasm_poc_workspace/core/helper/provider.dart';
import 'package:kasm_poc_workspace/generated/strings.g.dart';
import 'package:rxdart/rxdart.dart';

abstract class BasePage<VM extends BaseViewModel, T extends StatefulWidget> extends State<T>
    with RouteAware {
  late final VM viewModel;
  late final ScrollController _scrollController = ScrollController();
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Getter
  GlobalKey<FormState> get formKey => _formKey;
  ScrollController get scrollController => _scrollController;
  Translations get translation => t;

  @protected
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    viewModel = getIt<VM>();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    compositeSubscription.dispose();
  }

  bool get isShowAppBar => true;

  String getAppBarTitle() => '';

  List<Widget> getAppBarActions() => [];

  PreferredSizeWidget? getAppBar(BuildContext context) {
    return isShowAppBar
        ? AppBar(
            title: Align(alignment: Alignment.centerLeft, child: Text(getAppBarTitle())),
            actionsPadding: const EdgeInsets.only(right: 40),
            automaticallyImplyLeading: true,
            actions: getAppBarActions(),
          )
        : null;
  }

  Widget buildPageContent(BuildContext context) => SizedBox();

  Widget BuildButtomNavigationBar(BuildContext context) => SizedBox();

  @override
  Widget build(BuildContext context) {
    return Provider(
      value: viewModel,
      child: Scaffold(
        appBar: getAppBar(context),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(child: buildPageContent(context)),
        ),
        bottomNavigationBar: BuildButtomNavigationBar(context),
      ),
    );
  }
}
