using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class EquipmentConfiguration: EntityTypeConfiguration<Equipment>
    {
        public EquipmentConfiguration()
        {
            ToTable("Equipment");

            HasKey(e => e.Id);
            HasRequired(e => e.Order).WithMany().HasForeignKey(e => e.OrderId);
            Property(e => e.Model).HasMaxLength(FieldLengthConstants.MediumFieldLength);
            Property(e => e.BreakingDescription).HasMaxLength(FieldLengthConstants.LongFieldLength);
        }
    }
}
