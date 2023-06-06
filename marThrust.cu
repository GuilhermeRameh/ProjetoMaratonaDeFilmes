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


void ParTHRUST()
{   
    int nfilmes, ncategorias, comp_total = 0;
    cin >> nfilmes >> ncategorias;

    thrust::host_vector<int> filmesPorCats, fpcReset, total_values;
    thrust::host_vector<filme> filmes;

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

    thrust::device_vector<int> t_fpcReset = fpcReset;
    thrust::device_vector<filme> t_filmes = filmes;

    thrust::device_vector<int> output(nExpo);
    for (int i = 0; i < nExpo; i++)
    {
        thrust::device_vector<bool> horas(24, false);
        thrust::device_vector<bool> bitsetFilmes(nfilmes, false);
        thrust::device_vector<int> localfilmesPorCats;
        localfilmesPorCats.resize(ncategorias);

        int local_total_iteration = 0;
        int temp_num = i;
        int iter = 0;
        
        // Prepara o vetor de filmes
        while (temp_num > 0)
        {
            bitsetFilmes[iter] = (temp_num & 1);
            temp_num >>= 1;
            iter++;
        }
       
       
        // Reseta as Horas
        for (int j=0; j<24; j++)
        {
            horas[j] = false;
        }
        

        for (int j = 0; j < ncategorias; j++)
        {
            localfilmesPorCats[j] = t_fpcReset[j];
        }

        // cout << omp_get_thread_num() << " " << i << endl;

        for (int j=0; j<nfilmes; j++)
        {            
            if (bitsetFilmes[j])
            {
                filme valor = t_filmes[j];

                if (valor.hInicio <= valor.hFinal){
                    if (localfilmesPorCats[valor.categoria-1] <= 0)
                    {
                        break;
                    }
                    thrust::device_vector<bool> mascara(24);
                    for (int k = valor.hInicio; k <= valor.hFinal; k++) {
                        mascara[k] = true;
                    }

                    // cout << "\nInicio: " << valor.hInicio << " Final: " << valor.hFinal;

                    bool resultado = true;
                    for (int k=0; k<24; k++)
                    {
                        resultado = resultado && horas[k] && mascara[k];
                    }

                    if (resultado == false)
                    {
                        for (int k = valor.hInicio; k <= valor.hFinal; k++) {
                            horas[k] = true;
                        }
                        localfilmesPorCats[valor.categoria-1] = localfilmesPorCats[valor.categoria-1]-1;
                        local_total_iteration += 1;
                    }
                }
            }
        }
        output[i] = local_total_iteration;
    }


    comp_total = thrust::reduce(output.begin(), output.end(), -1, thrust::maximum<int>());

    std::cout << "\nTOTAL GLOBAL: " << comp_total << std::endl;
}


int main(void)
{
    ParTHRUST();
    return 0;
}
