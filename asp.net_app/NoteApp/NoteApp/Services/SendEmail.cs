using MailKit.Net.Smtp;
using MimeKit;

namespace NoteApp.Services
{
    public class SendEmail : ISendEmail
    {
        private readonly IConfiguration _config;

        public SendEmail(IConfiguration configuration)
        {
            _config = configuration;
        }
        public async Task SendVerificationCode(string toEmail, string subject, string message)
        {
            var email = new MimeMessage();
            email.From.Add(new MailboxAddress("Your App", _config["email:from"]));
            email.To.Add(new MailboxAddress("", toEmail));
            email.Subject = subject;

            email.Body = new TextPart("html")
            {
                Text = message
            };

            using var smtp = new SmtpClient();
            await smtp.ConnectAsync("smtp.gmail.com", 587, false);
            await smtp.AuthenticateAsync(_config["email:from"], _config["email:pass"]);
            await smtp.SendAsync(email);
            await smtp.DisconnectAsync(true);
        }
    }
}
