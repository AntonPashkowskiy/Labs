using System.Data.Entity;

namespace DBLab.Database.Context
{
    public interface IBaseDbContext
    {
        IDbSet<TEntity> Set<TEntity>() where TEntity : class;
    }
}
