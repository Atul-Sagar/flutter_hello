import 'package:flutter/material.dart';
import 'note_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Map<String, dynamic>> _notes = [];
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      setState(() {
        _notes.clear();
        _notes.addAll(
          decoded.map((note) {
            return {
              'title': note['title'],
              'content': note['content'],
              'color':
                  note['color'] != null
                      ? Color(int.parse(note['color']))
                      : Colors.grey.shade900,
            };
          }),
        );
      });
    }
  }

  void _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _notes.map((note) {
        return {
          'title': note['title'],
          'content': note['content'],
          'color': (note['color'] as Color).value.toString(),
        };
      }).toList(),
    );
    await prefs.setString('notes', encoded);
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      _saveNotes();
    });
  }

  void _addNote() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => NoteEditor(
              onSave: (title, content, color) {
                setState(() {
                  _notes.add({
                    'title': title,
                    'content': content,
                    'color': color,
                  });
                  _saveNotes();
                });
              },
            ),
      ),
    );
  }

  void _editNote(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => NoteEditor(
              initialTitle: _notes[index]['title'],
              initialContent: _notes[index]['content'],
              initialColor: _notes[index]['color'] ?? Colors.grey.shade900,
              onSave: (title, content, color) {
                setState(() {
                  _notes[index] = {
                    'title': title,
                    'content': content,
                    'color': color,
                  };
                  _saveNotes();
                });
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Notes'),
        // backgroundColor: Colors.black
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body:
          _notes.isEmpty
              ? const Center(
                child: Text(
                  'No notes yet.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
              : _isGridView
              ? GridView.builder(
                itemCount: _notes.length,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return _buildNoteCard(note, index);
                },
              )
              : ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return _buildNoteCard(note, index);
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note, int index) {
    return GestureDetector(
      onTap: () => _editNote(index),
      child: Container(
        decoration: BoxDecoration(
          color: note['color'] ?? Colors.grey.shade900,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            note['title'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            note['content'] ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.white54),
            onPressed: () => _deleteNote(index),
          ),
        ),
      ),
    );
  }
}
