#include <iostream>
#include <fstream>
#include <cmath>
#include <sstream>
#include <vector>
#include <string>
#include <array>
#include <omp.h>
#include <unistd.h>
#include <dirent.h>
#include <tuple>

using namespace std;

vector<string> splitter(string str, char delim){

    vector<string> split;

    int start = 0;
    int len = 0;
    string runner;

    for(int i = 0; i < str.length(); i++){
        if(str[i] != delim){
            len += 1;
        }
    
        if (str[i] == delim  || i == str.length() -1 ){
            if (len != 0){
                runner = str.substr(start,len);
                split.push_back(runner);
                len = 0;
            }
            start = i + 1;
        }
    }
    return split;
}


float fc(float cutoff, float Rxy)
{
    float fc;
    if (Rxy <= cutoff)
    {
        fc = 0.5 * (cos(M_PI * Rxy/cutoff) + 1);
    }
    else{
        fc = 0;
    }
    return fc;
}

void write_csv(string csvfile, vector<float> vals, string molname){
    ofstream outfile(csvfile,ios_base::app);
    outfile << molname << ",";
    for(int i = 0; i < vals.size() - 1 ; i++)
    {
        outfile << vals[i] << ","; 
    }
    outfile << vals.back() << "\n";
    outfile.close();
}

float distance_between_2(array<float,3> c1, array<float,3> c2){
    return sqrt(pow(c1[0] - c2[0],2) + pow(c1[1] - c2[1],2) + pow(c1[2] - c2[2],2));
}

//returns cos_theta of angle between three points centred at c1
float get_angle_between_three(array<float,3> c1, array<float,3> c2, array<float,3> c3){

    //Find two vectors, both emitted from point c1
    //v1: c1 --> c2
    //v2: c1 --> c3

    array<float,3> v1 = {c2[0] - c1[0], c2[1] - c1[1], c2[2] - c1[2]};
    array<float,3> v2 = {c3[0] - c1[0], c3[1] - c1[1], c3[2] - c1[2]};

    float dotp = (v1[0] * v2[0]) + (v1[1] * v2[1]) + (v1[2] * v2[2]);
    float magv1 = sqrt(pow(v1[0],2) + pow(v1[1],2) + pow(v1[2],2));
    float magv2 = sqrt(pow(v2[0],2) + pow(v2[1],2) + pow(v2[2],2));

    float cos_theta = (dotp/(magv1 * magv2));

    return cos_theta;
}

float calculate_g2(vector<string> split, vector<string> elements, vector<array<float,3>> coords){
    float g2 = 0;
    string central_e = split[1];
    string second_e = split[3];
    float eta = stof(split[4]);
    float rs = stof(split[5]);
    float cutoff = stof(split[6]);


    vector<array<float,3>> Coord_list_1;
    vector<array<float,3>> Coord_list_2;

    for(int i = 0; i < elements.size(); i++){
        if (elements[i] == central_e){
            Coord_list_1.push_back(coords[i]);
        }
        if(elements[i] == second_e){
            Coord_list_2.push_back(coords[i]);
        }
    }


    for(int i = 0; i < Coord_list_1.size(); i++){
        for (int j = 0; j < Coord_list_2.size(); j++){
            if ((central_e == second_e && i !=j ) || central_e != second_e){
                array<float,3> c1 = Coord_list_1[i];
                array<float,3> c2 = Coord_list_2[j];

                float rxyz = distance_between_2(c1,c2);
                float frc = fc(cutoff,rxyz);
                g2 += exp(-eta* pow(rxyz - rs,2))*frc;
            }
        }
    }
    return g2;
}


float calculate_g3(vector<string> split, vector<string> elements, vector<array<float,3>> coords){
    float g3 = 0;
    string central_e = split[1];
    string second_e = split[3];
    string thrird_e = split[4];
    float eta = stof(split[5]);
    float lam = stof(split[6]);
    float zeta = stof(split[7]);
    float rc = stof(split[8]);
    float rs = 0.0;
    if (split.size() > 9){
        rs = stof(split[9]);
    }


    vector<array<float,3>> Coord_list_1;
    vector<array<float,3>> Coord_list_2;
    vector<array<float,3>> Coord_list_3;

    for(int i = 0; i < elements.size(); i++){
        if (elements[i] == central_e){
            Coord_list_1.push_back(coords[i]);
        }
        if(elements[i] == second_e){
            Coord_list_2.push_back(coords[i]);
        }
        if(elements[i] == thrird_e){
            Coord_list_3.push_back(coords[i]);
        }
    }



    for(int i =0; i < Coord_list_1.size(); i++){
        for(int j = 0; j < Coord_list_2.size(); j++){
            if((central_e == second_e && i != j) || central_e != second_e){
                //ensure no repeated calculations
                int k_start = 0;
                if(second_e == thrird_e){k_start = j;}
                for(int k = k_start; k < Coord_list_3.size(); k ++){

                    //if third == central or second, then only pass when index is different.
                    //if different allow through on any index
                    if((second_e == thrird_e && k != j) || second_e != thrird_e ){
                        if((central_e == thrird_e && k != i) || central_e != thrird_e){

                            array<float,3> c1 = Coord_list_1[i];
                            array<float,3> c2 = Coord_list_2[j];
                            array<float,3> c3 = Coord_list_3[k];
                            float r_12 = distance_between_2(c1,c2);
                            float r_23 = distance_between_2(c2,c3);
                            float r_13 = distance_between_2(c1,c3);

                            float cos_theta = get_angle_between_three(c1,c2,c3);

                            g3 += pow(1 + lam*cos(cos_theta),zeta) * exp(-eta*(pow(r_12 - rs,2) + pow(r_13-rs,2) + pow(r_23-rs,2)))*fc(rc,r_12)*fc(rc,r_13)*fc(rc,r_23);
                        }
                    }
                }
            }
        }
    }
    return pow(2,1-zeta)*g3;
}

