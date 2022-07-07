//+------------------------------------------------------------------+
//|                                        83-LastTradeDirection.mq4 |
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
   if(OrdersTotal()==0)
     {
      Buy(0.01,200,100);
      Sell(0.01,200,100); 
     }
   Comment("Last Position ",GetLastP());
  }
//+------------------------------------------------------------------+
string GetLastP()
{
   int counter=0;
   double LastProfit=0;
   string LastOrderType="";
   string Result="";
   
   for(int i=OrdersHistoryTotal()-1;i>=0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(i==OrdersHistoryTotal()-1)
        {
         LastProfit=(OrderProfit()+OrderSwap()+OrderCommission());
         if(OrderType()==OP_BUY)LastOrderType="Buy-Order";
         if(OrderType()==OP_SELL)LastOrderType="Sell-Order";         
                      
         
        }
      Result= LastOrderType+" Profit: "+LastProfit;  
     }

   
   return Result;
}

