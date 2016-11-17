using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class EmployeeConfiguration: EntityTypeConfiguration<Employee>
    {
        public EmployeeConfiguration()
        {
            ToTable("Employee");

            HasKey(e => e.Id);
            HasRequired(e => e.Schedule).WithMany().HasForeignKey(e => e.ScheduleId);
            HasRequired(e => e.Role).WithMany().HasForeignKey(e => e.RoleId);
            HasRequired(e => e.Branch).WithMany().HasForeignKey(e => e.BranchId);
        }
    }
}
