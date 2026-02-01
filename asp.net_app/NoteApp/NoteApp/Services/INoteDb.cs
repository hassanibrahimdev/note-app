using MongoDB.Bson;
using NoteApp.Models;

namespace NoteApp.Services
{
    public interface INoteDb
    {
        // Define method signatures for note database operations
        Task<List<Note>> GetNotDeletedNotesById(ObjectId userId);
        
        Task AddNote(Note note);
        Task UpdateNote(Note note);

    }
}
