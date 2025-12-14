using NoteApp.Models;

namespace NoteApp.Services
{
    public interface IEmailCodeDb
    {
        public Task SetEmailCode(EmailCodeModel model); 
        public Task<EmailCode?> GetEmailCode(string email);
    }
}
