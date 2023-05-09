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

bool compare_ITime(filme a, filme b) {
  return a.hInicio > b.hInicio;
}

// ##################### EXAUSTIVA ###########################

void Exaustiva()
{
    int nfilmes, ncategorias, total, comp_total = 0;
    cin >> nfilmes >> ncategorias;

    vector<int> filmesPorCats;
    vector<filme> filmes;

    bitset<24> horas(0x0000000000000000000);

    bitset<64> bitsetFilmes(0);

    filmesPorCats.reserve(ncategorias);

    // TODO: PARALELIZAR
    for (int i=0; i<ncategorias; i++)
    {
        cin >> filmesPorCats[i];
    }


    // TODO: PARALELIZAR
    for (int i=0; i<nfilmes; i++)
    {
        filme this_film;
        this_film.id = i;
        cin >> this_film.hInicio >> this_film.hFinal >> this_film.categoria;
        filmes.push_back(this_film);
    }

    
    // NOTE: Aqui é o for de 0 a 2^filmes - faz todas as possibilidades
    // TODO: PARALELIZAR

    for (int i=0;i<pow(2, nfilmes); i++)
    {
        total = 0;
        bitsetFilmes = i;
        for (int j=0; j<nfilmes; j++)
        {
            if (bitsetFilmes[j])
            {
                filme valor = filmes[j];
                if (valor.hInicio <= valor.hFinal){
                    if (filmesPorCats[valor.categoria] <= 0)
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
                        filmesPorCats[valor.categoria]--;
                        total += 1;
                        cout << "ID: " << valor.id << endl;
                    }
                }
            }
        }
        if (total > comp_total)
        {
            comp_total = total;
        }
    }

    cout << "\nTOTAL GLOBAL: " << comp_total << endl;

    // DONE: LEMBRE-SE QUE SE FIZER UM LOOP PARA PRINTAR O BITSET, ELE SAIRÁ INVERTIDO (LÓGICA DO BIT MENOS SIGNIFICATIVO SENDO PRINTADO PRIMEIRO)

    // VETOR DE FILMES
    // INICIALIZA COMO 0
    // E CONTA QUANTOS FILMES E SETA COMO MÁXIMO (MAXIMO INICIAL EH ZERO)

    // O BITSET REPRESENTA OS FILMES, AI COLOCA 1 PRA SE O FILME FOI ESCOLHIDO OU 0 PRA SE NAO FOI ESCOLHIDO

    // FOR DE 0 À 2^LEN(BITSET)
    //     - FAZ UMA POSSIBILIDADE, E TESTA PRA VER SE ENCAIXA NO VETOR DE HORARIO
    //     FAZ PRA TODOS
    //     RETORNA O TOTAL DE FILMES ESCOLHIDOS

    // OUTRO FOR
    // CHECA TODAS AS RESPOSTAS, E PROCURA O MAIOR

}


int main()
{
    
    Exaustiva();
    
    return 0;
}