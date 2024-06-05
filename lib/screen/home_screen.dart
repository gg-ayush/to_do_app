import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/controller/to_do_controller.dart';
import 'package:to_do_app/entity/todo_entity.dart';
import 'package:to_do_app/providers/to_do_provider.dart';
import 'package:to_do_app/widgets/header_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var todos = ref.watch(todoControllerProvider);

    if (todos.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 40),
            const HeaderWidget(),
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: 'What do you want to do?',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: '${ref.watch(remianingTodoProvider)} of ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: ref
                                    .watch(todoControllerProvider)
                                    .todos
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' tasks completed',
                                style: TextStyle(),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                        controller: _tabController,
                        labelColor: Colors.black,
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Active'),
                          Tab(text: 'Favourite'),
                          Tab(text: 'Done'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final todos = ref.watch(allTodoProvider).todos;
                                return CommonTodo(
                                  todos: todos,
                                  onTodoUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updateTodoCompletion(todo);
                                  },
                                  onPinUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updatePinnedStatus(todo);
                                  },
                                );
                              },
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final todos =
                                    ref.watch(activeTodoProvider).todos;
                                return CommonTodo(
                                  todos: todos,
                                  onTodoUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updateTodoCompletion(todo);
                                  },
                                  onPinUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updatePinnedStatus(todo);
                                  },
                                );
                              },
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final todos =
                                    ref.watch(pinnedTodoProvider).todos;
                                return CommonTodo(
                                  todos: todos,
                                  onTodoUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updateTodoCompletion(todo);
                                  },
                                  onPinUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updatePinnedStatus(todo);
                                  },
                                );
                              },
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final todos =
                                    ref.watch(completedTodoProvider).todos;
                                return CommonTodo(
                                  todos: todos,
                                  onTodoUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updateTodoCompletion(todo);
                                  },
                                  onPinUpdate: (todo) {
                                    ref
                                        .read(todoControllerProvider.notifier)
                                        .updatePinnedStatus(todo);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class CommonTodo extends StatelessWidget {
  final List<TodoEntity> todos;
  final Function(TodoEntity) onTodoUpdate;
  final Function(TodoEntity) onPinUpdate;

  const CommonTodo({
    required this.todos,
    required this.onTodoUpdate,
    required this.onPinUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 70,
          child: InkWell(
            onTap: () {
              onTodoUpdate(todo);
            },
            child: ListTile(
              leading: Radio(
                value: todo.isCompleted,
                groupValue: true,
                onChanged: (value) {},
              ),
              title: Text(todo.title),
              trailing: IconButton(
                onPressed: () {
                  onPinUpdate(todo);
                },
                icon: Icon(Icons.star,
                    color: todo.isPinned ? Colors.yellow : Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
