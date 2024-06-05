import 'package:dartz/dartz.dart';
import 'package:to_do_app/entity/todo_entity.dart';
import 'package:to_do_app/failure/failure.dart';

abstract class MainDataSource {
  Future<Either<Failure, List<TodoEntity>>> getTodoList();
  Future<Either<Failure, bool>> createTodo(
      {required String title, required String description});

  Future<Either<Failure, bool>> updateTodo(TodoEntity todoEntity);
}
