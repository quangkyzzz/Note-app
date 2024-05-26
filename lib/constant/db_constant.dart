const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColumn = "ID";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synnced_with_cloud";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "ID"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("ID" AUTOINCREMENT)
      );
      ''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "ID"	INTEGER NOT NULL,
        "user_id"	INTEGER,
        "text"	TEXT,
        "is_synnced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("ID"),
        PRIMARY KEY("ID" AUTOINCREMENT)
      );''';
