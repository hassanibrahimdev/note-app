using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace NoteApp.Services
{
    public class TokenService
    {
        private readonly IConfiguration _config;
        public TokenService(IConfiguration configuration)
        {
            _config = configuration;
        }
        public string createToken(String id)
        {
            // 1. Read JWT settings
            var key = _config["Jwt:Key"];
            var issuer = _config["Jwt:Issuer"];
            var audience = _config["Jwt:Audience"];
            // 2. Convert secret key to bytes
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key!));
            // 3. Signing credentials (HS256)
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
            // 4. Add claims to identify the user
            var claims = new[]{
                new Claim("id", id),
                 new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())};
            // 5. Create the JWT object
            var token = new JwtSecurityToken(
            issuer,
            audience,
            claims,
            expires: DateTime.UtcNow.AddMinutes(30),
             signingCredentials: credentials
            );
            // 6. Convert JWT object to string
            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
