import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:advanced_components_and_theming/Rally/constants.dart';
import 'package:advanced_components_and_theming/Rally/tab_pages/accounts_page.dart';
import 'package:advanced_components_and_theming/Rally/tab_pages/bills_page.dart';
import 'package:advanced_components_and_theming/Rally/tab_pages/budgets_page.dart';
import 'package:advanced_components_and_theming/Rally/tab_pages/overview_page.dart';
import 'package:advanced_components_and_theming/Rally/tab_pages/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  _HomePageState() {
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    print('_HomePageState initState');

    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _tabController.previousIndex != _tabController.index) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
              children: <Widget>[
                Theme(
                  // This theme effectively removes the default visual touch
                  // feedback for tapping a tab, which is replaced with a custom
                  // animation.
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: TabBar(
                    // setting isScrollable to true prevents the tabs from being
                    // wrapped in [Expanded] widgets, which allows for more
                    // flexible sizes and size animations among tabs.
                    isScrollable: true,
                    labelPadding: EdgeInsets.zero,
                    tabs: _buildTabs(),
                    controller: _tabController,
                    // This effectively removes the tab indicator.
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(style: BorderStyle.none)
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                      children: _buildTabViews(),
                      controller: _tabController
                  ),
                )
              ]),
        )
    );
  }

  // TODO(clocksmith): Use icons
  List<Widget> _buildTabs() {
    return <Widget>[
      _buildTab(Image.asset("assets/ic_pie_chart_24px.png"), "OVERVIEW", 0),
      _buildTab(Image.asset("assets/ic_attach_money_24px.png"), "ACCOUNTS", 1),
      _buildTab(Image.asset("assets/ic_money_off_24px.png"), "BILLS", 2),
      _buildTab(Image.asset("assets/ic_bar_chart_24px.png"), "BUDGETS", 3),
      _buildTab(Image.asset("assets/ic_settings_24px.png"), "SETTINGS", 4),
    ];
  }

  List<Widget> _buildTabViews() {
    return <Widget>[
      OverviewPage(),
      AccountsPage(),
      BillsPage(),
      BudgetsPage(),
      SettingsPage(),
    ];
  }

  Widget _buildTab(Image tabImage, String title, int index) {
    return _RallyTab(tabImage, title, _tabController.index == index);
  }
}

class _RallyTab extends StatefulWidget {
  Text titleText;
  Image iconImage;
  bool isExpanded;

  _RallyTab(
      Image iconImage,
      String title,
      bool isExpanded) {
    titleText = Text(title);
    this.iconImage = iconImage;
    this.isExpanded = isExpanded;
  }

  _RallyTabState createState() => _RallyTabState();
}

class _RallyTabState extends State<_RallyTab> with SingleTickerProviderStateMixin {
  Animation<double> _titleSizeAnimation;
  Animation<double> _titleFadeAnimation;
  // TODO(clocksmith): Use this to animate the opacity of the icons
  Animation<double> _iconFadeAnimation;
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: Constants.defaultAnimationMillis),
        vsync: this
    );
    _titleSizeAnimation = CurvedAnimation(
        parent: Tween(begin: 0.0, end: 1.0).animate(_controller),
        curve: Curves.linear
    );
    _titleFadeAnimation = CurvedAnimation(
        parent: Tween(begin: 0.0, end: 1.0).animate(_controller),
        curve: Curves.easeOut
    );
    _iconFadeAnimation = CurvedAnimation(
        parent: Tween(begin: 0.6, end: 1.0).animate(_controller),
        curve: Curves.linear
    );
    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_RallyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 56.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: width / 7,
            child: widget.iconImage,
          ),
          FadeTransition(
            child: SizeTransition(
              child: SizedBox(
                width: width / 4,
                child: Center(child: widget.titleText),
              ),
              axis: Axis.horizontal,
              axisAlignment: -1.0,
              sizeFactor: _titleSizeAnimation,
            ),
            opacity: _titleFadeAnimation,

          ),

        ],
      ),
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

