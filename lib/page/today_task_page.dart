import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/order.dart';
import '../util/const.dart';
import '../widget/circle_text.dart';
import '../widget/order_items.dart';

class TodayTaskPage extends StatefulWidget {
  @override
  _TodayTaskPageState createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage>
    with SingleTickerProviderStateMixin {
  final searchDelegate = _TaskSearchDelegate();
  TabController tabController;

  final List<_Page> _pages = [
    _Page(type: OrderStatus.receive, orders: <Order>[]),
    _Page(type: OrderStatus.booking, orders: <Order>[]),
    _Page(type: OrderStatus.sign, orders: <Order>[]),
    _Page(type: OrderStatus.complete, orders: <Order>[]),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: _pages.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) _initPage(tabController.index);
    });
    _initPage(0);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('今日任务'),
          actions: <Widget>[
            IconButton(
              tooltip: '搜索',
              icon: const Icon(Icons.search),
              padding: const EdgeInsets.all(16.0),
              onPressed: () => showSearch(
                    context: context,
                    delegate: searchDelegate,
                  ),
            )
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: _pages
                .map((page) => _Tab(
                    text: '待${orderStatusToString(page.type)}',
                    count: page.orders.length))
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: _pages.map((page) {
            if (page.orders.isEmpty)
              return const Center(
                child: CircularProgressIndicator(),
              );

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              itemCount: page.orders.length * 2,
              itemBuilder: (context, index) {
                if (index.isOdd) return Divider();

                final i = index ~/ 2;
                switch (page.type) {
                  case OrderStatus.receive:
                  case OrderStatus.booking:
                    return StatusOrderItem(order: page.orders[i]);
                  case OrderStatus.sign:
                    return SignOrderItem(order: page.orders[i]);
                  case OrderStatus.complete:
                    return CompleteOrderItem(order: page.orders[i]);
                }
              },
            );
          }).toList(),
        ),
      );

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _initPage(int index) {
    final page = _pages[index];
    final orders = page.orders;
    if (orders.isEmpty) {
      Future.delayed(
          Duration(seconds: 2),
          () => setState(() {
                orders.addAll(List.generate(
                    Random().nextInt(9) + 1,
                    (i) => Order(
                        page.type,
                        'TM1233012330012',
                        1,
                        i == 1
                            ? DateTime.now()
                            : DateTime.now().add(Duration(hours: 2)),
                        '浙江省杭州市上城区',
                        '已接单',
                        DateTime.now(),
                        DateTime.now(),
                        DateTime.now())));
              }));
    }
  }
}

class _Tab extends StatelessWidget {
  const _Tab({this.text, this.count});

  static const _tabHeight = 46.0;

  final String text;
  final int count;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _tabHeight,
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(text),
            ),
            count == 0
                ? SizedBox()
                : Positioned(
                    top: 4.0,
                    right: 6.0,
                    child: CircleText(
                      text: count.toString(),
                    ),
                  ),
          ],
        ),
      );
}

class _TaskSearchDelegate extends SearchDelegate<String> {
  _TaskSearchDelegate() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      _history = _prefs.getStringList(search_history) ?? [];
    });
  }

  SharedPreferences _prefs;
  List<String> _history;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isNotEmpty
        ? <Widget>[
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          ]
        : null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _history
        : _history.where((text) => text.contains(query));

    return _SuggestionListView(
      query: query,
      suggestions: suggestions.toList(),
      onClear: (suggestion) {
        _history.remove(suggestion);
        _prefs.setStringList(search_history, _history);
      },
      onSelected: (suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return null;
    if (!_history.contains(query)) {
      _history.add(query);
      _prefs.setStringList(search_history, _history);
    }

    return Center(
      child: Text(query, style: Theme.of(context).textTheme.headline),
    );
  }
}

class _SuggestionListView extends StatefulWidget {
  const _SuggestionListView({
    this.query,
    this.suggestions,
    this.onClear,
    this.onSelected,
  });

  final String query;
  final List<String> suggestions;
  final ValueChanged<String> onClear;
  final ValueChanged<String> onSelected;

  @override
  State<StatefulWidget> createState() => _SuggestionListViewState();
}

class _SuggestionListViewState extends State<_SuggestionListView> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      itemCount: widget.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = widget.suggestions[index];
        final queryStartIndex = suggestion.indexOf(widget.query);
        final queryEndIndex = queryStartIndex + widget.query.length;
        return ListTile(
          onTap: () => widget.onSelected(suggestion),
          leading: const Icon(Icons.history),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() => widget.suggestions.remove(suggestion));
              widget.onClear(suggestion);
            },
          ),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, queryStartIndex),
              style: textTheme.subhead,
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(queryStartIndex, queryEndIndex),
                  style:
                      textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: suggestion.substring(queryEndIndex),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Page {
  const _Page({this.type, this.orders});

  final OrderStatus type;
  final List<Order> orders;
}
