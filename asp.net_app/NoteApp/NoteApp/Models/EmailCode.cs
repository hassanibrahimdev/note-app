using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace NoteApp.Models
{
    public class EmailCode
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public ObjectId Id { get; set; }
        public string Email { get; set; }
        public string Code { get; set; }
        public long ExpiredTime { get; set; }
        public bool IsReaded { get; set; }
    }
}
