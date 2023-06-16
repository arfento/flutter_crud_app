import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo/todo_local_data_source.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';
import 'package:todo_bloc_riverpod/data/repository/todo_repository_impl.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase%20copy%203.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_bloc_riverpod/presentation/blocs/todo/todo_bloc.dart';
import 'package:todo_bloc_riverpod/presentation/pages/todo_page_riverpod.dart';
import 'package:todo_bloc_riverpod/presentation/pages/todo_page_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = TodoRepositoryImpl(
            localDataSource:
                TodoLocalDataSourceImple(hiveHelper: TodoHiveHelper()));

        return TodoBloc(
            addTodoUsecase: AddTodoUsecase(repository: repository),
            deleteTodoUsecase: DeleteTodoUsecase(repository: repository),
            getTodoUsecase: GetTodoUsecase(repository: repository),
            toggleTodoUsecase: ToggleTodoUsecase(
              repository: repository,
            ));
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodoPageBloc(),
      ),
    );
  }
}
