import 'package:flutter/material.dart';

class Task {
  String name;
  String customer;
  String priority;
  DateTime dueDate; 
  TimeOfDay? dueTime;
  String description;
  Task({
    required this.name,
    required this.customer,
    required this.priority,
    required this.dueDate,
    this.dueTime,
    required this.description, 
  });
}

class TaskFormPage extends StatefulWidget {
  final void Function(Task) onSave;
  final Task? initialTask; 

  TaskFormPage({required this.onSave, this.initialTask});

  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController; 
  String? _priority; 
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _selectedCustomer; 

  List<String> _customers = ['Customer A', 'Customer B', 'Customer C'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTask?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialTask?.description ?? ''); 
    _selectedCustomer = widget.initialTask?.customer;
    _priority = widget.initialTask?.priority;
    _dueDate = widget.initialTask?.dueDate;
    _dueTime = widget.initialTask?.dueTime;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose(); 
    super.dispose();
  }

  void _saveTask() {
    if (_nameController.text.isEmpty ||
        _selectedCustomer == null ||
        _dueDate == null ||
        _priority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    Task updatedTask = Task(
      name: _nameController.text,
      customer: _selectedCustomer!,
      priority: _priority!,
      dueDate: _dueDate!,
      dueTime: _dueTime,
      description: _descriptionController.text, 
    );

    widget.onSave(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.initialTask == null ? 'New Task' : 'Edit Task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelAndField(
              label: 'Title Task',
              child: _buildTextField(
                controller: _nameController,
                labelText: 'Task Name',
              ),
            ),
            SizedBox(height: 16),
            _buildLabelAndField(
              label: 'Description',
              child: _buildTextField(
                controller: _descriptionController,
                labelText: 'Task Description',
              ),
            ),
            SizedBox(height: 16),
            _buildLabelAndField(
              label: 'Select a Customer',
              child: _buildDropdownField(
                value: _selectedCustomer,
                items: _customers,
                labelText: 'Customer',
                onChanged: (value) {
                  setState(() {
                    _selectedCustomer = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            _buildLabelAndField(
              label: 'Select Priority',
              child: _buildDropdownField(
                value: _priority,
                items: ['High', 'Medium', 'Low'],
                labelText: 'Priority',
                onChanged: (value) {
                  setState(() {
                    _priority = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            _buildLabelAndField(
              label: '',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2),
                  _buildDateTimeRow(
                    dateHintText: _dueDate == null ? 'dd/mm/yy' : 'Due Date: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                    timeHintText: _dueTime == null ? 'hh:mm:ss' : 'Due Time: ${_dueTime!.format(context)}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.blueGrey.shade800, width: 1.5),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.blueGrey.shade800)),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade800,
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.2),
                  ),
                  child: Text('Create', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabelAndField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      color: Colors.white,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String labelText,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      color: Colors.white,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem(
                  child: Text(item),
                  value: item,
                ))
            .toList(),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }

 Widget _buildDateTimeRow({
  required String dateHintText,
  required String timeHintText,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Due Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Center(
                  child: Text(
                    dateHintText,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Due Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDueTime,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Center(
                  child: Text(
                    timeHintText,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  void _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _pickDueTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _dueTime) {
      setState(() {
        _dueTime = picked;
      });
    }
  }
}
