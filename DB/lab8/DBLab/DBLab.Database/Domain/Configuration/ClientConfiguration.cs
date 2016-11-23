using System.Data.Entity.ModelConfiguration;

namespace DBLab.Database.Domain.Configuration
{
    public class ClientConfiguration: EntityTypeConfiguration<Client>
    {
        public ClientConfiguration()
        {
            ToTable("Client");

            HasKey(c => c.Id);
            HasRequired(c => c.ContactDetails).WithMany().HasForeignKey(c => c.ContactDetailsId);
        }
    }
}
