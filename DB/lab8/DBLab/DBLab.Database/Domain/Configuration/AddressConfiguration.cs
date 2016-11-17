using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class AddressConfiguration: EntityTypeConfiguration<Address>
    {
        public AddressConfiguration()
        {
            ToTable("Address");

            HasKey(a => a.Id);
            Property(a => a.Country).HasMaxLength(FieldLengthConstants.SmallFieldLength);
            Property(a => a.City).HasMaxLength(FieldLengthConstants.SmallFieldLength);
            Property(a => a.Street).HasMaxLength(FieldLengthConstants.SmallFieldLength);
        }
    }
}
