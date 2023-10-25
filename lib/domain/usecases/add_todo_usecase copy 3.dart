import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';

class AddTodoUsecase {
  final TodoRepository repository;

  AddTodoUsecase({required this.repository});

  Future<List<Todo>> execute({required Todo todo}) async {
    return repository.addTodo(todo: todo);
  }
}
