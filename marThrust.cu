#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/reduce.h>
#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

struct filme
{
    int id;
    int hInicio;
    int hFinal;
    int categoria;
};


struct CheckFilm {
    int ncategorias;
    int nfilmes;
    thrust::host_vector<int> fpcReset;
    thrust::host_vector<filme> filmes;

    CheckFilm(int ncat, int nflm, thrust::host_vector<int> reset, thrust::host_vector<filme> flm) : 
    ncategorias(ncat), nfilmes(nflm), fpcReset(reset), filmes(flm) {}

    __host__ __device__
    int operator()(int i)
    {
        thrust::device_vector<bool> horas(24);
        thrust::device_vector<bool> bitsetFilmes(64);
        thrust::device_vector<int> localfilmesPorCats;
        localfilmesPorCats.resize(ncategorias);

        int local_total_iteration = 0;
        int temp_num = nfilmes;
        
        // Prepara o vetor de filmes
        while (temp_num > 0)
        {
            bitsetFilmes.push_back(temp_num & 1);
            temp_num >>= 1;
        }

        // Reseta as Horas
        for (int j=0; j<24; j++)
        {
            horas[j] = 0;
        }
        

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
                    thrust::device_vector<bool> mascara(24);
                    for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                        mascara[i] = true;
                    }

                    // cout << "\nInicio: " << valor.hInicio << " Final: " << valor.hFinal;

                    bool resultado;
                    for (int i=0; i<24; i++)
                    {
                        resultado &= horas[i] & mascara[i];
                    }

                    if (resultado == false)
                    {
                        for (int i = valor.hInicio; i <= valor.hFinal; i++) {
                            horas[i] = true;
                        }
                        localfilmesPorCats[valor.categoria]--;
                        local_total_iteration += 1;
                        // cout << "  > Iter - " << i << "   ID: " << valor.id << endl;
                    }
                }
            }
        }
        return local_total_iteration;
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
    thrust::device_vector<int> output(nExpo);
    for (int i = 0; i < nExpo; i++)
    {
        input[i] = i;        
    }

    CheckFilm myFunctor(ncategorias, nfilmes, fpcReset, filmes);

    thrust::transform(input.begin(), input.end(), output.begin(), myFunctor);

    std::cout << "\nTOTAL GLOBAL: " << comp_total << std::endl;
}


int main(void)
{
    ParTHRUST();
    return 0;
}