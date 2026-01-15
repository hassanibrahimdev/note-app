using FluentValidation;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using NoteApp.DTO;
using NoteApp.Models;
using NoteApp.Services;
using NoteApp.Validations;
using StackExchange.Redis;
using System.Security.Claims;

namespace NoteApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserDb _userDb;
        private readonly IEmailCodeDb _emailCodeDb;
        private readonly TokenService _tokenService;
        private readonly ISendEmail _sendEmail;
        public UserController(IUserDb userDb, TokenService tokenService, ISendEmail sendEmail, IEmailCodeDb emailCodeDb)
        {
            _userDb = userDb;
            _tokenService = tokenService;
            _sendEmail = sendEmail;
            _emailCodeDb = emailCodeDb;
        }


        [HttpPost("verifycode")]
        public async Task<IActionResult> SendVerifyCode([FromBody] VerifyEmailDTO verifyEmailDTO, [FromServices] IValidator<VerifyEmailDTO> validator)
        {

            var result = validator.Validate(verifyEmailDTO);
            if (!result.IsValid)
            {
                return BadRequest(result.Errors.First().ErrorMessage);
            }
            Random random = new();
            string verifyCode = random.Next(100000, 999999).ToString();
            try
            {

                await _sendEmail.SendVerificationCode(verifyEmailDTO.Email.Trim(), "Note App", "your verification code is:" + verifyCode);
                EmailCodeModel emailCodeModel = new EmailCodeModel()
                {
                    Email = verifyEmailDTO.Email.Trim(),
                    Code = verifyCode.ToString(),
                    ExpiredTime = DateTimeOffset.Now.ToUnixTimeSeconds() + (5 * 60)
                };
                await _emailCodeDb.SetEmailCode(emailCodeModel);
                return Ok("Verification code sent successfully");
            }
            catch (Exception)
            {
                return BadRequest("something went wrong");
            }
        }




        [HttpPost("signup")]
        public async Task<IActionResult> Signup([FromBody] UserRegisterDTO userRegisterDTO, [FromServices] IValidator<UserRegisterDTO> validator)
        {
            var result = validator.Validate(userRegisterDTO);

            if (!result.IsValid)
            {
                // Return first error as plain string
                return BadRequest(result.Errors.First().ErrorMessage);
            }
            EmailCode? emailCode = await _emailCodeDb.GetEmailCode(userRegisterDTO.Email.Trim());
            if (emailCode == null)
            {
                return BadRequest("email is incorrect!!");
            }
            if (emailCode.IsReaded)
            {
                return BadRequest("code used!!");

            }
            if (emailCode.ExpiredTime <= DateTimeOffset.Now.ToUnixTimeSeconds())
            {
                return BadRequest("Code is expired or invalid!!!");
            }
            if (emailCode.Code != userRegisterDTO.VerifyCode)
            {
                return BadRequest("code is incorrect!!");
            }
            UserModel userModel = new()
            {
                Email = userRegisterDTO.Email.Trim(),
                Name = userRegisterDTO.Name.Trim(),
                Password = userRegisterDTO.Password.Trim(),
            };

            User user = await _userDb.AddUser(userModel);
            await _emailCodeDb.ChangeIsReaded(userRegisterDTO.Email.Trim());
            string token = _tokenService.createToken(user.Id.ToString());
            string userId = user.Id.ToString();
            return Ok(new
            {
                userId,
                user = new
                {
                    user.Name,
                    user.Email
                },
                token
            });
        }




        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDTO loginDTO, [FromServices] IValidator<LoginDTO> validator)
        {
            var result = validator.Validate(loginDTO);
            if (!result.IsValid)
            {
                return BadRequest(result.Errors.First().ErrorMessage);
            }
            User? user = await _userDb.GetUser(loginDTO.Email, loginDTO.Password);
            if (user == null)
            {
                return BadRequest("email or password is incorrect!!");
            }
            string token = _tokenService.createToken(user.Id.ToString());
            string userId = user.Id.ToString();
            return Ok(new
            {
                userId,
                user = new
                {
                    user.Name,
                    user.Email
                },
                token
            });
        }




        [HttpPut("resetpassword")]
        [Authorize]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDTO resetPasswordDTO, [FromServices] IValidator<ResetPasswordDTO> validator)
        {
            var result = validator.Validate(resetPasswordDTO);
            if (!result.IsValid)
            {
                return BadRequest(result.Errors.First().ErrorMessage);
            }
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userId == null)
            {
                Unauthorized();
            }
            try
            {
                await _userDb.ResetPassword(new MongoDB.Bson.ObjectId(userId), resetPasswordDTO.Password);
                return Ok("Password reset successfully");
            }
            catch (Exception)
            {
                return BadRequest("something went wrong");
            }

        }



        [HttpPut("forgetpassword")]
        public async Task<IActionResult> ForgetPassword([FromBody] ForgetPasswordDTO forgetPasswordDTO, [FromServices] IValidator<ForgetPasswordDTO> validator)
        {
            var result = validator.Validate(forgetPasswordDTO);
            if (!result.IsValid)
            {
                return BadRequest(result.Errors.First().ErrorMessage);
            }
            EmailCode? emailCode = await _emailCodeDb.GetEmailCode(forgetPasswordDTO.Email.Trim());
            if (emailCode == null)
            {
                return BadRequest("email is incorrect!!");
            }
            if (emailCode.IsReaded)
            {
                return BadRequest("code used!!");
            }
            if (emailCode.ExpiredTime <= DateTimeOffset.Now.ToUnixTimeSeconds())
            {
                return BadRequest("Code is expired or invalid!!!");
            }
            if (emailCode.Code != forgetPasswordDTO.VerifyCode)
            {
                return BadRequest("code is incorrect!!");
            }
            try
            {
                User? user = await _userDb.ForgetPassword(forgetPasswordDTO.Email.Trim(), forgetPasswordDTO.Password.Trim());
                if (user == null)
                {
                    return BadRequest("email is incorrect!!");
                }
                await _emailCodeDb.ChangeIsReaded(forgetPasswordDTO.Email.Trim());
                return Ok("Password reset successfully");
            }
            catch (Exception)
            {
                return BadRequest("something went wrong");
            }
        }
        [HttpDelete("deleteuser")]
        [Authorize]
        public async Task<IActionResult> DeleteUser()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
            {
                Unauthorized();
            }
            try
            {
                bool isDeleted = await _userDb.DeleteUser(new MongoDB.Bson.ObjectId(userId));
                if (!isDeleted)
                {
                    return BadRequest("User not found");
                }
                return Ok("User deleted successfully");
            }
            catch (Exception)
            {
                return BadRequest("something went wrong");
            }
        }
    }
}
