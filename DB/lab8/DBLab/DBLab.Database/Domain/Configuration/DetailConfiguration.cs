using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class DetailConfiguration: EntityTypeConfiguration<Detail>
    {
        public DetailConfiguration()
        {
            ToTable("Detail");

            HasKey(d => d.Id);
            Property(d => d.Description).HasMaxLength(FieldLengthConstants.LongFieldLength);
            Property(d => d.Price).HasColumnType("Money");
        }
    }
}
