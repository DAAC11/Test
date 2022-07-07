//+------------------------------------------------------------------+
//|                                                65-CSVWritter.mq4 |
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
   static double LastHigh;
   
   static double LastLow;
   
   if((LastHigh!=High[1])&&(LastLow!=Low[1]))
     {
      string archivo= "datos.csv";
      
      int abrirArchivo = FileOpen(archivo,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
      
      FileSeek(archivo,0,SEEK_END);
      
      FileWrite(archivo,"Hora ",Time[1],"High ",High[1],"Low ",Low[1]);
      
      FileClose(archivo);
      
      LastHigh = High[1];
      LastLow = Low[1];
      
     }
   Comment("Last High ", High[1],"\n",
              "Last Low ", Low[1],"\n");
  }
//+------------------------------------------------------------------+
