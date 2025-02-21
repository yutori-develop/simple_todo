import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_todo/data/models/todo.dart';
import 'package:uuid/uuid.dart';

part 'todos_view_model.g.dart';

@riverpod
class TodosViewModel extends _$TodosViewModel {
  @override
  List<Todo> build() {
    final initialTodo = Todo(id: Uuid().v4(), taskName: '初期タスク');
    return [initialTodo];
  }

  //新たなTodoを登録する
  void addNewTodo(String taskName) {
    Todo newTodo = Todo(id: Uuid().v4(), taskName: taskName);

    state = [...state, newTodo];
  }

  //完了済みのTodoを削除する
  void removeTodo(List<Todo> todos) {
    state = state.where((todo) => !todos.contains(todo)).toList();
  }

  //Todoのチェックボックスを入れ替える
  void toggleStatus(String id, bool newStatus) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(isCompleted: newStatus) else todo
    ];
  }
}
