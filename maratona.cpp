#include <chrono>
#include <random>
#include <fstream>
#include <boost/random.hpp>
#include <bitset>
#include <map>

using namespace std;

struct filme {
    int id; 
    int hInicio;
    int hFinal;
    int categoria;
};


bool compare_endTime(filme a, filme b) {
  return a.hFinal > b.hFinal;
}


// ##################### GULOSA ###########################

void heuristicaGulosa()
{
    int nfilmes, ncategorias, temp;
    cin >> nfilmes >> ncategorias;

    vector<int> filmesPorCats;
    vector<filme> filmes;

    bitset<24> horas(0x0000000000000000000);

    filmesPorCats.reserve(ncategorias);

    for (int i=0; i<ncategorias; i++)
    {
        cin >> filmesPorCats[i];
    }


    map<int, vector<filme>> dicionario;
    for (int i=0; i<nfilmes; i++)
    {
        filme this_film;
        this_film.id = i;
        cin >> this_film.hInicio >> this_film.hFinal >> this_film.categoria;
        filmes.push_back(this_film);

        dicionario[filmes[i].hFinal].push_back(filmes[i]);
    }


    for (auto it = dicionario.begin(); it != dicionario.end(); ++it)
    {
        int key = it->first;
        for (filme valor : it->second)
        {
            if (valor.hInicio <= valor.hFinal){
                if (filmesPorCats[valor.categoria] <= 0)
                {
                    break;
                }
                bitset<24> mascara;
                for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                    mascara.set(i);
                }

                bitset<24> resultado = horas & mascara;

                if (resultado == 0)
                {
                    for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                        horas.set(i);
                    }
                    filmesPorCats[valor.categoria]--;
                    cout << "Id: " << valor.id << " | " << valor.hInicio << "-" << valor.hFinal << " : " << valor.categoria << endl;
                }
            }
        }
    }
}


// ##################### +ALEATORIA ###########################

void heuristicaComAleatoria()
{
    int nfilmes, ncategorias, temp;
    cin >> nfilmes >> ncategorias;

    vector<int> filmesPorCats;
    vector<filme> filmes;

    bitset<24> horas(0x0000000000000000000);

    filmesPorCats.reserve(ncategorias);

    for (int i=0; i<ncategorias; i++)
    {
        cin >> filmesPorCats[i];
    }


    map<int, vector<filme>> dicionario;
    for (int i=0; i<nfilmes; i++)
    {
        filme this_film;
        this_film.id = i;
        cin >> this_film.hInicio >> this_film.hFinal >> this_film.categoria;
        filmes.push_back(this_film);

        dicionario[filmes[i].hFinal].push_back(filmes[i]);
    }

    // NOTE: Parte da aleatorização
    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
    default_random_engine generator (seed);

    uniform_int_distribution<int>tf_distribution(0, 4);
    uniform_int_distribution<int>choose_dist(0, nfilmes);
    auto it = dicionario.begin();
    while (it != dicionario.end())
    {
        int choose_at_random = tf_distribution(generator);
        if (choose_at_random%4==0)
        {
            int modifier = choose_dist(generator);
            if (modifier>=dicionario.size()) modifier -= dicionario.size();
            auto randit = next(dicionario.begin(), modifier);
            if (randit != dicionario.end()){
                int key = randit->first;
            
                for (filme valor : randit->second)
                {
                    if (valor.hInicio <= valor.hFinal){
                        if (filmesPorCats[valor.categoria] <= 0)
                        {
                            break;
                        }
                        bitset<24> mascara;
                        for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                            mascara.set(i);
                        }

                        bitset<24> resultado = horas & mascara;

                        if (resultado == 0)
                        {
                            for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                                horas.set(i);
                            }
                            filmesPorCats[valor.categoria]--;
                            cout << "Id: " << valor.id << " | " << valor.hInicio << "-" << valor.hFinal << " : " << valor.categoria << endl;
                            break;
                        }  
                    }
                }
            }
        }
        else
        {
            int key = it->first;
            for (filme valor : it->second)
            {
                if (valor.hInicio <= valor.hFinal){
                    if (filmesPorCats[valor.categoria] <= 0)
                    {
                        break;
                    }
                    bitset<24> mascara;
                    for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                        mascara.set(i);
                    }

                    bitset<24> resultado = horas & mascara;

                    if (resultado == 0)
                    {
                        for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                            horas.set(i);
                        }
                        filmesPorCats[valor.categoria]--;
                        cout << "Id: " << valor.id << " | " << valor.hInicio << "-" << valor.hFinal << " : " << valor.categoria << endl;
                    }
                }
            }
            ++it;
        }
    }
}



// NOTE: loop para printar o dicionario

// for (auto it = dicionario.begin(); it != dicionario.end(); ++it) {
//     std::cout << "Chave: " << it->first << std::endl;
//     std::cout << "Valores: ";
//     for (auto valor : it->second) {
//         std::cout << valor.id << " " << valor.hInicio << "; ";
//     }
//     std::cout << std::endl;
// }



int main()
{
    heuristicaComAleatoria();
    return 0;
}