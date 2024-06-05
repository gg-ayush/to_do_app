import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/entity/todo_entity.dart';
import 'package:to_do_app/state/to_do_state.dart';
import 'package:to_do_app/usecase/get_all_todos_usecase.dart';

final todoControllerProvider =
    StateNotifierProvider<TodoController, TodoState>((ref) {
  final getAllTodoUseCase = ref.watch(getAllTodoUsecaseProvider);
  return TodoController(getAllTodoUseCase);
});

class TodoController extends StateNotifier<TodoState> {
  final GetAllTodoUseCase getAllTodoUseCase;

  TodoController(this.getAllTodoUseCase) : super(TodoState.initial()) {
    // Mock data integration
    _initializeMockData();
  }

  void _initializeMockData() {
    List<Map<String, dynamic>> mockData = [
      {
        "id": 1,
        "title": "electricity",
        "description": "Pay electricity bill",
        "isCompleted": false,
        "isPinned": true
      },
      {
        "id": 2,
        "title": "Call",
        "description": "Call Kiran",
        "isCompleted": false,
        "isPinned": true
      },
      {
        "id": 3,
        "title": "Visit",
        "description": "visit dentist",
        "isCompleted": true,
        "isPinned": false
      },
      {
        "id": 4,
        "title": "Buy sweets",
        "description": "Buy some sweets",
        "isCompleted": false,
        "isPinned": true
      }
    ];

    List<TodoEntity> todos = mockData.map((data) {
      return TodoEntity(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        isCompleted: data['isCompleted'],
        isPinned: data['isPinned'],
      );
    }).toList();

    state = state.copyWith(todos: todos);
  }

  void getAllTodos() async {
    state = state.copyWith(isLoading: true);
    var todos = await getAllTodoUseCase.execute();
    todos.fold((l) {
      return state = state.copyWith(error: l.message);
    }, (r) {
      return state = state.copyWith(todos: r);
    });
    state = state.copyWith(isLoading: false);
  }

  // update todo
  void updateTodoCompletion(TodoEntity todo) {
    int todoId = todo.id;

    // search for the todo and update the isCompleted field
    var todoIndex = state.todos.indexWhere((element) => element.id == todoId);
    var todoToUpdate = state.todos[todoIndex];
    todoToUpdate = todoToUpdate.copyWith(isCompleted: !todo.isCompleted);

    // update the state
    state.todos[todoIndex] = todoToUpdate;
    state = state.copyWith(todos: state.todos);
  }

  void updatePinnedStatus(TodoEntity todo) {
    int todoId = todo.id;

    // search for the todo and update the isPinned field
    var todoIndex = state.todos.indexWhere((element) => element.id == todoId);
    var todoToUpdate = state.todos[todoIndex];
    todoToUpdate = todoToUpdate.copyWith(isPinned: !todo.isPinned);

    // update the state
    state.todos[todoIndex] = todoToUpdate;
    state = state.copyWith(todos: state.todos);
  }
}
