// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {}

class GetTodoEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class AddTodoEvent extends TodoEvent {
  final Todo todo;
  AddTodoEvent({
    required this.todo,
  });
  @override
  List<Object?> get props => [todo];
}

class ToggleTodoEvent extends TodoEvent {
  final String id;
  ToggleTodoEvent({
    required this.id,
  });
  @override
  List<Object?> get props => [id];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  DeleteTodoEvent({
    required this.id,
  });
  @override
  List<Object?> get props => [id];
}
