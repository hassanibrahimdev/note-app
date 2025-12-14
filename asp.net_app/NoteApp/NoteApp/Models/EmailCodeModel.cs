using System.ComponentModel.DataAnnotations;
namespace NoteApp.Models
{
    public class EmailCodeModel
    {
        public string Email { get; set; }
        public string Code { get; set; }
        public long ExpiredTime { get; set; }
    }
}
