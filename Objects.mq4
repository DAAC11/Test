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
bool ObjCreateGrids(double GridCentral,double &GridLevels[], string &ObjetosCerados[])
  {
   ArrayResize(ObjetosCerados, ArraySize(GridLevels));

   for(int i = 0; i <= ArraySize(GridLevels)-1 ; i++)
     {
      if(GridLevels[i] == GridCentral)
        {
         ObjCreateLine(GridLevels[i], "Line " + i, clrAqua);
         ObjetosCerados[i] = "Line " + (i + 1);
        }
      if(GridLevels[i] > GridCentral)
        {
         ObjCreateLine(GridLevels[i], "Line " + i, clrGreen);
         ObjetosCerados[i] = "Line " + (i + 1);
        }
      if(GridLevels[i] < GridCentral)
        {
         ObjCreateLine(GridLevels[i], "Line " + i, clrRed);
         ObjetosCerados[i] = "Line " + (i + 1);
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*bool ObjCreateGrids(double PrecioInicial, int Grids, int Puntos, double &GridAlcista[], double &GridBajista[], string &ObjetosCerados[])
  {
//Arrays Grids
   ArrayResize(GridAlcista, (Grids / 2) + 1);
   ArrayResize(GridBajista, (Grids / 2));
   ArrayResize(ObjetosCerados, Grids + 1);
   int ObjetsI = 0;
//rellenar array alciasta
   double AccA = PrecioInicial;
   for(int i = ArraySize(GridAlcista) - 1; i > 0; i--)
     {
      GridAlcista[i] = PrecioInicial + (Puntos * (i * Point));
     }
//rellenar array bajista
   double AccB = PrecioInicial;
   for(int i = ArraySize(GridBajista) - 1; i > 0; i--)
     {
      GridBajista[i] = PrecioInicial - (Puntos * (i * Point));
     }
//dibujar Grids alciastas
   for(int i = ArraySize(GridAlcista) - 1; i > 0; i--)
     {
      ObjCreateLine(GridAlcista[i], "line" + i + "A", clrGreen);
      ObjetosCerados[ObjetsI] = "line" + i + "A";
      ObjetsI++;
     }
//dibujar Grids Bajistas
   for(int i = ArraySize(GridBajista) - 1; i > 0; i--)
     {
      ObjCreateLine(GridBajista[i], "line" + i + "B", clrRed);
      ObjetosCerados[ObjetsI] = "line" + i + "B";
      ObjetsI++;
     }
   return True;
  }*/




/*void ObjCreateText (double precio, string name,color clr){

    ObjectDelete(0,name);
    ObjectCreate(0,name,OBJ_LABEL,0,0,precio);
    ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
    ObjectSetString(0,name,OBJPROP_TEXT,name);
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
    ObjectSetInteger(0,name,OBJPROP_ANCHOR,10);

}*/
//+------------------------------------------------------------------+
