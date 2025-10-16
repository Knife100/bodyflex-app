import 'package:flutter/material.dart';

class ClientSearchBar extends StatefulWidget {
  final String searchTerm;
  final ValueChanged<String> onChanged;

  const ClientSearchBar({
    super.key,
    required this.searchTerm,
    required this.onChanged,
  });

  @override
  State<ClientSearchBar> createState() => _ClientSearchBarState();
}

class _ClientSearchBarState extends State<ClientSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchTerm);
  }

  @override
  void didUpdateWidget(ClientSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Quita esta parte:
    // if (oldWidget.searchTerm != widget.searchTerm) {
    //   _controller.text = widget.searchTerm;
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Buscar cliente por nombre, correo, plan...',
                border: OutlineInputBorder(),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
