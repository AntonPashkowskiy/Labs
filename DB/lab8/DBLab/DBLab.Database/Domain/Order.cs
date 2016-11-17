using System;

namespace DBLab.Database.Domain
{
    public class Order: BaseEntity
    {
        public int ClientId { get; set; }
        public int BranchId { get; set; }
        public int BillingAmount { get; set; }
        public DateTime ServiceStartDay { get; set; }
        public DateTime ServiceEndDay { get; set; }

        public virtual Client Client { get; set; }
        public virtual Branch Branch { get; set; }
    }
}
