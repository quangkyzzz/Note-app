import 'dart:async';

import 'package:demo/services/auth/auth_service.dart';
import 'package:demo/services/crud/notes_service.dart';
import 'package:demo/utilites/generic/get_arguments.dart';
import 'package:flutter/material.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;

    if (note == null) {
      return;
    }
    final text = _textController.text;

    await _noteService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();
    final existingNote = _note;

    if (widgetNote != null) {
      _textController.text = widgetNote.text;
      _note = widgetNote;
      return widgetNote;
    }

    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;

    DatabaseUser? tempOwner;
    try {
      tempOwner = await _noteService.getUser(email: email);
    } catch (e) {
      // ignore: avoid_print
      print('this is error: $e');
    }
    final owner = tempOwner;
    DatabaseNote? tempNote;
    try {
      tempNote = await _noteService.createNote(owner: owner!);
    } catch (e) {
      // ignore: avoid_print
      print('this is error 2: $e');
    }
    final newNote = tempNote!;

    _note = newNote;

    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;

    if (_textController.text.isEmpty && note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New note'),
          backgroundColor: const Color.fromARGB(178, 34, 135, 229),
        ),
        body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: 'Start texting your note here...'),
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
