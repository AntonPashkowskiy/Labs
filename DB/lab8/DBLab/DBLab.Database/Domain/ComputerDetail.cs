
namespace DBLab.Database.Domain
{
    public class ComputerDetail
    {
        public int DetailProducerId { get; set; }
        public int DetailId { get; set; }
        public int WarrancyCardNumber { get; set; }
        public string SupportedInterfaces { get; set; }

        public virtual DetailProducer DetailProducer { get; set; }
        public virtual Detail Detail { get; set; }
    }
}
