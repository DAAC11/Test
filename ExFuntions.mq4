//+------------------------------------------------------------------+
//|                                                   Constantes.mq4 |
//|                                                            David |
//|                                                                  |
//+------------------------------------------------------------------+
#property library
#property copyright "David"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
// int MyCalculator(int value,int value2) export
//   {
//    return(value+value2);
//   }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddArray(int &Array[], int Value)
  {
   int Size = ArraySize(Array);
   ArrayResize(Array, Size + 1);
   Array[ArraySize(Array) - 1] = Value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddArray(double &Array[], double Value)
  {
   int Size = ArraySize(Array);
   ArrayResize(Array, Size + 1);
   Array[ArraySize(Array) - 1] = Value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PrintArray(int &Array[])
  {
   string salida = "[";
   for(int i = 0 ; i <= ArraySize(Array) - 1; i++)
     {
      if(i == ArraySize(Array) - 1)
        {
         salida += Array[i] ;
        }
      else
        {
         salida += Array[i] + ",";
        }
     }
   salida += "]";
   return salida;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PrintArray(double &Array[])
  {
   string salida = "[";
   for(int i = 0 ; i <= ArraySize(Array) - 1; i++)
     {
      if(i == ArraySize(Array) - 1)
        {
         salida += Array[i] ;
        }
      else
        {
         salida += Array[i] + ",";
        }
     }
   salida += "]";
   return salida;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PrintArray(string &Array[])
  {
   string salida = "[";
   for(int i = 0 ; i <= ArraySize(Array) - 1; i++)
     {
      if(i == ArraySize(Array) - 1)
        {
         salida += Array[i] ;
        }
      else
        {
         salida += Array[i] + ",";
        }
     }
   salida += "]";
   return salida;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SumaArray(double &Array[])
  {
   double acc = 0;
   for(int i = ArraySize(Array) - 1; i > 0; i--)
     {
      acc += Array[i];
     }
   return acc;
  }
//+------------------------------------------------------------------+
/*string OpenOrders(){

   string Ordenes ="[";
   for(int i=OrdersTotal()-1;i>0;i--)
     {
      Ordenes += OrderTicket()+ "\n";
     }
   Ordenes += "]";
   return Ordenes;
}*/
string OpenOrders() //Funcionando
  {
   string Abiertas = "[";
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         Abiertas += OrderTicket() + ",";
        }
     }
   Abiertas += "]";
   return Abiertas;
  }
//+------------------------------------------------------------------+
bool ArrayGrids(int Grids, int Puntos, double GridCentral, double &ArrayGridsLevels[])
  {
//Crear Arrayas Alcista y bajista
   double ArrayA[];
   double ArrayB[];
   ArrayResize(ArrayA,Grids);
   ArrayResize(ArrayB,Grids);
   //Llenar arrays
   for(int i=0;i<=ArraySize(ArrayA)-1;i++)
     {
      ArrayA[i]=GridCentral+((i+1)*Puntos*Point);
     }
   for(int i=0;i<=ArraySize(ArrayB)-1;i++)
     {
      ArrayB[i]=GridCentral-((i+1)*Puntos*Point);
     }
   ArrayResize(ArrayGridsLevels,(ArraySize(ArrayA)+ArraySize(ArrayB)+1));
   ArrayCopy(ArrayGridsLevels,ArrayA,0,0);
   ArrayCopy(ArrayGridsLevels,ArrayB,ArraySize(ArrayA),0);
   ArrayGridsLevels[ArraySize(ArrayGridsLevels)-1]=GridCentral;
   ArraySort(ArrayGridsLevels,WHOLE_ARRAY,0,MODE_ASCEND);
   return true;
  }
//+------------------------------------------------------------------+
int GridPos(double &ArrayGridsLevels[],double Price){
   int Pos = -1;
   for(int i=0;i<=ArraySize(ArrayGridsLevels)-1;i++)
     {
      if(Price < ArrayGridsLevels[0])
        {
         return Pos=-5;
        }
      else if(Price > ArrayGridsLevels[ArraySize(ArrayGridsLevels)-1])
             {
              return Pos=1000;
             }
      else if(Price > ArrayGridsLevels[i] )
             {
              Pos=i;
             }
     }
   return Pos;
   
}
