//+------------------------------------------------------------------+
//|                                                   38-BarChek.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   string newBar = "";
   newBar = RevisaBarraNueva();
   
   Comment("Barras en el grafico: ",Bars,"\n",
            "Aparecio una nueva barra: ",newBar);
  }
//+------------------------------------------------------------------+
string RevisaBarraNueva(){
   //static que vive en la funcion y cuando se vuelve a llamr se retoma
   static int acumuladoAnterior;
   string newBar= "no hay una barra nueva";
   
   if(Bars>acumuladoAnterior)
     {
      newBar = "Si una nueva barra aparecio";
     }
    
    acumuladoAnterior = Bars;
   
   return newBar;
}