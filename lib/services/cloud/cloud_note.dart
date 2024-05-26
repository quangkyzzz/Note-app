import 'package:flutter/material.dart';

@immutable
class CloudNote {
  final String documentId;
  final String text;
  final String ownerUserId;

  const CloudNote({
    required this.documentId,
    required this.text,
    required this.ownerUserId,
  });
}
