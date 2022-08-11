//+------------------------------------------------------------------+
//|                                             50-TimerFilterEA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input string  HoraInicial = "01:00";
input string  HoraFinal = "10:00";
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
string tiempoActual;

bool tradingPermitido =false;

void OnTick()
  {
   datetime hora = TimeLocal();// tiempo del pc
   
   tiempoActual = TimeToString(hora,TIME_MINUTES);
   
   if(PermisoHorario()==true)
     {
      if(OrdersTotal()==0)
        {
         Buy(0.1,200,100);
        }
     }
   Comment("Trading permirido: ", tradingPermitido,"\n",
           "Hora: ", tiempoActual,"\n",
           "Hora inicio: ", HoraInicial,"\n",
           "Hora Final: ", HoraFinal,"\n",
           "FN perniso: ", PermisoHorario());
  }
//+------------------------------------------------------------------+
bool PermisoHorario(){
   
   if(StringSubstr(tiempoActual,0,5)==HoraInicial)
     {
      tradingPermitido=true;
     }
     
   if(StringSubstr(tiempoActual,0,5)==HoraFinal)
     {
      tradingPermitido=false;
     }
   
   return tradingPermitido;
}