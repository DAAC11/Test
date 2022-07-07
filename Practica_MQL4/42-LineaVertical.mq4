//+------------------------------------------------------------------+
//|                                             42-LineaVertical.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
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
   int velaMasAlta = iHighest(Symbol(),Period(),MODE_HIGH,100,0);
   
   if(velaMasAlta==0&& OrdersTotal()==0)
     {
      Sell(0.5,200,100);
      
      LineaHorizontal(velaMasAlta);
     }
   Comment("La vela mas alta de  las ultimas 100 \n",
           "es la numero: ",velaMasAlta,"\n",
           "El precio mas alto es: ", High[velaMasAlta]);
  }
//+------------------------------------------------------------------+
void LineaHorizontal( int velaMasAlta){
   
   ObjectDelete("HLine");
   
   ObjectCreate("HLine",OBJ_VLINE,0,Time[0],High[velaMasAlta]);

}