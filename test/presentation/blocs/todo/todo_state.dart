// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded({
    required this.todos,
  });
  @override
  List<Object> get props => [];
}

class TodoWithError extends TodoState {
  final String message;

  TodoWithError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
