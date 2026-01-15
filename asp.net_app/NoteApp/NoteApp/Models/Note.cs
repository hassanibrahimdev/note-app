using Microsoft.AspNetCore.Http.HttpResults;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using SharpCompress.Archives;

namespace NoteApp.Models
{
    public class Note
    {
        [BsonId]
        public ObjectId Id { get; set; }
        [BsonElement("userId")]
        public ObjectId UserId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public DateTime IsDeleted { get; set; }
        
    }
}
