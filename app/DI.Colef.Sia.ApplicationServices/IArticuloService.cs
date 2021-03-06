using DecisionesInteligentes.Colef.Sia.Core;

namespace DecisionesInteligentes.Colef.Sia.ApplicationServices
{
    public interface IArticuloService
    {
        Articulo GetArticuloById(int id);
        Articulo[] GetAllArticulos();
        Articulo[] GetAllArticulos(Usuario usuario);
        Articulo[] GetActiveArticulos();
        void SaveArticulo(Articulo articulo);
        void SaveArticulo(Articulo articulo, bool useCommit);
    }
}
