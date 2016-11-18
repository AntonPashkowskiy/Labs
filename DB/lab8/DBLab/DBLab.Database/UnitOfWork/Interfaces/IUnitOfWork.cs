using DBLab.Database.Domain;
using System;

namespace DBLab.Database.UnitOfWork.Interfaces
{
    public interface IUnitOfWork: IDisposable
    {
        IRepository<Address> Addresses { get; }
        IRepository<Branch> Branches { get; }
        IRepository<Client> Clients { get; }
        IRepository<ComputerDetail> ComputerDetails { get; }
        IRepository<ContactDetails> ContactDetails { get; }
        IRepository<Detail> Details { get; }
        IRepository<DetailProducer> DetailProducers { get; }
        IRepository<DetailProducerDocument> DetailProducerDocuments { get; }
        IRepository<Document> Documents { get; }
        IRepository<Employee> Employees { get; }
        IRepository<EmployeeDocument> EmployeeDocuments { get; }
        IRepository<Equipment> Equipments { get; }
        IRepository<EquipmentDocument> EquipmentDocuments { get; }
        IRepository<Order> Orders { get; }
        IRepository<Role> Roles { get; }
        IRepository<Schedule> Schedules { get; }
        void Save();
    }
}
