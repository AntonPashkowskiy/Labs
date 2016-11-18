using DBLab.Database.UnitOfWork.Interfaces;
using DBLab.Database.Domain;
using DBLab.Database.Context;
using DBLab.Database.UnitOfWork.Repositories;

namespace DBLab.Database.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork
    {
        #region Field

        private bool _isDisposed = false;
        private ComputersRepairServiceDbContext _databaseContext;
        private IRepository<Address> _addressRepository;
        private IRepository<Branch> _branchRepository;
        private IRepository<Client> _clientRepository;
        private IRepository<ComputerDetail> _computerDetailRepository;
        private IRepository<ContactDetails> _contanctDetailRepository;
        private IRepository<DetailProducerDocument> _detailProducerDocumentRepository;
        private IRepository<DetailProducer> _detailProducerRepository;
        private IRepository<Detail> _detailRepository;
        private IRepository<Document> _documentRepository;
        private IRepository<EmployeeDocument> _employeeDocumentRepository;
        private IRepository<Employee> _employeeRepository;
        private IRepository<EquipmentDocument> _equipmentDocumentRepository;
        private IRepository<Equipment> _equipmentRepository;
        private IRepository<Order> _orderRepository;
        private IRepository<Role> _roleRepository;
        private IRepository<Schedule> _scheduleRepository;

        #endregion

        #region Ctor

        public UnitOfWork(string connectionString)
        {
            _databaseContext = new ComputersRepairServiceDbContext(connectionString);
        }

        #endregion

        #region Repositories

        public IRepository<Address> Addresses
        {
            get
            {
                if (_addressRepository == null)
                {
                    _addressRepository = new Repository<Address>(_databaseContext);
                }
                return _addressRepository;
            }
        }

        public IRepository<Branch> Branches
        {
            get
            {
                if (_branchRepository == null)
                {
                    _branchRepository = new Repository<Branch>(_databaseContext);
                }
                return _branchRepository;
            }
        }

        public IRepository<Client> Clients
        {
            get
            {
                if (_clientRepository == null)
                {
                    _clientRepository = new Repository<Client>(_databaseContext);
                }
                return _clientRepository;
            }
        }

        public IRepository<ComputerDetail> ComputerDetails
        {
            get
            {
                if (_computerDetailRepository == null)
                {
                    _computerDetailRepository = new Repository<ComputerDetail>(_databaseContext);
                }
                return _computerDetailRepository;
            }
        }

        public IRepository<ContactDetails> ContactDetails
        {
            get
            {
                if (_contanctDetailRepository == null)
                {
                    _contanctDetailRepository = new Repository<ContactDetails>(_databaseContext);
                }
                return _contanctDetailRepository;
            }
        }

        public IRepository<DetailProducerDocument> DetailProducerDocuments
        {
            get
            {
                if (_detailProducerDocumentRepository == null)
                {
                    _detailProducerDocumentRepository = new Repository<DetailProducerDocument>(_databaseContext);
                }
                return _detailProducerDocumentRepository;
            }
        }

        public IRepository<DetailProducer> DetailProducers
        {
            get
            {
                if (_detailProducerRepository == null)
                {
                    _detailProducerRepository = new Repository<DetailProducer>(_databaseContext);
                }
                return _detailProducerRepository;
            }
        }

        public IRepository<Detail> Details
        {
            get
            {
                if (_detailRepository == null)
                {
                    _detailRepository = new Repository<Detail>(_databaseContext);
                }
                return _detailRepository;
            }
        }

        public IRepository<Document> Documents
        {
            get
            {
                if (_documentRepository == null)
                {
                    _documentRepository = new Repository<Document>(_databaseContext);
                }
                return _documentRepository;
            }
        }

        public IRepository<EmployeeDocument> EmployeeDocuments
        {
            get
            {
                if (_employeeDocumentRepository == null)
                {
                    _employeeDocumentRepository = new Repository<EmployeeDocument>(_databaseContext);
                }
                return _employeeDocumentRepository;
            }
        }

        public IRepository<Employee> Employees
        {
            get
            {
                if (_employeeRepository == null)
                {
                    _employeeRepository = new Repository<Employee>(_databaseContext);
                }
                return _employeeRepository;
            }
        }

        public IRepository<EquipmentDocument> EquipmentDocuments
        {
            get
            {
                if (_equipmentDocumentRepository == null)
                {
                    _equipmentDocumentRepository = new Repository<EquipmentDocument>(_databaseContext);
                }
                return _equipmentDocumentRepository;
            }
        }

        public IRepository<Equipment> Equipments
        {
            get
            {
                if (_equipmentRepository == null)
                {
                    _equipmentRepository = new Repository<Equipment>(_databaseContext);
                }
                return _equipmentRepository;
            }
        }

        public IRepository<Order> Orders
        {
            get
            {
                if (_orderRepository == null)
                {
                    _orderRepository = new Repository<Order>(_databaseContext);
                }
                return _orderRepository;
            }
        }

        public IRepository<Role> Roles
        {
            get
            {
                if (_roleRepository == null)
                {
                    _roleRepository = new Repository<Role>(_databaseContext);
                }
                return _roleRepository;
            }
        }

        public IRepository<Schedule> Schedules
        {
            get
            {
                if (_scheduleRepository == null)
                {
                    _scheduleRepository = new Repository<Schedule>(_databaseContext);
                }
                return _scheduleRepository;
            }
        }

        #endregion

        #region Public methods

        public void Dispose()
        {
            if (!_isDisposed)
            {
                _databaseContext.Dispose();
                _isDisposed = true;
            }
        }

        public void Save()
        {
            if (!_isDisposed)
            {
                _databaseContext.SaveChanges();
            }
        } 

        #endregion
    }
}
