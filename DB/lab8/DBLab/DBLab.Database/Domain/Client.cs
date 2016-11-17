
namespace DBLab.Database.Domain
{
    public class Client: BaseEntity
    {
        public int ContactDetailId { get; set; }
        public int CountOfVisits { get; set; }

        public virtual ContactDetails ContactDetails { get; set; }
    }
}
