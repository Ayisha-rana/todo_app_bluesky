import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; 
import 'package:todo_app_bluesky/frontend/profilepage.dart';
import 'taskformpage.dart';

final Map<String, Color> priorityColors = {
  'High': Colors.red,
  'Medium': Colors.orange,
  'Low': Colors.green,
};

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = [];
  String? priorityFilter;
  DateTime? dateFilter;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add this

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _filterByPriority(String? priority) {
    setState(() {
      priorityFilter = priority;
    });
  }

  void _filterByDate(DateTime? date) {
    setState(() {
      dateFilter = date;
    });
  }

  Future<void> _rescheduleTask(Task task) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: task.dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (newDate != null) {
      TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: task.dueTime ?? TimeOfDay.now(),
      );

      if (newTime != null) {
        setState(() {
          final index = tasks.indexOf(task);
          tasks[index] = Task(
            name: task.name,
            customer: task.customer,
            priority: task.priority,
            dueDate: newDate,
            dueTime: newTime,
            description: task.description,
          );
        });
      }
    }
  }

  void _showTaskOptions(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Mark as Completed'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.orange),
                title: Text('Reschedule'),
                onTap: () {
                  Navigator.pop(context);
                  _rescheduleTask(task);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskFormPage(
                        initialTask: task,
                        onSave: (updatedTask) {
                          setState(() {
                            tasks[tasks.indexOf(task)] = updatedTask;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = tasks.where((task) {
      if (priorityFilter != null && task.priority != priorityFilter) {
        return false;
      }
      if (dateFilter != null &&
          (task.dueDate.toLocal().toIso8601String().split('T')[0] !=
              dateFilter!.toLocal().toIso8601String().split('T')[0])) {
        return false;
      }
      return true;
    }).toList();

    Map<String, List<Task>> tasksByDate = {};
    for (var task in filteredTasks) {
      var dateKey = DateFormat('d MMMM').format(task.dueDate);
      if (tasksByDate[dateKey] == null) {
        tasksByDate[dateKey] = [];
      }
      tasksByDate[dateKey]!.add(task);
    }

    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.bars),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();  
          },
        ),
        title: const Text(
          'Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'FilterByPriority') {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 150,
                    AppBar().preferredSize.height,
                    0,
                    0,
                  ),
                  items: [
                    PopupMenuItem<String>(
                      value: 'High',
                      child: Text('High Priority'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Medium',
                      child: Text('Medium Priority'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Low',
                      child: Text('Low Priority'),
                    ),
                  ],
                ).then((selectedPriority) {
                  if (selectedPriority != null) {
                    _filterByPriority(selectedPriority);
                  }
                });
              } else if (value == 'FilterByDate') {
                showDatePicker(
                  context: context,
                  initialDate: dateFilter ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    _filterByDate(selectedDate);
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'FilterByPriority',
                child: Text('Filter by Priority'),
              ),
              PopupMenuItem<String>(
                value: 'FilterByDate',
                child: Text('Filter by Date'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade300,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.person, size: 30, color: Colors.blueGrey.shade300),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'AISHAH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'aishah@gmail.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: tasksByDate.isEmpty
          ? Center(
              child: Text(
                'No tasks available',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView(
              children: tasksByDate.keys.map((date) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 19, 
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                    ),
                    ...tasksByDate[date]!.map((task) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 11,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: priorityColors[task.priority],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      task.name,
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Due Date: ${DateFormat('d MMMM').format(task.dueDate)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (task.dueTime != null)
                                Text(
                                  'Due Time: ${task.dueTime!.format(context)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(task.customer),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              _showTaskOptions(task);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormPage(
                onSave: (newTask) {
                  _addTask(newTask);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

