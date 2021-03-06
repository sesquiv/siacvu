using System;
using DecisionesInteligentes.Colef.Sia.Core.NHibernateValidator;
using NHibernate.Validator.Constraints;
using SharpArch.Core.DomainModel;

namespace DecisionesInteligentes.Colef.Sia.Core
{
    [CoautorExternoProductoValidator]
    public class CoautorExternoProducto : Entity, IBaseEntity
    {
        [NotNull]
        public virtual InvestigadorExterno InvestigadorExterno { get; set; }

        public virtual Institucion Institucion { get; set; }

        public virtual int TipoProducto { get; set; }

        public virtual int Posicion { get; set; }

        public virtual bool CoautorSeOrdenaAlfabeticamente { get; set; }

        public virtual Usuario CreadoPor { get; set; }

        public virtual DateTime CreadoEl { get; set; }

        public virtual Usuario ModificadoPor { get; set; }

        public virtual DateTime ModificadoEl { get; set; }

        public virtual bool Activo { get; set; }
    }

    public class CoautorExternoArticulo : CoautorExternoProducto
    {
        
    }

    public class CoautorExternoCapitulo : CoautorExternoProducto
    {

    }

    public class CoautorExternoEvento : CoautorExternoProducto
    {
        
    }

    public class CoautorExternoLibro : CoautorExternoProducto
    {
        
    }

    public class CoautorExternoReporte : CoautorExternoProducto
    {
        
    }

    public class CoautorExternoResena : CoautorExternoProducto
    {
        
    }

    public class CoautorExternoObraTraducida : CoautorExternoProducto
    {

    }

    public class MiembroExternoGrupoInvestigacion : CoautorExternoProducto
    {
        
    }
}