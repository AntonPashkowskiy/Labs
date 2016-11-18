using System;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Reflection;

namespace DBLab.Database.Context
{
    public class ComputersRepairServiceDbContext: DbContext, IBaseDbContext
    {
        #region Ctor

        public ComputersRepairServiceDbContext(string connectionString) : base(connectionString)
        {
        }

        #endregion

        #region Public Methods

        public new IDbSet<TEntity> Set<TEntity>() where TEntity: class
        {
            return base.Set<TEntity>();
        }

        #endregion

        #region Protected Methods

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            RegisterEntitiesConfiguration(modelBuilder);
            base.OnModelCreating(modelBuilder);
        }

        #endregion

        #region Private Methods

        private void RegisterEntitiesConfiguration(DbModelBuilder modelBuilder)
        {
            var currentAssembly = Assembly.GetExecutingAssembly();
            var configurationTypes = currentAssembly.GetTypes()
                .Where(t => t.IsSubclassOf(typeof(EntityTypeConfiguration<>)));

            foreach (var type in configurationTypes)
            {
                dynamic configurationInstance = Activator.CreateInstance(type);
                modelBuilder.Configurations.Add(configurationInstance);
            }
        }

        #endregion
    }
}
