using FluentValidation;
using NoteApp.DTO;

namespace NoteApp.Validations
{
    public class UserRegisterValidation : AbstractValidator<UserRegisterDTO>
    {
        public UserRegisterValidation()
        {
            RuleFor(x => x.Name)
                .NotEmpty().WithMessage("Name is required")
                .MaximumLength(50).WithMessage("Name must not exceed 50 characters");
            RuleFor(x => x.Email)
                .NotEmpty().WithMessage("Email is required")
                .EmailAddress().WithMessage("Invalid email format");
            RuleFor(x => x.Password)
                .NotEmpty().WithMessage("Password is required")
                .MinimumLength(8).WithMessage("Password must be at least 8 characters long");
            RuleFor(x => x.ConfirmPassword)
                .NotEmpty().WithMessage("Confirm Password is required")
                .Equal(x => x.Password).WithMessage("Passwords do not match");
            RuleFor(x => x.VerifyCode)
                .NotEmpty().WithMessage("Verification code is required");
        }
    }
}
