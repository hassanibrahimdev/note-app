using Microsoft.AspNetCore.Identity;
using MongoDB.Bson;
using MongoDB.Driver;
using NoteApp.Models;

namespace NoteApp.Services
{
    public class UserDb : IUserDb
    {
        private readonly IMongoCollection<User> _users;
        private readonly PasswordHasher<User> _passwordHasher;
        public UserDb(IMongoDatabase database)
        {
            _users = database.GetCollection<User>("Users");
            _passwordHasher = new PasswordHasher<User>();
        }
        public async Task<User> AddUser(UserModel user)
        {
            User u = new()
            {
                Email = user.Email,
                Name = user.Name
            };
            u.Password = _passwordHasher.HashPassword(u, user.Password);

            await _users.InsertOneAsync(u);
            return u;
        }

        public Task DeleteUser(ObjectId id)
        {
            throw new NotImplementedException();
        }

        public Task ForgetPassword(string email, string password)
        {
            throw new NotImplementedException();
        }

        public Task<User?> GetUser(string email, string password)
        {
            throw new NotImplementedException();
        }

        public Task ResetPassword(ObjectId id, string password)
        {
            throw new NotImplementedException();
        }
    }
}
