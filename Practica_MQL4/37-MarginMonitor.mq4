//+------------------------------------------------------------------+
//|                                             37-MarginMonitor.mq4 |
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

   double Account_Margin = AccountInfoDouble(ACCOUNT_MARGIN);
   double Account_FreeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   double Initial_Margin = AccountInfoDouble(ACCOUNT_MARGIN_INITIAL);
   double Account_MarginLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   double Account_MarginMainte = AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);
   double Account_Stopoutcall = AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
   double Account_FinalStopoutcall = AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
   double Account_Profit = AccountInfoDouble(ACCOUNT_PROFIT);
   
   int Margin_mode = AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
   
   string Accotn_margin_stop="";
   
   if(Margin_mode==0)
     {
      Accotn_margin_stop="Mode %";
     }
   if(Margin_mode==1)
     {
      Accotn_margin_stop="Mode $";
     }  
   Comment(  "Account_Margin ", Account_Margin ,"\n",
             "Account_FreeMargin " ,Account_FreeMargin,"\n",
             "Initial_Margin ",Initial_Margin,"\n",
             "Account_MarginLevel " ,Account_MarginLevel,"\n",
             "Account_MarginMainte ",Account_MarginMainte,"\n",
             "Account_Stopoutcall ",Account_Stopoutcall,"\n",
             "Account_FinalStopoutcall ",Account_FinalStopoutcall,"\n",
             "Account_Profit ",Account_Profit,"\n",
             "Accotn_margin_stop ",Accotn_margin_stop,"\n"
             );
    
   
  }
//+------------------------------------------------------------------+
