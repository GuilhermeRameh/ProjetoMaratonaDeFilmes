#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/reduce.h>
#include <thrust/extrema.h>
#include <iostream>
#include <vector>

using namespace std;

struct filme
{
    int id;
    int hInicio;
    int hFinal;
    int categoria;
};


struct AddFunctor {
    __host__ __device__
    int operator()(int i, int ncategorias, int nfilmes) {

        bitset<24> horas(0x0000000000000000000);
        bitset<64> bitsetFilmes(0);
        vector<int> localfilmesPorCats;
        localfilmesPorCats.resize(ncategorias);

        int local_total_iteration = 0;
        bitsetFilmes = i;
        horas = 0;

        for (int i=0; i<ncategorias; i++)
        {
            localfilmesPorCats[i] = fpcReset[i] ;
        }

        // cout << omp_get_thread_num() << " " << i << endl;

        for (int j=0; j<nfilmes; j++)
        {            
            if (bitsetFilmes[j])
            {
                filme valor = filmes[j];
                
                if (valor.hInicio <= valor.hFinal){
                    if (localfilmesPorCats[valor.categoria] <= 0)
                    {
                        break;
                    }
                    bitset<24> mascara;
                    for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                        mascara.set(i);
                    }

                    // cout << "\nInicio: " << valor.hInicio << " Final: " << valor.hFinal;

                    bitset<24> resultado = horas & mascara;

                    if (resultado == 0)
                    {
                        for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                            horas.set(i);
                        }
                        localfilmesPorCats[valor.categoria]--;
                        local_total_iteration += 1;
                        // cout << "  > Iter - " << i << "   ID: " << valor.id << endl;
                    }
                }
            }
        }


        return x;
    }
};


void ParTHRUST()
{
    int nfilmes, ncategorias, comp_total = 0;
    cin >> nfilmes >> ncategorias;

    vector<int> filmesPorCats, fpcReset, total_values;
    vector<filme> filmes;

    filmesPorCats.resize(ncategorias);
    fpcReset.resize(ncategorias);

    // NOTE: Não paralelizavel pois possui o CIN
    for (int i=0; i<ncategorias; i++)
    {
        cin >> filmesPorCats[i];
        fpcReset[i] = filmesPorCats[i];
    }

    // NOTE: Não paralelizavel pois possui o CIN
    for (int i=0; i<nfilmes; i++)
    {
        filme this_film;
        this_film.id = i;
        cin >> this_film.hInicio >> this_film.hFinal >> this_film.categoria;
        filmes.push_back(this_film);
    }

    int nExpo = pow(2, nfilmes);


    thrust::device_vector<int> input(nExpo);
    for (int i = 0; i < nExpo; i++)
    {
        input[i] = i;
    }



    std::cout << "\nTOTAL GLOBAL: " << comp_total << std::endl;
}


int main()
{
    ParTHRUST();
    return 0;
}