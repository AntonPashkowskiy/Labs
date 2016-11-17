using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class DetailProducerConfiguration: EntityTypeConfiguration<DetailProducer>
    {
        public DetailProducerConfiguration()
        {
            ToTable("DetailProducer");

            HasKey(dp => dp.Id);
            HasRequired(dp => dp.Address).WithMany().HasForeignKey(dp => dp.AddressId);
            HasRequired(dp => dp.ContactDetails).WithMany().HasForeignKey(dp => dp.ContactDetailsId);
            HasRequired(dp => dp.Branch).WithMany().HasForeignKey(dp => dp.BranchId);
            Property(dp => dp.CompanyName).HasMaxLength(FieldLengthConstants.MediumFieldLength);
        }
    }
}
