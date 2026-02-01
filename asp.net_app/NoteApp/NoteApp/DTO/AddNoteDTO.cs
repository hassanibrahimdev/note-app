using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace NoteApp.DTO
{
    public class AddNoteDTO
    {
        public string NoteId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public long CreatedAt { get; set; }

    }
}
