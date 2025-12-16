using System.ComponentModel.DataAnnotations;

namespace NoteApp.DTO
{
    public class ResetPasswordDTO
    {
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
    }
}
