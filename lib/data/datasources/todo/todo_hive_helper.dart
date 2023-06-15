import 'package:hive/hive.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_local_data_source.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';

class TodoHiveHelper implements TodoLocalDataSource {
  @override
  Future<List<TodoModel>> addTodos({required TodoModel todoModel}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    box.put(todoModel.id, todoModel);
    return getTodos();
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    final box = await Hive.openBox<TodoModel>('todos');
    final todos = box.values.toList().cast<TodoModel>();
    return todos;
  }

  @override
  saveTodos({required List<TodoModel> todoModel}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    await box.clear();
    for (var todo in todoModel) {
      box.put(todo.id, todo);
    }
  }

  @override
  Future<List<TodoModel>> toggleTodoAsCompleted({required String id}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    final model = box.get(id);
    if (model == null) {
      throw CacheException(message: 'Item can not be fetched');
    } else {
      model.completed = !model.completed;
      box.put(model.id, model);
      return getTodos();
    }
  }

  @override
  Future<List<TodoModel>> deleteTodos({required String id}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    final model = box.get(id);
    if (model == null) {
      throw CacheException(message: 'Item can not be fetched');
    } else {
      box.delete(id);
      return getTodos();
    }
  }
}
