import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/src/era_mode.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';

class FlutterRoundedDatePickerHeader extends StatelessWidget {
  const FlutterRoundedDatePickerHeader(
      {Key key,
        @required this.selectedDate,
        @required this.mode,
        @required this.onModeChanged,
        @required this.orientation,
        this.era,
        this.borderRadius,
        this.imageHeader,
        this.description = "",
        this.fontFamily,
        this.style})
      : assert(selectedDate != null),
        assert(mode != null),
        assert(orientation != null),
        super(key: key);

  final DateTime selectedDate;
  final DatePickerMode mode;
  final ValueChanged<DatePickerMode> onModeChanged;
  final Orientation orientation;
  final MaterialRoundedDatePickerStyle style;

  /// Era custom
  final EraMode era;

  /// Border
  final double borderRadius;

  ///  Header
  final ImageProvider imageHeader;

  /// Header description
  final String description;

  /// Font
  final String fontFamily;

  void _handleChangeMode(DatePickerMode value) {
    if (value != mode) onModeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    double sizeMultiplier = MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width / 320 : MediaQuery.of(context).size.width / 568;

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextTheme headerTextTheme = themeData.primaryTextTheme;
    Color dayColor;
    Color yearColor;
    switch (themeData.primaryColorBrightness) {
      case Brightness.light:
        dayColor = mode == DatePickerMode.day ? Colors.black87 : Colors.black54;
        yearColor = mode == DatePickerMode.year ? Colors.black87 : Colors.black54;
        break;
      case Brightness.dark:
        dayColor = mode == DatePickerMode.day ? Colors.white : Colors.white70;
        yearColor = mode == DatePickerMode.year ? Colors.white : Colors.white70;
        break;
    }

    if (style?.textStyleDayButton?.color != null) {
      style?.textStyleDayButton = style?.textStyleDayButton?.copyWith(color: dayColor);
    }

    if (style?.textStyleDayButton?.fontFamily != null) {
      style?.textStyleDayButton = style?.textStyleDayButton?.copyWith(fontFamily: fontFamily);
    }

    final TextStyle dayStyle = style?.textStyleDayButton ?? headerTextTheme.display1.copyWith(color: dayColor, fontFamily: fontFamily, fontSize: 20 * sizeMultiplier);
    final TextStyle yearStyle = style?.textStyleYearButton ?? headerTextTheme.subhead.copyWith(color: yearColor, fontFamily: fontFamily, fontSize: 16 * sizeMultiplier);

    Color backgroundColor;
    switch (themeData.brightness) {
      case Brightness.light:
        backgroundColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        backgroundColor = themeData.backgroundColor;
        break;
    }

    EdgeInsets padding;
    MainAxisAlignment mainAxisAlignment;
    switch (orientation) {
      case Orientation.portrait:
        padding = style?.paddingDateYearHeader ?? EdgeInsets.symmetric(horizontal: 16.0);
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Orientation.landscape:
        padding = style?.paddingDateYearHeader ?? EdgeInsets.symmetric(horizontal: 8.0);
        mainAxisAlignment = MainAxisAlignment.start;
        break;
    }

    final Widget yearButton = IgnorePointer(
      ignoring: mode != DatePickerMode.day,
      ignoringSemantics: false,
      child: _DateHeaderButton(
        color: Colors.transparent,
        onTap: Feedback.wrapForTap(
              () => _handleChangeMode(DatePickerMode.year),
          context,
        ),
        child: Semantics(
          selected: mode == DatePickerMode.year,
          child: Text(
            "${calculateYearEra(era, selectedDate.year)}",
            textScaleFactor: MediaQuery.of(context).textScaleFactor > 2 ? 2 : MediaQuery.of(context).textScaleFactor,
            style: yearStyle,
          ),
        ),
      ),
    );

    final Widget dayButton = IgnorePointer(
      ignoring: mode == DatePickerMode.day,
      ignoringSemantics: false,
      child: _DateHeaderButton(
        color: Colors.transparent,
        onTap: Feedback.wrapForTap(
              () => _handleChangeMode(DatePickerMode.day),
          context,
        ),
        child: Semantics(
          selected: mode == DatePickerMode.day,
          child: Text(
            localizations.formatMediumDate(selectedDate),
            textScaleFactor: MediaQuery.of(context).textScaleFactor > 1.6 ? 1.6 : MediaQuery.of(context).textScaleFactor,
            style: dayStyle,
          ),
        ),
      ),
    );

    BorderRadius borderRadiusData = BorderRadius.only(
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );

    if (orientation == Orientation.landscape) {
      borderRadiusData = BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: imageHeader != null ? DecorationImage(image: imageHeader, fit: BoxFit.cover) : null,
        color: backgroundColor,
        borderRadius: borderRadiusData,
      ),
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          yearButton,
          dayButton,
          const SizedBox(height: 4.0),
          Visibility(
            visible: description.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description,
                style: TextStyle(
                  color: yearColor,
                  fontSize: 12,
                  fontFamily: fontFamily,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class _DateHeaderButton extends StatelessWidget {
  const _DateHeaderButton({
    Key key,
    this.onTap,
    this.color,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      type: MaterialType.button,
      color: color,
      child: InkWell(
        borderRadius: kMaterialEdges[MaterialType.button],
        highlightColor: theme.highlightColor,
        splashColor: theme.splashColor,
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                child
            ])
        ),
      ),
    );
  }
}

