using System;

namespace DBLab.Database.Domain
{
    public class DetailProducer: BaseEntity
    {
        public int BranchId { get; set; }
        public int ContactDetailsId { get; set; }
        public int AddressId { get; set; }
        public string CompanyName { get; set; }
        public DateTime StartDate { get; set; }

        public virtual Branch Branch { get; set; }
        public virtual ContactDetails ContactDetails { get; set; }
        public virtual Address Address { get; set; }
    }
}
