// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_local_data_source.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<Todo>> addTodo({required Todo todo}) async {
    try {
      final model =
          TodoModel(id: todo.id, title: todo.title, completed: todo.completed);
      final todoModels = await localDataSource.addTodos(todoModel: model);
      final todos = todoModels.map((e) => e.toTodo).toList();
      return todos;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<Todo>> deleteTodo({required String id}) async {
    try {
      final todoModels = await localDataSource.deleteTodos(id: id);
      final todos = todoModels.map((e) => e.toTodo).toList();
      return todos;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final todoModels = await localDataSource.getTodos();
      final todos = todoModels.map((e) => e.toTodo).toList();
      await localDataSource.saveTodos(todoModel: todoModels);
      return todos;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<Todo>> toggleTodoAsCompleted({required String id}) async {
    try {
      final todoModels = await localDataSource.toggleTodoAsCompleted(id: id);
      final todos = todoModels.map((e) => e.toTodo).toList();
      return todos;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw e.toString();
    }
  }
}
