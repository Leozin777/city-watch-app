import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomSheetGenerico extends StatefulWidget {
  final Widget widgetBottomSheet;

  const BottomSheetGenerico({super.key, required this.widgetBottomSheet});

  @override
  State<BottomSheetGenerico> createState() => _BottomSheetGenericoState();
}

class _BottomSheetGenericoState extends State<BottomSheetGenerico> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.idle && notification.metrics.atEdge && notification.metrics.pixels == 0) {
          Navigator.pop(context);
          return true;
        }
        return false;
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: widget.widgetBottomSheet,
        ),
      ),
    );
  }
}
