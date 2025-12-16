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

        public async Task<bool> DeleteUser(ObjectId id)
        {
            User? user = await _users.Find(u => u.Id == id).FirstOrDefaultAsync();
            if (user == null)
            {
                return false;
            }
            await _users.DeleteOneAsync(u => u.Id == id);
            return true;
        }

        public async Task<User?> ForgetPassword(string email, string password)
        { 
            User? user = await _users.Find(u => u.Email == email.Trim()).FirstOrDefaultAsync();
            if (user == null)
            {
                return null;
            }
            user.Password = _passwordHasher.HashPassword(user, password);
            await _users.ReplaceOneAsync(u => u.Email == email.Trim(), user);
            return user;
        }

        public async Task<User?> GetUser(string email, string password)
        {
            User? user = await _users.Find(u => u.Email == email.Trim()).FirstOrDefaultAsync();
            if (user == null) {
                return null;
            }
            var result = _passwordHasher.VerifyHashedPassword(user, user.Password, password);
            if (result == PasswordVerificationResult.Success)
            {
                return user;
            }
            return null;
        }

        public async Task ResetPassword(ObjectId id, string password)
        {
            User? user = await _users.Find(u => u.Id == id).FirstOrDefaultAsync();
            if (user == null)
            {
                return;
            }
            user.Password = _passwordHasher.HashPassword(user, password);
            await _users.ReplaceOneAsync(u => u.Id == id, user);
        }
    }
}
