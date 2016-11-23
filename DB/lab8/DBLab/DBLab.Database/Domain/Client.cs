
namespace DBLab.Database.Domain
{
    public class Client: BaseEntity
    {
        public int ContactDetailsId { get; set; }
        public int CountOfVisits { get; set; }

        public virtual ContactDetails ContactDetails { get; set; }
    }
}
