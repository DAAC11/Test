//+------------------------------------------------------------------+
//|                                                      Objects.mq4 |
//|                                                            David |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "David"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ObjCreateLine(double precio, string name, color clr)
  {
   ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_HLINE, 0, 0, precio);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ObjCreateGrids(double GridCentral, double &GridLevels[], string &ObjetosCerados[])
  {
   ArrayResize(ObjetosCerados, ArraySize(GridLevels));
   for(int i = 0; i <= ArraySize(GridLevels) - 1 ; i++)
     {
      if(GridLevels[i] == GridCentral)
        {
         ObjCreateLine(GridLevels[i], "Line " + i, clrAqua);
         ObjetosCerados[i] = "Line " + (i);
        }
      if(GridLevels[i] > GridCentral)
        {
         ObjCreateLine(GridLevels[i], "Line " + i, clrGreen);
         ObjetosCerados[i] = "Line " + (i);
        }
      if(GridLevels[i] < GridCentral)
        {
         ObjCreateLine(GridLevels[i], "Line " + i, clrRed);
         ObjetosCerados[i] = "Line " + (i);
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ObjDelete(string &Objetos[])
  {
   for(int i = 0; i <= ArraySize(Objetos) - 1; i++)
     {
      ObjectDelete(Objetos[i]);
     }
  }
//+------------------------------------------------------------------+
