import 'package:flutter/material.dart';

class NoteEditor extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final Color? initialColor;
  final void Function(String title, String content, Color color) onSave;

  const NoteEditor({
    super.key,
    this.initialTitle,
    this.initialContent,
    this.initialColor,
    required this.onSave,
  });

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _selectedColor;

  final List<Color> _colors = [
    Colors.grey.shade900,
    Colors.white,
    Colors.indigo.shade900,
    Colors.teal.shade700,
    Colors.amber.shade200,
    Colors.deepPurple.shade700,
    Colors.green.shade600,
    Colors.pink.shade300,
    Colors.red.shade300,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(
      text: widget.initialContent ?? '',
    );
    _selectedColor = widget.initialColor ?? Colors.grey.shade900;
  }

  Color _getContrastingTextColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getContrastingTextColor(_selectedColor);

    return Scaffold(
      backgroundColor: _selectedColor,
      appBar: AppBar(
        title: const Text('Edit Note'),
        backgroundColor: _selectedColor,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(color: textColor, fontSize: 20),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: textColor),
            onPressed: () {
              widget.onSave(
                _titleController.text,
                _contentController.text,
                _selectedColor,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              // style: TextStyle(color: textColor, fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                border: InputBorder.none,
              ),
            ),
            Divider(color: textColor.withOpacity(0.4)),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                // style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Write your note...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border:
                            _selectedColor == color
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
