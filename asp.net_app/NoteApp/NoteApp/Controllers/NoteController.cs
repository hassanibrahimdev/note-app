using FluentValidation;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;
using NoteApp.DTO;
using NoteApp.Models;
using NoteApp.Services;
using NoteApp.Validations;
using Org.BouncyCastle.Utilities;
using System.Security.Claims;
using System.Threading.Tasks;

namespace NoteApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NoteController : ControllerBase
    {
        private readonly INoteDb _noteDb;
        private readonly IMongoCollection<Note> _notes;
        public NoteController(INoteDb noteDb, IMongoDatabase database)
        {
            _noteDb = noteDb;
            _notes = database.GetCollection<Note>("Notes");
        }

        [HttpGet("notes")]
        [Authorize]
        public async Task<IActionResult> GetAllNotes()
        {
            var userId = User.FindFirst("id")?.Value;
            if (userId == null)
            {
                return Unauthorized();
            }
            var notes = await _noteDb.GetNotDeletedNotesById(ObjectId.Parse(userId));
            return Ok(notes);
        }
        [HttpPost("notes")]
        [Authorize]
        public async Task<IActionResult> AddNote([FromBody] List<AddNoteDTO> notesDTO, [FromServices] IValidator<AddNoteDTO> validator)
        {
            if (notesDTO == null || notesDTO.Count == 0)
                return BadRequest("No notes received");
            var userId = User.FindFirst("id")?.Value;
            if (userId == null)
            {
                return Unauthorized();
            }
            try
            {
                foreach (var noteDTO in notesDTO)
                {
                    var result = validator.Validate(noteDTO);

                    if (!result.IsValid)
                    {
                        return BadRequest(result.Errors.First().ErrorMessage);
                    }
                    
                    var createdAt = DateTimeOffset
                    .FromUnixTimeMilliseconds(noteDTO.CreatedAt)
                    .UtcDateTime;
                    Note existing = await _notes.Find(n => n.NoteId == noteDTO.NoteId).FirstOrDefaultAsync();
                    if (existing == null)
                    {
                        Note note = new()
                        {
                            Id = ObjectId.GenerateNewId(),
                            NoteId = noteDTO.NoteId,
                            UserId = ObjectId.Parse(userId),
                            Title = noteDTO.Title,
                            Content = noteDTO.Content,
                            CreatedAt = createdAt,
                            IsDeleted = false,
                            DeletedAt = null
                        };
                        await _noteDb.AddNote(note);
                    }
                    else
                    {
                        Note note = new()
                        {
                            Id = existing.Id,
                            NoteId = noteDTO.NoteId,
                            UserId = ObjectId.Parse(userId),
                            Title = noteDTO.Title,
                            Content = noteDTO.Content,
                            CreatedAt = createdAt,
                            IsDeleted = existing.IsDeleted,
                            DeletedAt = existing.DeletedAt
                        };
                        await _noteDb.UpdateNote(note);
                    }
                    
                }
                return Ok("Notes added successfully");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}

