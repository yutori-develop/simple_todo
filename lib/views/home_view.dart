import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo/view_models/todos_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    ? const TextStyle(
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _showDialogForRemoveTodo(context),
            child: const Icon(Icons.delete),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: () => _showDialogForAddTodo(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogForAddTodo(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final newTaskName = ref.watch(newTaskNameProvider);
            final l10n = L10n.of(context);

            return AlertDialog(
              title: const Text('Todoを追加'),
              content: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Todo名を記入'),
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
                  child: const Text('キャンセル'),
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
                  child: const Text('追加'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDialogForRemoveTodo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final chekedTodos = ref
                .watch(todosViewModelProvider)
                .where((todo) => todo.isCompleted)
                .toList();

            return AlertDialog(
              title: const Text('Todoの削除'),
              content: const Text('完了済みのTodoを全て削除します'),
              actions: [
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(todosViewModelProvider.notifier)
                        .removeTodo(chekedTodos);
                    GoRouter.of(context).pop();
                  },
                  child: const Text('OK'),
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
