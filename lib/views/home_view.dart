import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo/view_models/todos_view_model.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const path = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${DateFormat.yMd().format(DateTime.now())}にやること'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Expanded(
        child: ListView.builder(
          itemBuilder: ((context, index) {
            final todo = todos[index];

            return ListTile(
              title: Text(todo.taskName),
              trailing: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (newValue) {
                    ref
                        .read(todosViewModelProvider.notifier)
                        .toggleStatus(todo.id, newValue ?? false);
                  }),
            );
          }),
          itemCount: todos.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(todosViewModelProvider.notifier).addNewTodo('追加されたタスク');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
