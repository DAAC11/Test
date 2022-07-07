//+------------------------------------------------------------------+
//|                                                73-ichimokuEA.mq4 |
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
//---
   double ichimokuTen = iIchimoku(NULL,Period(),9,26,52,MODE_TENKANSEN,0);
   double ichimokuKi = iIchimoku(NULL,Period(),9,26,52,MODE_KIJUNSEN,0);
   double ichimokuAvalue = iIchimoku(NULL,Period(),9,26,52,MODE_SENKOUSPANA,-26);
   double ichimokuBvalue = iIchimoku(NULL,Period(),9,26,52,MODE_SENKOUSPANB,-26);
   double ichimokuChin= iIchimoku(NULL,Period(),9,26,52,MODE_CHIKOUSPAN,26);
   
   Comment("ichimokuTen " ,ichimokuTen, "\n",
   "ichimokuKi ", ichimokuKi , "\n",
   "ichimokuAvalue ", ichimokuAvalue, "\n",
   "ichimokuBvalue ", ichimokuBvalue, "\n",
   "ichimokuChin ",ichimokuChin);
  }
//+------------------------------------------------------------------+
