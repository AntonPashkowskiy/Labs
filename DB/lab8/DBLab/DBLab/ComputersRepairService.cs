using DBLab.Database.Domain;
using DBLab.Database.UnitOfWork.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace DBLab
{
    public class ComputersRepairService
    {
        #region Fields

        private IUnitOfWork _dataSource;

        #endregion

        #region Ctor

        public ComputersRepairService(IUnitOfWork dataSource)
        {
            if (dataSource != null)
            {
                _dataSource = dataSource;
            }
            else
            {
                throw new ArgumentNullException("Data source is required.");
            }
        }

        #endregion

        #region Public Methods

        public void ShowMenu()
        {
            ConsoleKeyInfo operation;

            do
            {
                Console.Clear();
                Console.WriteLine("Select operation:");
                Console.WriteLine("1. Checkout");
                Console.WriteLine("2. Print orders list.");
                Console.WriteLine("3. Exit");
                Console.Write(": ");
                operation = Console.ReadKey();

                if (operation.Key == ConsoleKey.D1)
                {
                    Checkout();
                }
                else if (operation.Key == ConsoleKey.D2)
                {
                    PrintOrderList();
                }
                else
                {
                    break;
                }
                Console.WriteLine("Press any key to continue...");
                Console.ReadKey();

            } while (true);
        }

        #endregion

        #region Private methods

        private void Checkout()
        {
            string currentData = string.Empty;
            var firstBranch = _dataSource.Branches.GetAll().FirstOrDefault();

            var order = new Order();
            var client = new Client();
            var equipment = new Equipment();
            var contactDetails = new ContactDetails();



            using (var transaction = GetTransactonScopeReadCommited())
            {
                transaction.Complete();
            }
        }

        private TransactionScope GetTransactonScopeReadCommited()
        {
            return new TransactionScope(
                TransactionScopeOption.RequiresNew, 
                new TransactionOptions
                {
                    IsolationLevel = IsolationLevel.ReadCommitted
                }
            );
        }

        private void PrintOrderList()
        {
            var orderList = _dataSource.Orders.GetAll();
            var clientList = _dataSource.Clients.GetAll();
            var equipmentList = _dataSource.Equipments.GetAll();
            var contactDetailsList = _dataSource.ContactDetails.GetAll();

            foreach (var order in orderList)
            {
                var client = clientList.FirstOrDefault(c => c.Id == order.ClientId);
                var equipment = equipmentList.FirstOrDefault(e => e.OrderId == order.Id);
                var contactDetails = contactDetailsList.FirstOrDefault(cd => cd.Id == client.ContactDetailsId);

                Console.WriteLine();
                Console.WriteLine("-----");
                Console.WriteLine(
                    string.Format(
                        "Order - billing amount ({0}), service date range ({1} - {2})", 
                        order.BillingAmount, 
                        order.ServiceEndDay, 
                        order.ServiceEndDay
                    )
                );
                Console.WriteLine(
                    string.Format(
                        "Equipment - model ({0}), breaking description ({1})",
                        equipment.Model,
                        equipment.BreakingDescription
                    )
                );
                var clientName = string.Format("{0} {1}", contactDetails.FirstName, contactDetails.LastName);

                Console.WriteLine(
                    string.Format(
                        "Client - name ({0}), phone({1}), email ({2}), count of visits ({3})", 
                        clientName, 
                        contactDetails.PhoneNumber, 
                        contactDetails.Email,
                        client.CountOfVisits
                    )
                );
                Console.WriteLine();
            }
        }

        #endregion
    }
}
