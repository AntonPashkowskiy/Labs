using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class ComputerDetailConfiguration: EntityTypeConfiguration<ComputerDetail>
    {
        public ComputerDetailConfiguration()
        {
            ToTable("ComputerDetail");

            HasKey(cd => new { cd.DetailProducerId, cd.DetailId });
            HasRequired(cd => cd.DetailProducer).WithMany().HasForeignKey(cd => cd.DetailProducerId);
            HasRequired(cd => cd.Detail).WithMany().HasForeignKey(cd => cd.DetailId);
            Property(cd => cd.SupportedInterfaces).HasMaxLength(FieldLengthConstants.LongFieldLength);
        }
    }
}
