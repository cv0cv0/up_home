import 'package:flutter/material.dart';

const _kExpand = Duration(milliseconds: 200);

class ExpansionTile extends StatefulWidget {
  const ExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.trailing,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.children = const <Widget>[],
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final Widget trailing;
  final bool initiallyExpanded;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _easeInAnimation;
  ColorTween _iconColor;
  ColorTween _headerColor;
  Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeInAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _iconColor = ColorTween();
    _headerColor = ColorTween();
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);

    _isExpanded =
        PageStorage.of(context).readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _iconColor
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _headerColor
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;

    final closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded)
        _controller.forward();
      else
        _controller.reverse().then((value) => setState(() {}));

      PageStorage.of(context).writeState(context, _isExpanded);
    });

    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final titleColor = _headerColor.evaluate(_easeInAnimation);
    return Column(
      children: <Widget>[
        IconTheme.merge(
          data: IconThemeData(color: _iconColor.evaluate(_easeInAnimation)),
          child: InkWell(
            onTap: _handleTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: <Widget>[
                  widget.leading,
                  SizedBox( width: 8.0),
                  Expanded(
                    child: DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: titleColor),
                      child: widget.title,
                    ),
                  ),
                  widget.trailing ??
                      RotationTransition(
                        turns: _iconTurns,
                        child: const Icon(Icons.expand_more),
                      ),
                ],
              ),
            ),
          ),
        ),
        ClipRect(
          child: Align(
            heightFactor: _easeInAnimation.value,
            child: child,
          ),
        ),
      ],
    );
  }
}
