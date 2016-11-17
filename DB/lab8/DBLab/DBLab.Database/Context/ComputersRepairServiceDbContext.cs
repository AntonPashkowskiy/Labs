using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBLab.Database.Context
{
    public class ComputersRepairServiceDbContext: DbContext
    {
        #region Ctor

        public ComputersRepairServiceDbContext(string connectionString) : base(connectionString)
        {
        }

        #endregion

        #region Properties

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

        }

        #endregion
    }
}
