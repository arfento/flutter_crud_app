import 'package:flutter_test/flutter_test.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';

void main() {
  final todoModel = TodoModel(id: "1", title: "title", completed: false);

  group('model convert to entity', () {
    test('Should sucessfully convert to a Todo entity', () {
      //arrange
      final todo = todoModel.toTodo;
      // assert
      expect(todo, isA<Todo>());
      expect(todoModel.id, todo.id);
      expect(todoModel.title, todo.title);
      expect(todoModel.completed, todo.completed);
    });
  });
}
