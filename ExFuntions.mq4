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
      salida += Array[i] + ",";
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
      salida += Array[i] + ",";
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
      salida += Array[i] + ",";
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
