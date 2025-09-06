import '../utils/result.dart';

abstract class BaseRepository<T> {
  Future<Result<List<T>>> getAll();
  Future<Result<T>> getById(String id);
  Future<Result<T>> create(T entity);
  Future<Result<T>> update(String id, T entity);
  Future<Result<void>> delete(String id);
  Future<Result<List<T>>> search(String query);
  Future<Result<List<T>>> getByHospitalId(String hospitalId);
  Future<Result<List<T>>> getByUserId(String userId);
}

abstract class BaseRepositoryWithPagination<T> extends BaseRepository<T> {
  Future<Result<List<T>>> getPaginated({
    int page = 1,
    int limit = 20,
    String? searchQuery,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool ascending = true,
  });
}

abstract class BaseRepositoryWithCache<T> extends BaseRepository<T> {
  Future<Result<List<T>>> getCached();
  Future<Result<void>> cache(List<T> entities);
  Future<Result<void>> clearCache();
}
