using System.Text;
using FluentValidation;
using Microsoft.IdentityModel.Tokens;
using MongoDB.Driver;
using NoteApp.DTO;
using NoteApp.Models;
using NoteApp.Services;
using NoteApp.Validations;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

builder.Services.AddSingleton<IMongoClient>(sp =>
{
    var config = sp.GetRequiredService<IConfiguration>();
    var connectionString = config["MongoDb:ConnectionString"];

    return new MongoClient(connectionString);
});



builder.Services.AddSingleton(sp =>
{
    var client = sp.GetRequiredService<IMongoClient>();
    var dbName = builder.Configuration["MongoDb:DatabaseName"];
    var db = client.GetDatabase(dbName);

    // CREATE UNIQUE INDEX HERE
    var usersCollection = db.GetCollection<User>("Users");

    usersCollection.Indexes.CreateOne(
        new CreateIndexModel<User>(
            Builders<User>.IndexKeys.Ascending(u => u.Email),
            new CreateIndexOptions { Unique = true }
        )
    );

    return db;
});

builder.Services.AddAuthentication("Bearer")
    .AddJwtBearer("Bearer", options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"])
            ),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });
builder.Services.AddValidatorsFromAssemblyContaining<UserRegisterValidation>();
builder.Services.AddValidatorsFromAssemblyContaining<VerifyEmailValidation>();
builder.Services.AddValidatorsFromAssemblyContaining<ResetPasswordValidation>();
builder.Services.AddValidatorsFromAssemblyContaining<LoginValidation>();
builder.Services.AddValidatorsFromAssemblyContaining<ForgetPasswordValidation>();

builder.Services.AddAuthorization();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter",
        builder => builder
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod());
});

builder.Services.AddSingleton<IUserDb, UserDb>();
builder.Services.AddSingleton<ISendEmail, SendEmail>();
builder.Services.AddSingleton<IEmailCodeDb,EmailCodeDb>();
builder.Services.AddSingleton<TokenService>();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseCors("AllowFlutter");

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();

