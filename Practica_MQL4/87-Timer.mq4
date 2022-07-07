//+------------------------------------------------------------------+
//|                                                     87-Timer.mq4 |
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
datetime CurrentTime;
datetime StartTime;
datetime PassedTimeInSeconds;
string TimeWithSeconds;
string StartTimeWithSeconds;
void OnTick()
  {
   if(StartTime==0)
     {
      StartTime=TimeLocal();
      StartTimeWithSeconds=TimeToStr(StartTime,TIME_DATE|TIME_SECONDS);
      
     }
   CurrentTime = TimeLocal();
   PassedTimeInSeconds = CurrentTime-StartTime;
   int time = PassedTimeInSeconds;
   TimeWithSeconds = TimeToStr(CurrentTime,TIME_DATE|TIME_SECONDS);
   
   Comment("Tiempo inicio Seg= ",StartTimeWithSeconds,"\n",
           "Tiempo  Seg= ",TimeWithSeconds,"\n",
           "Start Time= ",StartTime,"\n",
           "Current Time= ",CurrentTime,"\n"
           "Passed time in seconds= ",time,"\n",
           "Passed time in minutes= ",time/60,"\n",
           "Passed time in hours= ",time/3600,"\n");
  }
//+------------------------------------------------------------------+
