import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/presentation/blocs/todo/todo_bloc.dart';
import 'package:todo_bloc_riverpod/presentation/riverpod/todo_provider.dart';
import 'package:uuid/uuid.dart';

class TodoPageRiverpod extends ConsumerStatefulWidget {
  const TodoPageRiverpod({super.key});

  @override
  _TodoPageRiverpodState createState() => _TodoPageRiverpodState();
}

class _TodoPageRiverpodState extends ConsumerState<TodoPageRiverpod> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(todoProvider.notifier).getTodos();
    });
  }

  void _addTodo({required String value}) {
    final todo = Todo(id: const Uuid().v4(), title: value, completed: false);
    ref.read(todoProvider.notifier).addTodos(todo: todo);
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(
                child: Text("Add your first todo"),
              );
            } else {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return Dismissible(
                    key: Key(todo.id),
                    background: Container(
                      color: Colors.red,
                      child: Row(children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Text('DELETE',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white)),
                        )
                      ]),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        ref
                            .read(todoProvider.notifier)
                            .deleteTodos(id: todo.id);
                      }
                    },
                    child: ListTile(
                      title: Text(todo.title),
                      trailing: IconButton(
                        icon: todo.completed
                            ? const Icon(Icons.done)
                            : const Icon(Icons.circle_outlined),
                        onPressed: () {
                          ref
                              .read(todoProvider.notifier)
                              .toggleTodos(id: todo.id);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is TodoWithError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _displayTextinputDialog(context);
        },
      ),
    );
  }

  Future<void> _displayTextinputDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a Todo'),
          content: TextField(
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _addTodo(value: value);
                Navigator.of(context).pop();
              }
            },
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Add your Todo'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    _addTodo(value: _textEditingController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'))
          ],
        );
      },
    );
  }
}
