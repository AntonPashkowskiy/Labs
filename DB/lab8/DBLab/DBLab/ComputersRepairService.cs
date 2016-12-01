using DBLab.Database.Domain;
using DBLab.Database.UnitOfWork.Interfaces;
using System;
using System.Linq;
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
                Console.WriteLine("2. Print orders statistic.");
                Console.WriteLine("3. Exit");
                Console.Write(": ");
                operation = Console.ReadKey();

                if (operation.Key == ConsoleKey.D1)
                {
                    Checkout();
                }
                else if (operation.Key == ConsoleKey.D2)
                {
                    ProcessOrderStatisticPrinting();
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
            try
            {
                var firstBranch = _dataSource.Branches.GetAll().FirstOrDefault();
                var order = new Order();
                var client = new Client();
                var equipment = new Equipment();
                var contactDetails = new ContactDetails();

                Console.WriteLine();
                FillContactDetailsData(contactDetails);
                FillEquipmentData(equipment);
                FillClientData(client);
                FillOrderData(order);

                using (var transaction = GetTransactonScopeReadCommited())
                {
                    var newContactDetails = _dataSource.ContactDetails.Create(contactDetails);
                    _dataSource.Save();

                    client.ContactDetailsId = newContactDetails.Id;
                    var newClient = _dataSource.Clients.Create(client);
                    _dataSource.Save();

                    order.ClientId = newClient.Id;
                    order.BranchId = firstBranch.Id;
                    var newOrder = _dataSource.Orders.Create(order);
                    _dataSource.Save();

                    equipment.OrderId = newOrder.Id;
                    var newEquipment = _dataSource.Equipments.Create(equipment);
                    _dataSource.Save();

                    transaction.Complete();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception occured on checkout.");
                Console.WriteLine($"{ex.Message}");
                throw;
            }
        }

        private void FillOrderData(Order order)
        {
            string currentData = string.Empty;
            var orderDataIsInvalid = true;

            do
            {
                Console.Write("Enter billing amont: ");
                currentData = Console.ReadLine();
                int billingAmount = 0;

                if (int.TryParse(currentData, out billingAmount))
                {
                    order.BillingAmount = billingAmount;
                    orderDataIsInvalid = false;
                }
                else
                {
                    Console.WriteLine("Billing amount must be integer number");
                }

            } while (orderDataIsInvalid);

            orderDataIsInvalid = true;

            do
            {
                var startDate = EnterDate("Enter start day");
                var endDate = EnterDate("Enter end day");

                if (startDate <= endDate)
                {
                    orderDataIsInvalid = false;
                    order.ServiceStartDay = startDate;
                    order.ServiceEndDay = endDate;
                }
                else
                {
                    Console.WriteLine("End date must be greater than start date.");
                }
            } while (orderDataIsInvalid);
        }

        private void FillClientData(Client client)
        {
            var clientDataIsInvalid = true;
            string currentData = string.Empty;

            do
            {
                Console.Write("Enter count of visits: ");
                currentData = Console.ReadLine();
                int countOfVisits = 0;

                if (int.TryParse(currentData, out countOfVisits))
                {
                    client.CountOfVisits = countOfVisits;
                    clientDataIsInvalid = false;
                }
                else
                {
                    Console.WriteLine("Count of visits must be integer number");
                }

            } while (clientDataIsInvalid);
        }

        private void FillEquipmentData(Equipment equipment)
        {
            string currentData = string.Empty;

            Console.Write("Enter model: ");
            currentData = Console.ReadLine();
            equipment.Model = currentData;

            Console.Write("Enter breaking description: ");
            currentData = Console.ReadLine();
            equipment.BreakingDescription = currentData;
        }

        private void FillContactDetailsData(ContactDetails contactDetails)
        {
            string currentData = string.Empty;

            Console.Write("Enter first name: ");
            currentData = Console.ReadLine();
            contactDetails.FirstName = currentData;

            Console.Write("Enter last name: ");
            currentData = Console.ReadLine();
            contactDetails.LastName = currentData;

            Console.Write("Enter phone: ");
            currentData = Console.ReadLine();
            contactDetails.PhoneNumber = currentData;

            Console.Write("Enter email: ");
            currentData = Console.ReadLine();
            contactDetails.Email = currentData;
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

        private void ProcessOrderStatisticPrinting()
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = DateTime.Now;
            bool datesIsInvalid = true;

            Console.WriteLine();

            do
            {
                startDate = EnterDate("Enter start day");
                endDate = EnterDate("Enter end day");

                if (startDate <= endDate)
                {
                    datesIsInvalid = false;
                }
                else
                {
                    Console.WriteLine("End date must be greater than start date.");
                }
            } while (datesIsInvalid);

            PrintOrdersStatistic(startDate, endDate);
        }

        private void PrintOrdersStatistic(DateTime startDate, DateTime endDate)
        {
            var orderList = _dataSource.Orders.GetAll();
            var clientList = _dataSource.Clients.GetAll();
            var equipmentList = _dataSource.Equipments.GetAll();
            var contactDetailsList = _dataSource.ContactDetails.GetAll();

            var ordersForPrinting = orderList.Where(o => o.ServiceStartDay.Date >= startDate && o.ServiceEndDay.Date <= endDate);
            Console.WriteLine("Orders billing summary: {0}", ordersForPrinting.Sum(o => o.BillingAmount).ToString());
            Console.WriteLine();

            var ordersStatistic = ordersForPrinting
                .OrderBy(o => o.ServiceStartDay)
                .GroupBy(o => o.ServiceStartDay.Date)
                .Select(g => new
                {
                    Date = g.Key,
                    OrdersCount = g.Count()
                });

            foreach (var statisticItem in ordersStatistic)
            {
                Console.WriteLine("{0}| {1}", 
                    statisticItem.Date.ToString("MM/dd/yyyy"), 
                    string.Concat(Enumerable.Repeat("#", statisticItem.OrdersCount)));           
            }
            Console.WriteLine();
        }

        private DateTime EnterDate(string greetingMessage)
        {
            string dateValueString = null;
            bool isDateEntered = false;
            DateTime date = DateTime.Now;

            do
            {
                Console.Write($"{greetingMessage}: ");
                dateValueString = Console.ReadLine();
                isDateEntered = DateTime.TryParse(dateValueString, out date);
            } while (!isDateEntered);

            return date;
        }

        #endregion
    }
}
