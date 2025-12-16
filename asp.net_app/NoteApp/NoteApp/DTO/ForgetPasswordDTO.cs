namespace NoteApp.DTO
{
    public class ForgetPasswordDTO
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string VerifyCode { get; set; }
    }

}
