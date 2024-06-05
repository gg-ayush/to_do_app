import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/data/repository/todo_local_repository.dart';
import 'package:to_do_app/entity/todo_entity.dart';
import 'package:to_do_app/failure/failure.dart';

final todoRepositoryProvider = Provider<ITodoRepository>((ref) {
  return ref.read(todoLocalTodoRepositoryProvider);
});

abstract class ITodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodoList();
  Future<Either<Failure, bool>> createTodo(
      {required String title, required String description});

  Future<Either<Failure, bool>> updateTodo(TodoEntity todoEntity);
}
