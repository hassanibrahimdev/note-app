using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using NoteApp.DTO;
using NoteApp.Models;
using NoteApp.Services;
using StackExchange.Redis;

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
        public async Task<IActionResult> SendVerifyCode([FromBody] VerifyEmailDTO verifyEmailDTO)
        {

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
        public async Task<IActionResult> signup([FromBody] UserRegisterDTO userRegisterDTO)
        {
            EmailCode? emailCode = await _emailCodeDb.GetEmailCode(userRegisterDTO.Email.Trim());
            if (emailCode == null)
            {
                return BadRequest("email is incorrect!!");
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

    }
}
