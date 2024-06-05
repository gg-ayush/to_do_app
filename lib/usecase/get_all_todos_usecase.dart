import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/entity/todo_entity.dart';
import 'package:to_do_app/failure/failure.dart';
import 'package:to_do_app/repository/todo_repository.dart';

final getAllTodoUsecaseProvider = Provider<GetAllTodoUseCase>((ref) {
  return GetAllTodoUseCase(ref.read(todoRepositoryProvider));
});

class GetAllTodoUseCase {
  final ITodoRepository _todoRepository;

  GetAllTodoUseCase(this._todoRepository);

  Future<Either<Failure, List<TodoEntity>>> execute() async {
    return await _todoRepository.getTodoList();
  }
}
