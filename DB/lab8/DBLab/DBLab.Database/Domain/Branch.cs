using System;

namespace DBLab.Database.Domain
{
    public class Branch: BaseEntity
    {
        public int AddressId { get; set; }
        public int RegistrationNumber { get; set; }
        public DateTime StartDate { get; set; }

        public virtual Address Address { get; set; }
    }
}
