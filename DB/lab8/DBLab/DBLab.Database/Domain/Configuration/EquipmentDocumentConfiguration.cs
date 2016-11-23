using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class EquipmentDocumentConfiguration: EntityTypeConfiguration<EquipmentDocument>
    {
        public EquipmentDocumentConfiguration()
        {
            ToTable("EquipmentDocument");

            HasKey(ed => new { ed.EquipmentId, ed.DocumentId });
            HasRequired(ed => ed.Equipment).WithMany().HasForeignKey(ed => ed.EquipmentId);
            HasRequired(ed => ed.Document).WithMany().HasForeignKey(ed => ed.DocumentId);
        }
    }
}
