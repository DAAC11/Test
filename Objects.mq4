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
void ObjCreateLine(double precio, string name,color clr)
  {

   ObjectDelete(0,name);
   ObjectCreate(0,name,OBJ_HLINE,0,0,precio);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool ObjCreateGrids(double PrecioInicial, int Grids,int Puntos,double &GridAlcista[],double &GridBajista[], string &ObjetosCerados[]){
      //Arrays Grids
      ArrayResize(GridAlcista,(Grids/2)+1);
      ArrayResize(GridBajista,(Grids/2)+1);
      ArrayResize(ObjetosCerados,Grids+2);
      int ObjetsI=0;
      
      //rellenar array alciasta
      double AccA= PrecioInicial;
      for(int i=ArraySize(GridAlcista)-1; i>0; i--)
        {
         GridAlcista[i]=PrecioInicial+(Puntos*(i*Point));
        }
      //rellenar array bajista
      double AccB= PrecioInicial;
      for(int i=ArraySize(GridBajista)-1; i>0; i--)
        {
         GridBajista[i]=PrecioInicial-(Puntos*(i*Point));
        }
      //dibujar Grids alciastas
      for(int i= ArraySize(GridAlcista)-1; i>0; i--)
        {
         ObjCreateLine(GridAlcista[i],"line"+i+"A",clrRed);
         ObjetosCerados[ObjetsI]="line"+i+"A";
         ObjetsI++;

        }
      //dibujar Grids Bajistas
      for(int i= ArraySize(GridBajista)-1; i>0; i--)
        {
         ObjCreateLine(GridBajista[i],"line"+i+"B",clrGreen);
         ObjetosCerados[ObjetsI]="line"+i+"B";
         ObjetsI++;

        }
   return True;
}

/*void ObjCreateGrids(double PrecioInicial, int Grids, int Puntos,string &Objetos[], double &Precios[])
  {

   for(int i=Grids-1; i>0; i--)
     {
      if(i<Grids/2)//Toma solo los Grids Inferiores
        {
         if(PrecioInicial<PrecioInicial+(((i*Puntos)*Point)*-1))
           {
            ObjCreateLine(PrecioInicial+(((i*Puntos)*Point)*-1),"Grid Inf"+i,clrRed);
            //Redimencionar Arrays
            ArrayResize(Objetos,ArraySize(Objetos)+1);
            ArrayResize(Precios,ArraySize(Precios)+1);
            
            Objetos[i] ="Grid Inf"+i;
            Precios[i] =PrecioInicial+(((i*Puntos)*Point)*-1);
           }
        }
      if(i>=Grids/2)//Toma solo los Grids Superiores
        {
         if(PrecioInicial > PrecioInicial + ((i*Puntos)*Point))
           {
            ObjCreateLine(PrecioInicial+((i*Puntos)*Point),"Grid Inf"+i,clrRed);
            //Redimencionar Arrays
            ArrayResize(Objetos,ArraySize(Objetos)+1);
            ArrayResize(Precios,ArraySize(Precios)+1);
            //Alimentar Arrays
            Objetos[i] ="Grid Inf"+i;
            Precios[i] =PrecioInicial+(((i*Puntos)*Point)*-1);
            
           }
        }
     }
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
