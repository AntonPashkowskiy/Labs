using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class ScheduleConfiguration: EntityTypeConfiguration<Schedule>
    {
        public ScheduleConfiguration()
        {
            ToTable("Schedule");

            HasKey(s => s.Id);
            Property(s => s.Hours).HasMaxLength(FieldLengthConstants.LongFieldLength);
            Property(s => s.WeekDays).HasMaxLength(FieldLengthConstants.LongFieldLength);
        }
    }
}
