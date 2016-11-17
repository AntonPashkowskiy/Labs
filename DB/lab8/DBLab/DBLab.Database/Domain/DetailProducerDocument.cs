
namespace DBLab.Database.Domain
{
    public class DetailProducerDocument
    {
        public int DetailProducerId { get; set; }
        public int DocumentId { get; set; }

        public virtual Document Document { get; set; }
        public virtual DetailProducer DetailProducer { get; set; }
    }
}
