﻿using System.Collections.Generic;

namespace DBLab.Database.UnitOfWork.Interfaces
{
    public interface IRepository<TEntity> where TEntity: class
    {
        IList<TEntity> GetAll();
        void Create(TEntity entity);
    }
}
