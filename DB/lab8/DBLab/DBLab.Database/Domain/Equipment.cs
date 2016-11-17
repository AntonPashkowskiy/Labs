
namespace DBLab.Database.Domain
{
    public class Equipment: BaseEntity
    {
        public int OrderId { get; set; }
        public string Model { get; set; }
        public string BreakingDescription { get; set; }

        public virtual Order Order { get; set; }
    }
}
