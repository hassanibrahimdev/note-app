using FluentValidation;
using NoteApp.DTO;

namespace NoteApp.Validations
{
    public class ForgetPasswordValidation : AbstractValidator<ForgetPasswordDTO>
    {
        public ForgetPasswordValidation()
        {
            RuleFor(x => x.Email.Trim())
                .NotEmpty().WithMessage("Email is required")
                .EmailAddress().WithMessage("Invalid email format");
            RuleFor(x => x.Password.Trim())
                .NotEmpty().WithMessage("Password is required")
                .MinimumLength(6).WithMessage("Password must be at least 6 characters long");
            RuleFor(x => x.ConfirmPassword.Trim())
                .NotEmpty().WithMessage("Confirm Password is required")
                .Equal(x => x.Password).WithMessage("Passwords do not match");
            RuleFor(x => x.VerifyCode.Trim())
                .NotEmpty().WithMessage("Verify Code is required");
        }
    }
}
