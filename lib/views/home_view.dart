import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo/view_models/todos_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  static const path = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _controller = TextEditingController();
  final newTaskNameProvider = StateProvider<String>((ref) => '');

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${DateFormat.yMd().format(DateTime.now())}にやること'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          final todo = todos[index];

          return ListTile(
            title: Text(todo.taskName,
                style: todo.isCompleted
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                      )
                    : null),
            trailing: Checkbox(
              value: todo.isCompleted,
              onChanged: (newValue) {
                ref
                    .read(todosViewModelProvider.notifier)
                    .toggleStatus(todo.id, newValue ?? false);
              },
            ),
          );
        }),
        itemCount: todos.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context, ref);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, WidgetRef ref) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final newTaskName = ref.watch(newTaskNameProvider);

            return AlertDialog(
              title: Text('Todoの新規登録'),
              content: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Todo名を記入'),
                onChanged: (value) {
                  ref.read(newTaskNameProvider.notifier).state = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _controller.clear();
                    ref.read(newTaskNameProvider.notifier).state = '';
                    GoRouter.of(context).pop();
                  },
                  child: Text('キャンセル'),
                ),
                TextButton(
                  onPressed: newTaskName.isEmpty
                      ? null
                      : () {
                          ref
                              .read(todosViewModelProvider.notifier)
                              .addNewTodo(newTaskName);
                          _controller.clear();
                          ref.read(newTaskNameProvider.notifier).state = '';
                          GoRouter.of(context).pop();
                        },
                  child: Text('登録'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
