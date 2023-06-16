import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';

class ToggleTodoUsecase {
  final TodoRepository repository;

  ToggleTodoUsecase({required this.repository});

  Future<List<Todo>> execute({required String id}) async {
    return repository.toggleTodoAsCompleted(id: id);
  }
}
