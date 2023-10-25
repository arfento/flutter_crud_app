// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
  saveTodos({required List<TodoModel> todoModel});
  Future<List<TodoModel>> getTodos();
  Future<List<TodoModel>> addTodos({required TodoModel todoModel});
  Future<List<TodoModel>> toggleTodoAsCompleted({required String id});
  Future<List<TodoModel>> deleteTodos({required String id});
}

class TodoLocalDataSourceImple implements TodoLocalDataSource {
  final TodoHiveHelper hiveHelper;

  TodoLocalDataSourceImple({
    required this.hiveHelper,
  });

  @override
  Future<List<TodoModel>> addTodos({required TodoModel todoModel}) async {
    return await hiveHelper.addTodos(todoModel: todoModel);
  }

  @override
  Future<List<TodoModel>> deleteTodos({required String id}) async {
    return await hiveHelper.deleteTodos(id: id);
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    return await hiveHelper.getTodos();
  }

  @override
  saveTodos({required List<TodoModel> todoModel}) async {
    await hiveHelper.saveTodos(todoModel: todoModel);
  }

  @override
  Future<List<TodoModel>> toggleTodoAsCompleted({required String id}) async {
    return await hiveHelper.toggleTodoAsCompleted(id: id);
  }
}
