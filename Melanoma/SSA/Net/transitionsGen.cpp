static double Flag = -1; 
static double alpha3;
static double alpha4;
static double alpha2;
static double alpha7;
static double k1;
static double k2;
static double k3;

void read_constant(string fname, double& Infection_rate)
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
        Infection_rate = stod(line);
        //cout << "p" << i << ": " << line << "\t" << p1 << endl;
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
  read_constant("./alpha3", alpha3);
  read_constant("./alpha4", alpha4);
  read_constant("./alpha2", alpha2);
  read_constant("./alpha7", alpha7);
  read_constant("./k1", k1);
  read_constant("./k2", k2);
  read_constant("./k3", k3);
  Flag = 1; 
  
}

double Ckill_function(double *Value,
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
  

  double As = Value[NumPlaces.find("As") -> second ];
  double Es = Value[NumPlaces.find("Es") -> second ];
  double C = Value[NumPlaces.find("C") -> second ];
  
  double rate =  Es * C* (alpha3) *  ((As + k2)/(As + k3)) * (1 - alpha4);
    
  return(rate);
}

double Ckill2_function(double *Value,
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
  
  
  double As = Value[NumPlaces.find("As") -> second ];
  double Es = Value[NumPlaces.find("Es") -> second ];
  double C = Value[NumPlaces.find("C") -> second ];
  
  double rate =  Es * C* (alpha3) *  ((As + k2)/(As + k3)) * (alpha4);
  
  return(rate);
}

double Cdeath_function(double *Value,
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
  
  double C = Value[NumPlaces.find("C") -> second ];
  
  double rate =  alpha2 * C;
  
  if( C == 0)
    rate =  0;
  else 
    rate = log(C) * rate;
  
  return(rate);
}

double ESdup_function(double *Value,
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
  
  double As = Value[NumPlaces.find("As") -> second ];
  double Es = Value[NumPlaces.find("Es") -> second ];

  double rate =  (Es * (alpha7) * (As /(As + k1)) );
  
  return(rate);
}






