
namespace DBLab.Database.Domain
{
    public class Role: BaseEntity
    {
        public string Description { get; set; }
        public string Responsibility { get; set; }
        public decimal Salary { get; set; }
    }
}
