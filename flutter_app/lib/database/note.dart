class Note {
  final String id;
  final String title;
  final String content;
  final bool isFavorite;
  final bool isArchived;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  final bool isUpdated;
  final int? deletedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.isFavorite,
    required this.isArchived,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.isUpdated,
    required this.deletedAt,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    bool? isFavorite,
    bool? isArchived,
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
    bool? isUpdated,
    int? deletedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'is_favorite': isFavorite ? 1 : 0,
      'is_archived': isArchived ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_updated': isUpdated ? 1 : 0,
    };
  }

  factory Note.fromJson(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isFavorite: map['is_favorite'] == 1,
      isArchived: map['is_archived'] == 1,
      isDeleted: map['is_deleted'] == 1,
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      isUpdated: map['is_updated'] == 1,
    );
  }
}
