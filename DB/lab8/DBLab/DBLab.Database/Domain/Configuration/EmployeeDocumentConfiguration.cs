using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class EmployeeDocumentConfiguration: EntityTypeConfiguration<EmployeeDocument>
    {
        public EmployeeDocumentConfiguration()
        {
            ToTable("EmployeeDocument");

            HasKey(ed => new { ed.EmployeeId, ed.DocumentId });
            HasRequired(ed => ed.Employee).WithMany().HasForeignKey(ed => ed.EmployeeId);
            HasRequired(ed => ed.Document).WithMany().HasForeignKey(ed => ed.DocumentId);
        }
    }
}
