using NoteApp.Models;

namespace NoteApp.Services
{
    public interface IEmailCodeDb
    {
        public Task SetEmailCode(EmailCodeModel model);
        public Task ChangeIsReaded(string email);
        public Task<EmailCode?> GetEmailCode(string email);
    }
}
