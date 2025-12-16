using FluentValidation;
using NoteApp.DTO;

namespace NoteApp.Validations
{
    public class VerifyEmailValidation: AbstractValidator<VerifyEmailDTO>
    {
        public VerifyEmailValidation()
        {
            RuleFor(x => x.Email.Trim())
                .NotEmpty().WithMessage("Email is required")
                .EmailAddress().WithMessage("Invalid email format");
        }
    }
}
