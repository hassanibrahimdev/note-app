using System.ComponentModel.DataAnnotations;

namespace NoteApp.DTO
{
    public class VerifyEmailDTO
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }
    }
}
