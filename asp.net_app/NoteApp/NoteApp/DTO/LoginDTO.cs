using System.ComponentModel.DataAnnotations;

namespace NoteApp.DTO
{
    public class LoginDTO
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }
}
