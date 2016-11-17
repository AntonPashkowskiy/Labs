using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class BranchConfiguration: EntityTypeConfiguration<Branch>
    {
        public BranchConfiguration()
        {
            ToTable("Branch");

            HasKey(b => b.Id);
            HasRequired(b => b.Address).WithMany().HasForeignKey(b => b.AddressId);
        }
    }
}
