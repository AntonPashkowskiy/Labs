
namespace DBLab.Database.Domain
{
    public class EquipmentDocument
    {
        public int EquipmentId { get; set; }
        public int DocumentId { get; set; }

        public virtual Equipment Equipment { get; set; }
        public virtual Document Document { get; set; }
    }
}
