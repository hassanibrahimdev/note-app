using FluentValidation;
using NoteApp.DTO;

namespace NoteApp.Validations
{
    public class AddNoteValidation : AbstractValidator<AddNoteDTO>
    {
        public AddNoteValidation()
        {
            RuleFor(x => x.NoteId.Trim())
                .NotEmpty().WithMessage("Id is required");
            RuleFor(x => x.Title.Trim())
                .NotEmpty().WithMessage("Title is required");
            RuleFor(x => x.Content.Trim())
                .NotEmpty().WithMessage("Content is required");
            RuleFor(x => x.CreatedAt)
                .GreaterThan(0).WithMessage("CreatedAt must be a positive integer");

        }
    }
}
