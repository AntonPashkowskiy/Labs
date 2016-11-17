
namespace DBLab.Database.Domain
{
    public class Address: BaseEntity
    {
        public string Country { get; set; }
        public string City { get; set; }
        public string Street { get; set; }
    }
}
