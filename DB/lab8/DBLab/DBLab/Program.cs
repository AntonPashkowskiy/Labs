using DBLab.Database.UnitOfWork;
using System.Configuration;

namespace DBLab
{
    class Program
    {
        static void Main(string[] args)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;
            var unitOfWork = new UnitOfWork(connectionString);
            var computersRepairService = new ComputersRepairService(unitOfWork);

            computersRepairService.ShowMenu();
        }
    }
}
