﻿using System;
using NHibernate.Validator.Constraints;
using SharpArch.Core.DomainModel;

namespace DecisionesInteligentes.Colef.Sia.Core
{
    public class Glosario : Entity, IBaseEntity
    {
        [NotNullNotEmpty]
        public virtual string Campo { get; set; }

        [NotNullNotEmpty]
        public virtual string Descripcion { get; set; }

        [NotNullNotEmpty]
        public virtual string Contexto { get; set; }

        public virtual Usuario CreadoPor { get; set; }

        public virtual DateTime CreadoEl { get; set; }

        public virtual Usuario ModificadoPor { get; set; }

        public virtual DateTime ModificadoEl { get; set; }

        public virtual bool Activo { get; set; }
    }
}
