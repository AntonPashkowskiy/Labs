using DBLab.Database.Context;
using DBLab.Database.UnitOfWork.Interfaces;
using System.Collections.Generic;
using System.Linq;

namespace DBLab.Database.UnitOfWork.Repositories
{
    public class Repository<TEntity> : IRepository<TEntity> where TEntity : class
    {
        private readonly IBaseDbContext _databaseContext;

        #region Ctor

        public Repository(IBaseDbContext databaseContext)
        {
            _databaseContext = databaseContext;
        }

        #endregion

        public void Create(TEntity entity)
        {
            _databaseContext.Set<TEntity>().Add(entity);
        }

        public IList<TEntity> GetAll()
        {
            return _databaseContext.Set<TEntity>().Select(s => s).ToList();
        }
    }
}
