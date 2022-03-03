// Based on original Fisher_Yurchik.mq4, Copyright © 2005, Yura Prokofiev, Yura.prokofiev@gmail.com
//+------------------------------------------------------------------+
//|                                                       Fisher.mq4 |
//|                                 Copyright © 2009-2022, EarnForex |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009-2022, EarnForex"
#property link      "https://www.earnforex.com/metatrader-indicators/Fisher/"
#property version   "1.04"
#property strict

#property description "A repainting indicator that shows trend strength and direction in hindsight."

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots 2
#property indicator_color1 clrLime
#property indicator_width1 2
#property indicator_label1 "Positive"
#property indicator_color2 clrRed
#property indicator_width2 2
#property indicator_label2 "Negative"
#property indicator_color3 clrNONE

input int Period = 10;

double Positive[], Negative[], Calculations[];

void OnInit()
{
    SetIndexStyle(0, DRAW_HISTOGRAM);
    SetIndexStyle(1, DRAW_HISTOGRAM);
    SetIndexStyle(2, DRAW_NONE);
    
    IndicatorDigits(Digits + 1);

    SetIndexBuffer(0, Positive);
    SetIndexBuffer(1, Negative);
    SetIndexBuffer(2, Calculations);

    IndicatorShortName("Fisher");
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time_timeseries[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[]
               )
{
    double Value1 = 0, Fish1 = 0;

    int counted_bars = IndicatorCounted();
    if (counted_bars > 0) counted_bars--;
    int limit = Bars - counted_bars;

    for (int i = 0; i < limit; i++)
    {
        double MaxH = High[iHighest(NULL, 0, MODE_HIGH, Period, i)];
        double MinL = Low[iLowest(NULL, 0, MODE_LOW, Period, i)];
        double price = (High[i] + Low[i]) / 2;
        double Value = 0.33 * 2 * ((price - MinL) / (MaxH - MinL) - 0.5) + 0.67 * Value1;
        Value = MathMin(MathMax(Value, -0.999), 0.999);
        double Calculation = 0.5 * MathLog((1 + Value) / (1 - Value)) + 0.5 * Fish1;
        if (Calculation < 0)
        {
            Negative[i] = Calculation;
            Positive[i] = 0;
        }
        else
        {
            Positive[i] = Calculation;
            Negative[i] = 0;
        }
        Value1 = Value;
        Fish1 = Calculation;
    }

    return rates_total;
}
//+------------------------------------------------------------------+