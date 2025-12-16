using FluentValidation;
using NoteApp.DTO;

namespace NoteApp.Validations
{
    public class ResetPasswordValidation : AbstractValidator<ResetPasswordDTO>
    {
        public ResetPasswordValidation()
        {
            RuleFor(x => x.Password.Trim())
                .NotEmpty().WithMessage("Password is required")
                .MinimumLength(6).WithMessage("Password must be at least 6 characters long");
            RuleFor(x => x.ConfirmPassword.Trim())
                .NotEmpty().WithMessage("Confirm Password is required")
                .Equal(x => x.Password).WithMessage("Passwords do not match");
        }
    }
}
