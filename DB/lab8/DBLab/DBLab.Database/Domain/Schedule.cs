
namespace DBLab.Database.Domain
{
    public class Schedule: BaseEntity
    {
        public string WeekDays { get; set; }
        public string Hours { get; set; }
    }
}
