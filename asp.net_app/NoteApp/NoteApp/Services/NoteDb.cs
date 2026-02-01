using MongoDB.Bson;
using MongoDB.Driver;
using NoteApp.Models;
using System.Threading.Tasks;

namespace NoteApp.Services
{
    public class NoteDb : INoteDb
    {
        private readonly IMongoCollection<Note> _notes;
        public NoteDb(IMongoDatabase database)
        {
            _notes = database.GetCollection<Note>("Notes");
        }
        public async Task<List<Note>> GetNotDeletedNotesById(ObjectId userId)
        {
            List<Note> notes = await _notes.Find(note => !note.IsDeleted && note.UserId == userId).ToListAsync();
            return notes;
        }
        public async Task AddNote(Note note)
        {
            Note existing = await _notes.Find(n => n.NoteId == note.NoteId).FirstOrDefaultAsync();
            if (existing == null)
            {
                await _notes.InsertOneAsync(note);
            }
        }
        public async Task UpdateNote(Note note)
        {
            Note existing = await _notes.Find(n => n.NoteId == note.NoteId).FirstOrDefaultAsync();
            if(existing != null)
            {
                await _notes.ReplaceOneAsync(n => n.NoteId == note.NoteId, note);
            }
        }
    }
}
