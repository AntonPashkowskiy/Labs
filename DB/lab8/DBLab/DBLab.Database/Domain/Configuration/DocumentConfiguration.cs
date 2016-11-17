using DBLab.Database.Constants;
using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class DocumentConfiguration: EntityTypeConfiguration<Document>
    {
        public DocumentConfiguration()
        {
            ToTable("Document");

            HasKey(d => d.Id);
            Property(d => d.FileName).HasMaxLength(FieldLengthConstants.LongFieldLength);
            Property(d => d.FileType).HasMaxLength(FieldLengthConstants.SmallFieldLength);
        }
    }
}
