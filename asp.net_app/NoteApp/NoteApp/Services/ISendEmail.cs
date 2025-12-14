namespace NoteApp.Services
{
    public interface ISendEmail
    {
        public Task SendVerificationCode(string toEmail, string subject, string message);
    }

}
