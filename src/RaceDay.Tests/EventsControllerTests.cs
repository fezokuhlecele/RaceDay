using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RaceDay.Api.Controllers;
using RaceDay.Api.Data;
using RaceDay.Api.Dtos;
using RaceDay.Api.Models;
using Xunit;

namespace RaceDay.Tests;

public class EventsControllerTests
{
    private RaceDayDbContext GetDatabaseContext()
    {
        var options = new DbContextOptionsBuilder<RaceDayDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        var context = new RaceDayDbContext(options);
        context.Database.EnsureCreated();
        return context;
    }

    [Fact]
    public async Task GetAllEvents_ReturnsOkResult_WithEventsList()
    {
        var context = GetDatabaseContext();
        context.Events.Add(new Event { Title = "Comrades 2027", Description = "Ultra", Location = "Durban", EventDate = DateTime.Now, OrganiserId = 1 });
        await context.SaveChangesAsync();

        var controller = new EventsController(context);

        var result = await controller.GetAllEvents();

        var okResult = Assert.IsType<OkObjectResult>(result);
        var events = Assert.IsAssignableFrom<IEnumerable<EventResponseDto>>(okResult.Value);
        Assert.Single(events);
    }

    [Fact]
    public async Task CreateEvent_ValidOrganiser_ReturnsCreatedAtAction()
    {
        var context = GetDatabaseContext();
        var controller = new EventsController(context);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new Claim[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1"),
            new Claim(ClaimTypes.Role, "Organiser")
        }, "mock"));

        controller.ControllerContext = new ControllerContext()
        {
            HttpContext = new DefaultHttpContext() { User = user }
        };

        var dto = new CreateEventDto("Cape Town Cycle Tour", "109km Ride", "Cape Town", DateTime.Now.AddDays(30));

        var result = await controller.CreateEvent(dto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        var returnItem = Assert.IsType<EventResponseDto>(createdResult.Value);
        Assert.Equal("Cape Town Cycle Tour", returnItem.Title);
    }
}