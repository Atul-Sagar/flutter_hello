import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});


  

  @override
  
  Widget build(BuildContext context) {
  final List<ToolCard> tools = const [
    ToolCard(icon: Icons.calculate, label: 'Calculator', routeName: '/calculator'),
    ToolCard(icon: Icons.note, label: 'Notes', routeName: '/notes'),
    ToolCard(icon: Icons.timer, label: 'Stopwatch', routeName: '/stopwatch'),
    ToolCard(icon: Icons.timer, label: 'Timer', routeName: '/timer'),
    ToolCard(icon: Icons.code, label: 'Snippets', routeName: '/snippets'),
    ToolCard(icon: Icons.terminal, label: 'Terminal', routeName: '/terminal'),
    ToolCard(icon: Icons.check_circle, label: 'To-Do', routeName: '/todo'),
    ToolCard(icon: Icons.merge_type, label: 'Git Client', routeName: '/git'),
    ToolCard(icon: Icons.format_align_left, label: 'JSON Formatter', routeName: '/json'),
  ];
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Text(
                'Welcome! You are logged in.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: tools,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class ToolCard extends StatelessWidget{
  final IconData icon;
  final String label;
  final String routeName;

  const ToolCard({
    super.key,
    required this.icon,
    required this.label,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.indigo.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.indigo),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
      ),
    );
  }
}