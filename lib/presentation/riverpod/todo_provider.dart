import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_local_data_source.dart';
import 'package:todo_bloc_riverpod/data/repository/todo_repository_impl.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';

import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase%20copy%203.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_bloc_riverpod/presentation/blocs/todo/todo_bloc.dart';

final todoProvider = NotifierProvider<TodoNotifier, TodoState>(
  () {
    final repository = TodoRepositoryImpl(
        localDataSource:
            TodoLocalDataSourceImple(hiveHelper: TodoHiveHelper()));
    return TodoNotifier(
        getTodoUsecase: GetTodoUsecase(repository: repository),
        addTodoUsecase: AddTodoUsecase(repository: repository),
        deleteTodoUsecase: DeleteTodoUsecase(repository: repository),
        toggleTodoUsecase: ToggleTodoUsecase(repository: repository));
  },
);

class TodoNotifier extends Notifier<TodoState> {
  final GetTodoUsecase getTodoUsecase;
  final AddTodoUsecase addTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;
  final ToggleTodoUsecase toggleTodoUsecase;

  TodoNotifier({
    required this.getTodoUsecase,
    required this.addTodoUsecase,
    required this.deleteTodoUsecase,
    required this.toggleTodoUsecase,
  });

  @override
  TodoState build() {
    return TodoInitial();
  }

  getTodos() async {
    state = TodoLoading();
    try {
      final todos = await getTodoUsecase.execute();
      state = TodoLoaded(todos: todos);
    } on CacheException catch (e) {
      state = TodoWithError(message: e.message);
    } catch (e) {
      state = TodoWithError(message: e.toString());
    }
  }

  addTodos({required Todo todo}) async {
    state = TodoLoading();
    try {
      final todos = await addTodoUsecase.execute(todo: todo);
      state = TodoLoaded(todos: todos);
    } on CacheException catch (e) {
      state = TodoWithError(message: e.message);
    } catch (e) {
      state = TodoWithError(message: e.toString());
    }
  }

  toggleTodos({required String id}) async {
    state = TodoLoading();
    try {
      final todos = await toggleTodoUsecase.execute(id: id);
      state = TodoLoaded(todos: todos);
    } on CacheException catch (e) {
      state = TodoWithError(message: e.message);
    } catch (e) {
      state = TodoWithError(message: e.toString());
    }
  }

  deleteTodos({required String id}) async {
    state = TodoLoading();
    try {
      final todos = await deleteTodoUsecase.execute(id: id);
      state = TodoLoaded(todos: todos);
    } on CacheException catch (e) {
      state = TodoWithError(message: e.message);
    } catch (e) {
      state = TodoWithError(message: e.toString());
    }
  }
}
