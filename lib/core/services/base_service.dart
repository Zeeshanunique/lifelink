import '../utils/result.dart';

abstract class BaseService<T> {
  Future<Result<List<T>>> getAll();
  Future<Result<T>> getById(String id);
  Future<Result<T>> create(T entity);
  Future<Result<T>> update(String id, T entity);
  Future<Result<void>> delete(String id);
  Future<Result<List<T>>> search(String query);
}

abstract class BaseServiceWithValidation<T> extends BaseService<T> {
  Future<Result<bool>> validate(T entity);
  Future<Result<List<String>>> getValidationErrors(T entity);
}

abstract class BaseServiceWithCache<T> extends BaseService<T> {
  Future<Result<List<T>>> getCached();
  Future<Result<void>> refreshCache();
  Future<Result<void>> clearCache();
}
