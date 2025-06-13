import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPage extends StatefulWidget{
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>{
  final List<_Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  final String _storageKey = 'todo_tasks';
  double _urgency = 3;



  @override
  void initState(){
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList(_storageKey) ?? [];

    setState((){
      _tasks.clear();
      _tasks.addAll(jsonTasks.map((e) => _Task.fromJson(json.decode(e))));
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = _tasks.map((t) => json.encode(t.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonTasks);
  }

  void _addTask(){
    final text = _controller.text.trim();
    if(text.isNotEmpty){
      setState(() {
        _tasks.add(_Task(text, false, _urgency.toInt()));
        _controller.clear();
        _urgency = 3;
      });
      _saveTasks();
    }
  }


  void _toggleTask(int index){
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
    _saveTasks();
  }

  void _deleteTask(int index){
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }


  Color _urgencyColor(int level){
    switch(level){
      case 1:
        return Colors.green;
      
      case 2:
        return Colors.lightGreen;
      
      case 3:
        return Colors.orange;
      
      case 4:
        return Colors.deepOrange;
      
      case 5:
      default:
        return Colors.red;
      
    }
  }


  String _urgencyText(int level){
    switch(level){
      case 1:
        return "Very Low";

      case 2:
        return "Low";

      case 3:
        return "Medium";

      case 4:
        return "High";
  
      case 5:
      default:
        return "Urgent";
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Enter task',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: const Text('Add'),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Urgency:'),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 5,
                        divisions: 4,
                        value: _urgency,
                        label: _urgencyText(_urgency.toInt()),
                        activeColor: _urgencyColor(_urgency.toInt()),
                        onChanged: (value) {
                          setState(() => _urgency = value);
                        },
                      ),
                    ),
                    Text(_urgency.toInt().toString()),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text('No tasks added yet.'))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (_) => _toggleTask(index),
                        ),
                        title: Text(
                          task.text,
                          style: TextStyle(
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          'Urgency: ${_urgencyText(task.urgency)}',
                          style: TextStyle(
                            color: _urgencyColor(task.urgency),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

}

class _Task{
  String text;
  bool isDone;
  int urgency;

  _Task(this.text, this.isDone, this.urgency);

  Map<String, dynamic> toJson() => {
    'text' : text,
    'isDone' : isDone,
    'urgency' : urgency
  };

  factory _Task.fromJson(Map<String, dynamic> json){
    return _Task(json['text'], json['isDone'], json['urgency'] ?? 3);
  }
}