//+------------------------------------------------------------------+
//|                                        51-AccountInformation.mq4 |
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
   string AccountServer = AccountInfoString(ACCOUNT_SERVER);
   string AccountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
   string AccountName = AccountInfoString(ACCOUNT_NAME);
   int AccountTradeMode = AccountInfoInteger(ACCOUNT_TRADE_MODE);
   
   string TradeMode ="";
   if(AccountTradeMode ==0)
     {
      TradeMode= "DEMO ACCOUNT";
     }
     
   if(AccountTradeMode ==1)
     {
      TradeMode= "CONTEST ACCOUNT";
     }
     
   if(AccountTradeMode ==2)
     {
      TradeMode= "REAL ACCOUNT";
     }
   
   string AccountLogin = AccountInfoInteger(ACCOUNT_LOGIN);
   string AccountCompany = AccountInfoString(ACCOUNT_COMPANY);
   string AccountLeverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
   string AccountLimitOrder = AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   double AccountFreeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   bool AccountTradeAllowed = AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);
   bool AccountTradeExpert = AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
   
   Comment(  "AccountServer = ",AccountServer,"\n",
             "AccountCurrency = ",AccountCurrency,"\n",
             "AccountName = ",AccountName,"\n",
             "AccountTradeMode = ", TradeMode,"\n",
             "AccountLogin = ",AccountLogin,"\n",
             "AccountCompany  = ",AccountCompany,"\n",
             "AccountLeverage  = ",AccountLeverage,"\n",
             "AccountLimitOrder = ",AccountLimitOrder,"\n",
             "AccountFreeMargin  = ",AccountFreeMargin,"\n",
             "AccountTradeAllowed  = ",AccountTradeAllowed,"\n",
             "AccountTradeExpert  = ",AccountTradeExpert);
  }
//+------------------------------------------------------------------+
