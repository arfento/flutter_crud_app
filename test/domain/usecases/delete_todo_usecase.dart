import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';

class DeleteTodoUsecase {
  final TodoRepository repository;

  DeleteTodoUsecase({required this.repository});

  Future<List<Todo>> execute({required String id}) async {
    return repository.deleteTodo(id: id);
  }
}
