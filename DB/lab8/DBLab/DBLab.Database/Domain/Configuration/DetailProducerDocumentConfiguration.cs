using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class DetailProducerDocumentConfiguration: EntityTypeConfiguration<DetailProducerDocument>
    {
        public DetailProducerDocumentConfiguration()
        {
            ToTable("DetailProducerDocument");

            HasKey(dpd => dpd.DetailProducerId);
            HasKey(dpd => dpd.DocumentId);
            HasRequired(dpd => dpd.DetailProducer).WithMany().HasForeignKey(dpd => dpd.DetailProducerId);
            HasRequired(dpd => dpd.Document).WithMany().HasForeignKey(dpd => dpd.DocumentId);
        }
    }
}