float calculate_g9(vector<string> split, vector<string> elements, vector<array<float,3>> coords){
    float g9 = 0;
    string central_e = split[1];
    string second_e = split[3];
    string thrird_e = split[4];
    float eta = stof(split[5]);
    float lam = stof(split[6]);
    float zeta = stof(split[7]);
    float rc = stof(split[8]);
    float rs = 0.0;
    if (split.size() > 9){
        rs = stof(split[9]);
    }


    vector<array<float,3>> Coord_list_1;
    vector<array<float,3>> Coord_list_2;
    vector<array<float,3>> Coord_list_3;

    for(int i = 0; i < elements.size(); i++){
        if (elements[i] == central_e){
            Coord_list_1.push_back(coords[i]);
        }
        if(elements[i] == second_e){
            Coord_list_2.push_back(coords[i]);
        }
        if(elements[i] == thrird_e){
            Coord_list_3.push_back(coords[i]);
        }
    }



    for(int i =0; i < Coord_list_1.size(); i++){
        for(int j = 0; j < Coord_list_2.size(); j++){
            if((central_e == second_e && i != j) || central_e != second_e){
                //ensure no repeated calculations
                int k_start = 0;
                if(second_e == thrird_e){k_start = j;}
                for(int k = k_start; k < Coord_list_3.size(); k ++){

                    //if third == central or second, then only pass when index is different.
                    //if different allow through on any index
                    if((second_e == thrird_e && k != j) || second_e != thrird_e ){
                        if((central_e == thrird_e && k != i) || central_e != thrird_e){

                            array<float,3> c1 = Coord_list_1[i];
                            array<float,3> c2 = Coord_list_2[j];
                            array<float,3> c3 = Coord_list_3[k];
                            float r_12 = distance_between_2(c1,c2);
                            float r_23 = distance_between_2(c2,c3);
                            float r_13 = distance_between_2(c1,c3);

                            float cos_theta = get_angle_between_three(c1,c2,c3);

                            g9 += pow(1 + lam*cos(cos_theta),zeta) * exp(-eta*(pow(r_12 - rs,2) + pow(r_13-rs,2)))*fc(rc,r_12)*fc(rc,r_13);
                        }
                    }
                }
            }
        }
    }
    return pow(2,1-zeta)*g9;
}


tuple<string, vector<float>> calculate_sf(string molecule_file, vector<vector<string>> symmetry_functions){

    string base_filename = molecule_file.substr(molecule_file.find_last_of("/\\") + 1);
    string::size_type const p(base_filename.find_last_of('.'));
    string molname = base_filename.substr(0,p);
    
    cout << "Starting: " << molname << endl;
    string func;
    string xyz;

    ifstream moleculeFile(molecule_file);

    vector<string> elements;
    vector<array<float,3>> coords;

    while(getline(moleculeFile,xyz)){
        vector<string> split = splitter(xyz, ' ');
        if (split.size() == 4){
            if (split[0] == "Dy" || split[0] == "Gd" || split[0] == "Lu" || split[0] == "Pm" || split[0] == "Tm" || split[0] == "Tb"){
                elements.push_back("Ln");
            }
            else{
                elements.push_back(split[0]);
            }
            array<float,3> coordarray = {stof(split[1]), stof(split[2]), stof(split[3])};
            coords.push_back(coordarray);
        }
    }

    vector<float> funcvals;
    for (vector<string> split : symmetry_functions)
    {
        if (split[2] == "2"){
            float g2 = calculate_g2(split,elements,coords);
            funcvals.push_back(g2);  
        }

        if (split[2] == "3"){
            float g3 = calculate_g3(split,elements,coords);
            funcvals.push_back(g3);  
        }
        if (split[2] == "9"){
            float g9 = calculate_g9(split,elements,coords);
            funcvals.push_back(g9);  
        }
    }
    moleculeFile.close();
    cout << "Finished: " << molname << endl;   
    return {molname, funcvals};
}

int main()
{  
    vector<string> geometries;

    DIR *dir;
    struct dirent *ent;
    
    const char* xyzdir = "/users/40265864/sharedscratch/MSc_ML_MM/ln_replacements/xyz/";
    string base = xyzdir; 

    dir = opendir(xyzdir);

    if (dir == nullptr) {
        std::cerr << "Error opening directory\n";
        return 1;
    }
    
    while((ent = readdir(dir)) != nullptr){
        string newfile = base + ent->d_name + "/" + ent->d_name + "_MLTP_MAX.xyz";
        ifstream xyzfile;
        xyzfile.open(newfile);
        if(xyzfile){
	    geometries.push_back(newfile);
        xyzfile.close();           
        }
    }
    

    string sf_file = "sfnew.txt";
    vector<vector<string>> symfunctions;
    string func;
    ifstream funcfile(sf_file);
    while(getline (funcfile,func)){
        vector<string> split = splitter(func,' ');
        symfunctions.push_back(split);
    }
 

    string csvfile = "mltp_max.csv";


    int threads = omp_get_max_threads();
    cout << threads << endl;
    
    #pragma omp parallel for shared(geometries) schedule(dynamic) num_threads(threads)
    for(int i = 0; i < geometries.size(); i++)
    { 
        tuple<string,vector<float>> results = calculate_sf(geometries[i], symfunctions);
        #pragma omp critical
       // string name = get<0>(results);
       // vector<float> values = get<1>(results);
        write_csv(csvfile,get<1>(results),get<0>(results));

    }    
}



