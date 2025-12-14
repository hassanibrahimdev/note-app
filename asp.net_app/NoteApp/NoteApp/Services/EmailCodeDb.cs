
using MongoDB.Driver;
using NoteApp.Models;

namespace NoteApp.Services
{
    public class EmailCodeDb : IEmailCodeDb
    {
        private readonly IMongoCollection<EmailCode> _emailCode;
        public EmailCodeDb(IMongoDatabase database)
        {
            _emailCode = database.GetCollection<EmailCode>("EmailCode");
        }

        public async Task<EmailCode?> GetEmailCode(string email)
        {
            EmailCode code = await _emailCode.Find(e => e.Email.Equals(email.Trim())).FirstOrDefaultAsync();
            return code;
        }

        public async Task SetEmailCode(EmailCodeModel model)
        {
            {
                EmailCode emailCode = await _emailCode.Find(e => e.Email.Equals(model.Email.Trim())).FirstOrDefaultAsync();
                if (emailCode == null)
                {
                    EmailCode email = new()
                    {
                        Email = model.Email.Trim(),
                        Code = model.Code.Trim(),
                        ExpiredTime = model.ExpiredTime
                    };
                    await _emailCode.InsertOneAsync(email);
                    return;
                }
                emailCode.Code = model.Code.Trim();
                emailCode.ExpiredTime = model.ExpiredTime;
                await _emailCode.ReplaceOneAsync(e => e.Email.Equals(model.Email), emailCode);
                return;
            }

        }
    }
}
