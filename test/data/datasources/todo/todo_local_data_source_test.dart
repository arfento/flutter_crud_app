import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_local_data_source.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';

class MockTodoHiveHelper extends Mock implements TodoHiveHelper {}

void main() {
  late TodoLocalDataSourceImple todoLocalDataSourceImpl;
  late MockTodoHiveHelper mockTodoHiveHelper;
  late List<TodoModel> todoModels;
  late CacheException error;
  late TodoModel todoModel;
  late String id;

  setUp(() {
    mockTodoHiveHelper = MockTodoHiveHelper();
    todoLocalDataSourceImpl =
        TodoLocalDataSourceImple(hiveHelper: mockTodoHiveHelper);
    todoModels = [TodoModel(id: "1", title: "title", completed: false)];
    error = CacheException(message: 'error');
    todoModel = TodoModel(id: "1", title: "title", completed: false);
    id = "1";
  });

  group('Get Todos', () {
    test('Should return a list of todos when it exists in cache', () async {
      when(() => mockTodoHiveHelper.getTodos())
          .thenAnswer((invocation) => Future.value(todoModels));
      final result = await todoLocalDataSourceImpl.getTodos();
      //assert
      expect(result, todoModels);
      verify(
        () => mockTodoHiveHelper.getTodos(),
      );
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
    test('Should throw a cache exception when there is no data in cache',
        () async {
      when(() => mockTodoHiveHelper.getTodos()).thenThrow(error);
      //assert
      expect(
          () async => todoLocalDataSourceImpl.getTodos(),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(
        () => mockTodoHiveHelper.getTodos(),
      );
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });
  group('save Todos', () {
    test('Should call hive helper to save todos', () async {
      when(() => mockTodoHiveHelper.saveTodos(todoModel: todoModels))
          .thenAnswer((invocation) => Future.value(todoModels));
      await todoLocalDataSourceImpl.saveTodos(todoModel: todoModels);
      //assert
      verify(
        () => mockTodoHiveHelper.saveTodos(todoModel: todoModels),
      ).called(1);
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });
  group('Add Todos', () {
    test('Should return a list of todos call is successful', () async {
      when(() => mockTodoHiveHelper.addTodos(todoModel: todoModel))
          .thenAnswer((invocation) => Future.value(todoModels));
      final result =
          await todoLocalDataSourceImpl.addTodos(todoModel: todoModel);
      //assert
      expect(result, todoModels);
      verify(
        () => mockTodoHiveHelper.addTodos(todoModel: todoModel),
      ).called(1);
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });

  group('Toggle Todos', () {
    test('Should return a list of todos toggle todo is succesfull', () async {
      when(() => mockTodoHiveHelper.toggleTodoAsCompleted(id: id))
          .thenAnswer((invocation) => Future.value(todoModels));
      final result =
          await todoLocalDataSourceImpl.toggleTodoAsCompleted(id: id);
      //assert
      expect(result, todoModels);
      verify(
        () => mockTodoHiveHelper.toggleTodoAsCompleted(id: id),
      );
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
    test('Should throw a cache exception when toggle todo is unsuccessfull',
        () async {
      // Arrange
      when(() => mockTodoHiveHelper.toggleTodoAsCompleted(id: id))
          .thenThrow(error);
      // Assert
      expect(
          () async => todoLocalDataSourceImpl.toggleTodoAsCompleted(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoHiveHelper.toggleTodoAsCompleted(id: id));
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });

  group('Delete Todos', () {
    test('Should return a list of todos delete todo is succesfull', () async {
      when(() => mockTodoHiveHelper.deleteTodos(id: id))
          .thenAnswer((invocation) => Future.value(todoModels));
      final result = await todoLocalDataSourceImpl.deleteTodos(id: id);
      //assert
      expect(result, todoModels);
      verify(
        () => mockTodoHiveHelper.deleteTodos(id: id),
      );
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
    test("Should throw a cache exception when delete todo is unsuccessfull",
        () async {
      when(() => mockTodoHiveHelper.deleteTodos(id: id)).thenThrow(error);

      expect(
          () => todoLocalDataSourceImpl.deleteTodos(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(
        () => mockTodoHiveHelper.deleteTodos(id: id),
      );
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });
}
