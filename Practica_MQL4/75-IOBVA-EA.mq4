//+------------------------------------------------------------------+
//|                                                  75-IOBVA-EA.mq4 |
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
//---
   string signal = "";
   
   double IOBVArray[100];
   
   for(int i=99;i>=0;i--)
     {
      double CounterIOBValue=iOBV(Symbol(),Period(),PRICE_CLOSE,i);
      IOBVArray[i]=CounterIOBValue;
     }
     
   double IOBVValue = iOBV(Symbol(),Period(),PRICE_CLOSE,0);
   
   int maxIOVBV = ArrayMaximum(IOBVArray,WHOLE_ARRAY,0);
   int minIOVBV = ArrayMinimum(IOBVArray,WHOLE_ARRAY,0);
   
   int maxIOVBVValue = IOBVArray[maxIOVBV];
   int minIOVBVValue = IOBVArray[minIOVBV];
     
   if(IOBVValue>=maxIOVBVValue)
     {
      signal = "buy";
     }  
   
   if(IOBVValue<=maxIOVBVValue)
     {
      signal = "sell";
     } 
   if(signal=="buy"&& OrdersTotal()==0)
     {
      Buy(0.01,200,100);
     }
   if(signal=="sell"&& OrdersTotal()==0)
     {
      Sell(0.01,200,100);
     } 
     
   Comment(
   "Current IOVB ",IOBVValue,"\n",
   "Max IOVB ",maxIOVBVValue,"\n",
   "Min IOVB ",minIOVBVValue,"\n",
   "Current signal ",signal); 
  }
//+------------------------------------------------------------------+
