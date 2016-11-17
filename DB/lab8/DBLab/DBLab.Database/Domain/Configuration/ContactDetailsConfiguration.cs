using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class ContactDetailsConfiguration: EntityTypeConfiguration<ContactDetails>
    {
        public ContactDetailsConfiguration()
        {
            ToTable("ContactDetails");

            HasKey(cd => cd.Id);
            Property(cd => cd.FirstName).HasMaxLength(FieldLengthConstants.SmallFieldLength);
            Property(cd => cd.LastName).HasMaxLength(FieldLengthConstants.SmallFieldLength);
            Property(cd => cd.PhoneNumber).HasMaxLength(FieldLengthConstants.SmallFieldLength);
            Property(cd => cd.Email).HasMaxLength(FieldLengthConstants.SmallFieldLength);
        }
    }
}
