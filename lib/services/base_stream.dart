import '../constant/app_constant.dart';
import 'package:rxdart/rxdart.dart';
import '../api_service/base_http_exception.dart';
import '../repository/base_repository.dart';

class BaseStream<T> extends BaseRepository {
  BehaviorSubject<T> _controller;
  BaseStream([T initialData]) {
    _controller = BehaviorSubject<T>();
    if (initialData != null) {
      this.addData(initialData);
    }
  }

  BehaviorSubject<T> get stream => _controller.stream;

  bool get hasData => _controller.hasValue;

  T get value => _controller.value;

  void addData(T data) {
    if (!_controller.isClosed) _controller.add(data);
  }

  Future<T> asyncOperation(
    Future<T> Function() doingOperation, {
    bool loadingOnRefresh = false,
    void Function(T) onDone,
    void Function(dynamic) onError,
  }) async {
    bool shouldAddError = true;
    if (this._controller.hasValue) {
      shouldAddError = loadingOnRefresh == true;
    }
    try {
      if (loadingOnRefresh) this.addData(null);
      T data = await doingOperation();
      if (onDone != null) onDone(data);
      this.addData(data);
      return data;
    } on TypeError catch (_) {
      onError?.call(ErrorMessage.UNEXPECTED_ERROR);
      if (shouldAddError) this.addError(ErrorMessage.UNEXPECTED_ERROR);
      return null;
    } on BaseHttpException catch (exception) {
      onError?.call(exception);
      if (shouldAddError) this.addError(exception);
      return null;
    } catch (exception) {
      onError?.call(exception);
      if (shouldAddError) this.addError(exception);
      return null;
    }
  }

  void addError(dynamic error) {
    if (!_controller.isClosed) _controller.addError(error);
  }

  void dispose() async {
    _controller.close();
  }
}
