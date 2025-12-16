using MongoDB.Bson;
using NoteApp.Models;

namespace NoteApp.Services
{
    public interface IUserDb
    {
        public Task<User> AddUser(UserModel user);
        public Task<User?> GetUser(string email, string password);
        public Task ResetPassword(ObjectId id, string password);
        public Task<User?> ForgetPassword(string email, string password);
        public Task<bool> DeleteUser(ObjectId id);
    }
}
