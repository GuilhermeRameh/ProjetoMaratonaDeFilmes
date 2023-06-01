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


// void ParTHRUST()
// {
//     __device__

//     int nfilmes, ncategorias, comp_total = 0;
//     cin >> nfilmes >> ncategorias;

//     vector<int> filmesPorCats, fpcReset, total_values;
//     vector<filme> filmes;

//     filmesPorCats.resize(ncategorias);
//     fpcReset.resize(ncategorias);

//     // NOTE: Não paralelizavel pois possui o CIN
//     for (int i=0; i<ncategorias; i++)
//     {
//         cin >> filmesPorCats[i];
//         fpcReset[i] = filmesPorCats[i];
//     }

//     // NOTE: Não paralelizavel pois possui o CIN
//     for (int i=0; i<nfilmes; i++)
//     {
//         filme this_film;
//         this_film.id = i;
//         cin >> this_film.hInicio >> this_film.hFinal >> this_film.categoria;
//         filmes.push_back(this_film);
//     }

//     int nExpo = pow(2, nfilmes);


//     thrust::device_vector<int> output(nExpo);
//     for (int i = 0; i < nExpo; i++)
//     {
        
//         vector<bool> horas(24);
//         vector<bool> bitsetFilmes(64);
//         vector<int> localfilmesPorCats;
//         localfilmesPorCats.resize(ncategorias);

//         int local_total_iteration = 0;
//         int temp_num = nfilmes;
        
//         // Prepara o vetor de filmes
//         while (temp_num > 0)
//         {
//             bitsetFilmes.push_back(temp_num & 1);
//             cout << (temp_num & 1);
//             temp_num >>= 1;
//         }

//         // Reseta as Horas
//         for (int j=0; j<24; j++)
//         {
//             horas[j] = 0;
//         }
        

//         for (int i=0; i<ncategorias; i++)
//         {
//             localfilmesPorCats[i] = fpcReset[i] ;
//         }

//         // cout << omp_get_thread_num() << " " << i << endl;

//         for (int j=0; j<nfilmes; j++)
//         {            
//             if (bitsetFilmes[j])
//             {
//                 filme valor = filmes[j];
                
//                 if (valor.hInicio <= valor.hFinal){
//                     if (localfilmesPorCats[valor.categoria] <= 0)
//                     {
//                         break;
//                     }
//                     vector<bool> mascara(24);
//                     for (int i = valor.hInicio; i <= valor.hFinal; i++) {
//                         mascara[i] = true;
//                     }

//                     // cout << "\nInicio: " << valor.hInicio << " Final: " << valor.hFinal;

//                     bool resultado;
//                     for (int i=0; i<24; i++)
//                     {
//                         resultado &= horas[i] & mascara[i];
//                     }

//                     if (resultado == 0)
//                     {
//                         for (int i = valor.hInicio; i <= valor.hFinal; i++) {
//                             horas[i] = true;
//                         }
//                         localfilmesPorCats[valor.categoria]--;
//                         local_total_iteration += 1;
//                         // cout << "  > Iter - " << i << "   ID: " << valor.id << endl;
//                     }
//                 }
//             }
//         }
//     }

//     std::cout << "\nTOTAL GLOBAL: " << comp_total << std::endl;
// }


int main(void)
{
    // ParTHRUST();

    // H has storage for 4 integers
    thrust::host_vector<int> H(4);

    // initialize individual elements
    H[0] = 14;
    H[1] = 20;
    H[2] = 38;
    H[3] = 46;
    
    // H.size() returns the size of vector H
    std::cout << "H has size " << H.size() << std::endl;

    // print contents of H
    for(size_t i = 0; i < H.size(); i++)
        std::cout << "H[" << i << "] = " << H[i] << std::endl;

    // resize H
    H.resize(2);
    
    std::cout << "H now has size " << H.size() << std::endl;

    // Copy host_vector H to device_vector D
    thrust::device_vector<int> D = H;
    
    // elements of D can be modified
    D[0] = 99;
    D[1] = 88;
    
    // print contents of D
    for(size_t i = 0; i < D.size(); i++)
        std::cout << "D[" << i << "] = " << D[i] << std::endl;

    // H and D are automatically deleted when the function returns
    return 0;
}