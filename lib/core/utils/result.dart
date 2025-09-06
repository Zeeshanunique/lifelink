import '../errors/failures.dart';

class Result<T> {
  final T? data;
  final Failure? failure;
  final bool isSuccess;

  const Result._({this.data, this.failure, required this.isSuccess});

  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  factory Result.failure(Failure failure) {
    return Result._(failure: failure, isSuccess: false);
  }

  bool get isFailure => !isSuccess;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    } else {
      return failure(this.failure!);
    }
  }

  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      return Result.success(mapper(data as T));
    } else {
      return Result.failure(failure!);
    }
  }

  Result<T> mapFailure(Failure Function(Failure failure) mapper) {
    if (isFailure) {
      return Result.failure(mapper(failure!));
    } else {
      return Result.success(data as T);
    }
  }
}
