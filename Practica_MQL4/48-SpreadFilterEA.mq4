//+------------------------------------------------------------------+
//|                                            48-SpreadFilterEA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input int SpreadMax = 15;
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
    string signal = "";
    
    MqlRates PriceArray[];
    
    ArraySetAsSeries(PriceArray,true);
    
    int datos = CopyRates(Symbol(),Period(),0,3,PriceArray);
    
    int SpreadActual= SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
    
    string SpreadFilter = "";
    
    
    if(SpreadActual>=SpreadMax)
      {
       SpreadFilter="Trading no permitido por el filtro de Spread";
      }
      
    if(SpreadActual<=SpreadMax)
      {
       SpreadFilter="Trading permitido por el filtro de Spread";
      }   
    
    if(PriceArray[1].close>PriceArray[2].close)
      {
       signal="buy";
      }
      
    if(PriceArray[1].close<PriceArray[2].close)
      {
       signal="sell";
      }
      
    if(SpreadFilter=="Trading permitido por el filtro de Spread")
      {
        if(signal == "buy"&& OrdersTotal()==0)
           {
            Buy(0.05,200,100);
           }
   
        if(signal == "sell"&& OrdersTotal()==0)
           {
            Sell(0.05,200,100);
           } 
      }
    Comment(SpreadFilter,"\n la señal es = ",signal,"\n Spread maximo = ",SpreadMax);
  }
//+------------------------------------------------------------------+
