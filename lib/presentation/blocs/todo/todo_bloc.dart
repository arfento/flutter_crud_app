// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';

import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase%20copy%203.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodoUsecase getTodoUsecase;
  final AddTodoUsecase addTodoUsecase;
  final ToggleTodoUsecase toggleTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;

  TodoBloc({
    required this.getTodoUsecase,
    required this.addTodoUsecase,
    required this.toggleTodoUsecase,
    required this.deleteTodoUsecase,
  }) : super(TodoInitial()) {
    on<GetTodoEvent>(_getTodoRequested);
    on<AddTodoEvent>(_addTodoRequested);
    on<ToggleTodoEvent>(_toggleTodoRequested);
    on<DeleteTodoEvent>(_deleteTodoRequested);
  }

  Future<FutureOr<void>> _getTodoRequested(
      GetTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await getTodoUsecase.execute();
      emit(TodoLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodoWithError(message: e.message));
    } catch (e) {
      emit(TodoWithError(message: e.toString()));
    }
  }

  Future<FutureOr<void>> _addTodoRequested(
      AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await addTodoUsecase.execute(todo: event.todo);
      emit(TodoLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodoWithError(message: e.message));
    } catch (e) {
      emit(TodoWithError(message: e.toString()));
    }
  }

  Future<FutureOr<void>> _toggleTodoRequested(
      ToggleTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await toggleTodoUsecase.execute(id: event.id);
      emit(TodoLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodoWithError(message: e.message));
    } catch (e) {
      emit(TodoWithError(message: e.toString()));
    }
  }

  Future<FutureOr<void>> _deleteTodoRequested(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await deleteTodoUsecase.execute(id: event.id);
      emit(TodoLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodoWithError(message: e.message));
    } catch (e) {
      emit(TodoWithError(message: e.toString()));
    }
  }
}
