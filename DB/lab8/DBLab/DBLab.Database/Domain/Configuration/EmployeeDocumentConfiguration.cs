using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class EmployeeDocumentConfiguration: EntityTypeConfiguration<EmployeeDocument>
    {
        public EmployeeDocumentConfiguration()
        {
            ToTable("EmployeeDocument");

            HasKey(ed => ed.EmployeeId);
            HasKey(ed => ed.DocumentId);
            HasRequired(ed => ed.Employee).WithMany().HasForeignKey(ed => ed.EmployeeId);
            HasRequired(ed => ed.Document).WithMany().HasForeignKey(ed => ed.DocumentId);
        }
    }
}
