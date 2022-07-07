//+------------------------------------------------------------------+
//|                                                 60-Alligator.mq4 |
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
   double AlligatorJaw=iAlligator(Symbol(),Period(),13,0,8,0,5,0,MODE_SMA,PRICE_CLOSE,MODE_GATORJAW,0);
   double AlligatorTheet=iAlligator(Symbol(),Period(),13,0,8,0,5,0,MODE_SMA,PRICE_CLOSE,MODE_GATORTEETH,0);
   double AlligatorLips=iAlligator(Symbol(),Period(),13,0,8,0,5,0,MODE_SMA,PRICE_CLOSE,MODE_GATORLIPS,0);
   
   Comment("Alligator jaw",AlligatorJaw,"\n",
           "Alligator Theet",AlligatorTheet,"\n"
           "Alligator Lips",AlligatorLips,"\n");
  }
//+------------------------------------------------------------------+
