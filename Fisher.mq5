//+------------------------------------------------------------------+
//|                                                           Fisher |
//|                                Copyright © 20094-2022, EarnForex |
//|                                       https://www.earnforex.com/ |
//|                     Based on Fisher_Yur4ik.mq4 by Yura Prokofiev |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009-2022, EarnForex"
#property link      "https://www.earnforex.com/metatrader-indicators/Fisher/"
#property version   "1.04"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_color1  clrLime, clrRed
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//---- indicator parameters
input int Period = 10;

//---- indicator buffers
double ExtBuffer0[]; // This buffer is for drawing.
double ExtBuffer1[]; // This buffer is for color.

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
{
    IndicatorSetString(INDICATOR_SHORTNAME, "Fisher");
    IndicatorSetInteger(INDICATOR_DIGITS, _Digits + 1);

//---- indicator buffers mapping
    SetIndexBuffer(0, ExtBuffer0, INDICATOR_DATA);
    SetIndexBuffer(1, ExtBuffer1, INDICATOR_COLOR_INDEX);
}

//+------------------------------------------------------------------+
//| Data Calculation Function for Indicator                          |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &High[],
                const double &Low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    double Value1 = 0, Fish1 = 0;

    ArraySetAsSeries(High, true);
    ArraySetAsSeries(Low, true);

    if (prev_calculated == rates_total) return rates_total;
    int limit = rates_total;

    for (int i = 0; i < limit - Period; i++)
    {
        double MaxH = High[ArrayMaximum(High, i, Period)];
        double MinL = Low[ArrayMinimum(Low, i, Period)];
        double price = (High[i] + Low[i]) / 2;
        double Value = 0.33 * 2 * ((price - MinL) / (MaxH - MinL) - 0.5) + 0.67 * Value1;
        Value = MathMin(MathMax(Value, -0.999), 0.999);
        int indicator_index = rates_total - i - 1;
        ExtBuffer0[indicator_index] = 0.5 * MathLog((1 + Value) / (1 - Value)) + 0.5 * Fish1;
        if (ExtBuffer0[indicator_index] < 0) ExtBuffer1[indicator_index] = 1;
        else ExtBuffer1[indicator_index] = 0;
        Value1 = Value;
        Fish1 = ExtBuffer0[indicator_index];
    }

    return rates_total;
}
//+------------------------------------------------------------------+