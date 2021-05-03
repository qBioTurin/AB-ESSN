
static double Flag = -1; 
static double BirthS_rate = 0.0;
static double BirthW_rate = 0.0;

class TransPL {
  
  vector<vector<int>> v;
  
public:
  
  void insert(vector<int>& indPlacesEnv, const int T ){
    vector<int>& vat = v.at(T);
    if(vat.size()==0)
    {
      vat.assign( indPlacesEnv.begin(), indPlacesEnv.end() );
    }
  }
  
  vector<int>& capture(const int T){
    return( v.at(T) );
  }
  
  void initialize(map <string,int>& NumTrans){
    if(v.size() == 0){
      v.resize(NumTrans.size());
    }
  }
  
  vector<int>& at(int T){
    return v.at(T) ;
  }
};

static TransPL trans_InputPlaces_Env;

void read_constant(string fname, double& rate)
{
	ifstream f (fname);
	string line;
	if(f.is_open())
	{
		int i = 1;
		while (getline(f,line))
		{
			switch(i)
			{
				case 1:
				  rate = stod(line);
					cout << fname << ": " << line << "\t" << rate << endl;
					break;
			}
			++i;
		}
		f.close();
    }
	else
	{
		std::cerr<<"\nUnable to open " << fname << ": file do not exists\": file do not exists\n";
		exit(EXIT_FAILURE);
	}
}

void init_data_structures()
{
	read_constant("./BirthS", BirthS_rate);
  read_constant("./BirthW", BirthW_rate);
    Flag = 1; 

}


// this function returns the indexes of the input places considering only Env
vector<int>& InputPlacesEnv(TransPL& trans_InputPlaces_Env,  map <string,int>& NumPlaces, const struct InfTr* Trans, const int T, map <string,int>& NumTrans )
{
  trans_InputPlaces_Env.initialize(NumTrans);
  
  
  if(trans_InputPlaces_Env.at(T).size()==0) // If it is the first time that T fires than the class is updated with the ordered input places
  {
    int size = Trans[T].InPlaces.size();
    
    vector<int> EnvPlaces (size,0);
    
    for (int k=0; k<size; k++)
    {
      for (auto it=NumPlaces.begin(); it != NumPlaces.end() ; ++it)
      {
        if( it-> second == Trans[T].InPlaces[k].Id )
        {
          string str = it-> first;
          string str2 ("Env");
          
          if (str.find(str2) != string::npos) {
            EnvPlaces.at(k) = it -> second;
          }
        }
      }
    }

    trans_InputPlaces_Env.insert(EnvPlaces, T);
  }
  
  return trans_InputPlaces_Env.capture(T);
}



double BirthS(double *Value,
                         map <string,int>& NumTrans,
                         map <string,int>& NumPlaces,
                         const vector<string> & NameTrans,
                         const struct InfTr* Trans,
                         const int T,
                         const double& time)
{

    // Definition of the function exploited to calculate the rate,
    // in this case for semplicity we define it throught the Mass Action  law
 
 	if( Flag == -1)   init_data_structures();
 
    double intensity = 1.0;
    
 // Prendo i posti solo relativi a Env e non Container!
  vector<int> idx;
  idx = InputPlacesEnv(trans_InputPlaces_Env, NumPlaces, Trans, T, NumTrans );
 
	for (unsigned int k=0; k< idx.size(); k++)
	{
	  intensity *= Value[idx[k]];
	}
	
	double rate = BirthS_rate * intensity;

    return(rate);
}

double BirthW(double *Value,
              map <string,int>& NumTrans,
              map <string,int>& NumPlaces,
              const vector<string> & NameTrans,
              const struct InfTr* Trans,
              const int T,
              const double& time)
{
  
  // Definition of the function exploited to calculate the rate,
  // in this case for semplicity we define it throught the Mass Action  law
  
  if( Flag == -1)   init_data_structures();
  
  double intensity = 1.0;
  
  // Prendo i posti solo relativi a Env e non Container!
  vector<int> idx;
  idx = InputPlacesEnv(trans_InputPlaces_Env, NumPlaces, Trans, T, NumTrans );
  
  for (unsigned int k=0; k< idx.size(); k++)
  {
    intensity *= Value[idx[k]];
  }
  
  double rate = BirthW_rate * intensity;
  
  return(rate);
}