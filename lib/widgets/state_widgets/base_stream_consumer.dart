import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/base_stream.dart';
import '../common/loading_widget.dart';

class BaseStreamConsumer<T> extends StatelessWidget {
  final Widget Function(BuildContext, T) builder;
  final Widget onEmpty;
  final Widget Function(dynamic) onError;

  const BaseStreamConsumer({
    Key key,
    @required this.builder,
    this.onEmpty,
    this.onError,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final baseStream = Provider.of<BaseStream<T>>(context, listen: false);
    return StreamBuilder<T>(
      stream: baseStream.stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data);
        } else if (snapshot.hasError) {
          if (onError == null)
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          return onError(snapshot.error);
        } else {
          if (onEmpty == null) return LoadingWidget();
          return onEmpty;
        }
      },
    );
  }
}
