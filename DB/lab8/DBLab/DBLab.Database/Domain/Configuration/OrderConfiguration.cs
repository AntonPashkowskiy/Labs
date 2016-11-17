using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class OrderConfiguration: EntityTypeConfiguration<Order>
    {
        public OrderConfiguration()
        {
            ToTable("Order");

            HasKey(o => o.Id);
            HasRequired(o => o.Branch).WithMany().HasForeignKey(o => o.BranchId);
            HasRequired(o => o.Client).WithMany().HasForeignKey(o => o.ClientId);
        }
    }
}
