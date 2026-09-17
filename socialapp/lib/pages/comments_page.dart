import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';
import '../models/comment.dart';
import '../globals.dart'; // Contains backendurl and global_user

class CommentsPage extends StatefulWidget {
  final Post post;

  const CommentsPage({super.key, required this.post});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  // 1. Fetch Comments
  Future<void> _fetchComments() async {
    try {
      final response = await http.post(
        Uri.parse("$backendurl/get_comments"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": widget.post.title}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List commentsJson = data['comments'] ?? [];
        setState(() {
          _comments = commentsJson.map((json) {
            // Attach the current post object to each comment
            json['post'] = widget.post.toJson();
            return Comment.fromJson(json);
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // 2. Add Comment
  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    _commentController.clear();

    try {
      final response = await http.post(
        Uri.parse("$backendurl/add_comment"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": global_user?.email,
          "title": widget.post.title,
          "description": text,
        }),
      );

      if (response.statusCode == 200) {
        _fetchComments(); // Refresh comments list
      }
    } catch (e) {
      // Handle connection errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments (${_comments.length})"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Comments List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? const Center(child: Text("No comments yet."))
                    : ListView.builder(
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(
                              comment.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              comment.description,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        },
                      ),
          ),

          // Input Box
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Write a comment...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}