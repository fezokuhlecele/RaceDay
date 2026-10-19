namespace RaceDay.Api.Dtos;

public record RegisterDto(string FullName, string Email, string Password, string PhoneNumber, string RoleName);
public record LoginDto(string Email, string Password);
public record AuthResponseDto(string Token, string Email, string Role, int UserId);

public record CreateEventDto(string Title, string Description, string Location, DateTime EventDate);
public record EventResponseDto(int EventId, string Title, string Description, string Location, DateTime EventDate, int OrganiserId);

public record CreateEnrolmentDto(int CategoryId);
public record EnrolmentResponseDto(int EnrolmentId, int ParticipantId, string ParticipantName, int CategoryId, string CategoryName, DateTime EnrolmentDate);