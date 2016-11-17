using System;

namespace DBLab.Database.Domain
{
    public class Employee: BaseEntity
    {
        public int ScheduleId { get; set; }
        public int RoleId { get; set; }
        public int BranchId { get; set; }
        public DateTime StartDate { get; set; }

        public virtual Schedule Schedule { get; set; }
        public virtual Role Role { get; set; }
        public virtual Branch Branch { get; set; }
    }
}
