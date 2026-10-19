using Microsoft.EntityFrameworkCore;
using RaceDay.Api.Models;

namespace RaceDay.Api.Data;

public class RaceDayDbContext : DbContext
{
    public RaceDayDbContext(DbContextOptions<RaceDayDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Role> Roles { get; set; }
    public DbSet<Event> Events { get; set; }
    public DbSet<Enrolment> Enrolments { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Map Role Entity
        modelBuilder.Entity<Role>(entity =>
        {
            entity.ToTable("Roles");
            entity.HasKey(r => r.RoleId);
            entity.Property(r => r.RoleId).ValueGeneratedOnAdd();
            entity.Property(r => r.RoleName).IsRequired().HasMaxLength(50);
        });

        // Map User Entity
        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("Users");
            entity.HasKey(u => u.UserId);
            entity.Property(u => u.UserId).ValueGeneratedOnAdd();
            entity.Property(u => u.FullName).IsRequired().HasMaxLength(100);
            entity.Property(u => u.Email).IsRequired().HasMaxLength(100);
            entity.Property(u => u.PasswordHash).IsRequired();
            entity.Property(u => u.PhoneNumber).HasMaxLength(20).IsRequired(false);
            entity.Property(u => u.CreatedAt).HasDefaultValueSql("GETDATE()");

            // Explicitly bind RoleId foreign key to avoid shadow column 'RoleId1'
            entity.HasOne(u => u.Role)
                  .WithMany()
                  .HasForeignKey(u => u.RoleId)
                  .IsRequired()
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // Map Event Entity
        modelBuilder.Entity<Event>(entity =>
        {
            entity.ToTable("Events");
            entity.HasKey(e => e.EventId);
            entity.Property(e => e.EventId).ValueGeneratedOnAdd();
            entity.Property(e => e.Title).IsRequired().HasMaxLength(150);
            entity.Property(e => e.Description).HasMaxLength(1000);
            entity.Property(e => e.Location).IsRequired().HasMaxLength(200);

            entity.HasOne(e => e.Organiser)
                  .WithMany()
                  .HasForeignKey(e => e.OrganiserId)
                  .IsRequired()
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // Map Enrolment Entity
        modelBuilder.Entity<Enrolment>(entity =>
        {
            entity.ToTable("Enrolments");
            entity.HasKey(en => en.EnrolmentId);
            entity.Property(en => en.EnrolmentId).ValueGeneratedOnAdd();

            entity.HasOne(en => en.Participant)
                  .WithMany()
                  .HasForeignKey(en => en.ParticipantId)
                  .IsRequired()
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(en => en.Category)
                  .WithMany()
                  .HasForeignKey(en => en.CategoryId)
                  .IsRequired()
                  .OnDelete(DeleteBehavior.Restrict);
        });
    }
}