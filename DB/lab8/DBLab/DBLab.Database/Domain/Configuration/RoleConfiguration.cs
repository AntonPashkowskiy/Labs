using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class RoleConfiguration: EntityTypeConfiguration<Role>
    {
        public RoleConfiguration()
        {
            ToTable("Role");

            HasKey(r => r.Id);
            Property(r => r.Description).HasMaxLength(FieldLengthConstants.LongFieldLength);
            Property(r => r.Responsibility).HasMaxLength(FieldLengthConstants.LongFieldLength);
            Property(r => r.Salary).HasColumnType("Money");
        }
    }
}
