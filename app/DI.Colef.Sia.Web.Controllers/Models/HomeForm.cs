using DecisionesInteligentes.Colef.Sia.Core.DataInterfaces;

namespace DecisionesInteligentes.Colef.Sia.Web.Controllers.Models
{
    public class HomeForm
    {
        public ProductoDTO[] ProduccionAcademica { get; set; }

        public ProductoDTO[] FormacionRecursosHumanos { get; set; }

        public ProductoDTO[] Proyectos { get; set; }

        public ProductoDTO[] Vinculacion { get; set; }

        public ProductoDTO[] Eventos { get; set;}

        public string NombreProducto { get; set; }

        public int IdProducto { get; set; }

        public int TipoProducto { get; set; }

        public int GuidNumber { get; set; }

        public InvestigadorForm[] Investigadores { get; set; }

        public DepartamentoForm[] Departamentos { get; set; }

        public int FilterType { get; set; }
    }
}