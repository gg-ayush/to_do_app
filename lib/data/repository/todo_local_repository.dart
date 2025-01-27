import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/data/data_source/local/todo_local_data_source.dart';
import 'package:to_do_app/entity/todo_entity.dart';
import 'package:to_do_app/failure/failure.dart';
import 'package:to_do_app/repository/todo_repository.dart';

final todoLocalTodoRepositoryProvider = Provider<TodoLocalRepository>((ref) {
  return TodoLocalRepository(
      todoLocalDataSource: ref.read(todoLocalDataSourceProvider));
});

class TodoLocalRepository extends ITodoRepository {
  final TodoLocalDataSource todoLocalDataSource;

  TodoLocalRepository({required this.todoLocalDataSource});

  @override
  Future<Either<Failure, bool>> createTodo(
      {required String title, required String description}) {
    // TODO: implement createTodo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodoList() {
    return todoLocalDataSource.getTodoList();
  }

  @override
  Future<Either<Failure, bool>> updateTodo(TodoEntity todoEntity) {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }
}
