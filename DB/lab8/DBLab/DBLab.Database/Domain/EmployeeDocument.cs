
namespace DBLab.Database.Domain
{
    public class EmployeeDocument
    {
        public int EmployeeId { get; set; }
        public int DocumentId { get; set; }

        public virtual Employee Employee { get; set; }
        public virtual Document Document { get; set; }
    }
}
