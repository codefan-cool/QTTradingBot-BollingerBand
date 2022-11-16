
/*
 * Bollinger Bands consist of an N-period moving average (MA),
 * an upper band at K times an N-period standard deviation above the moving average (MA + Kσ),
 * and a lower band at K times an N-period standard deviation below the moving average (MA − Kσ).
 */


script BollingerBands; // a name of a file must be unique within all the files included to the main script

import Math;
import IO;
import Time;
import Trades;

string exchange = "Centrabit";
string symbol = "LTC/BTC"; 

float k = 2.0;
integer n = 20;

integer timeStart = getCurrentTime();
integer diffTime = 3 * 60 * 1000 * 1000; // 3 min
integer timeEnd = timeStart - diffTime;

transaction lastTransactions[] = getPubTrades(exchange, symbol, timeStart, timeEnd);

print(sizeof(lastTransactions));

while(true) {
  timeStart = getCurrentTime();
  timeEnd = timeStart - diffTime;
  inputPriceArray >> getCurrentPrice();
  if (sizeof(inputPriceArray) > 20) // Then calculate bollinger bands
  {

  }
  msleep(300);	// delaying for 300ms
}

// simple moving average
float[] simpleMovingAverage (integer limit) 
{
  float runningTotal = 0.0;
  float outputPriceArray[1];

  // populate initial values in outputPriceArray at index 0 - limit to null
  outputPriceArray[0] = 0.0;
  for (integer i = 0; i < limit; i++) {
    outputPriceArray >> 0.0;
  } 
  
  for (integer i = limit; i < sizeof(inputPriceArray); i++) {
    for (integer j = i-limit; j < i; j++) {
      runningTotal += inputPriceArray[j];
    }
    outputPriceArray >> (runningTotal / toFloat(limit));
    runningTotal = 0.0;
  }
  return outputPriceArray;
}


float calcMeanOfPeriod (integer periodStart, integer periodEnd) 
{
  float runningTotal = 0.0;
  for (integer i = periodStart; i < periodEnd; i++) {
    runningTotal += inputPriceArray[i];
  }
  return runningTotal / toFloat(periodStart-periodEnd);   // warnning : type case needed
}

// standard deviation
float[] stdev (integer limit) 
{
  float outputStdevArray[1];
  outputStdevArray[0] = 0.0;
  for (integer i = 1; i < limit; i++) {
    outputStdevArray >> 0.0;
  } 

  float mean = 0.0;
  float squaredDifferencesSum = 0.0;
  float meanOfSquaredDifferences = 0.0;
  for (integer i = limit; i < sizeof(inputPriceArray); i++) {
    mean = calcMeanOfPeriod(i-limit, i, inputPriceArray);

    // find the sum of the squared differences
    squaredDifferencesSum = 0.0;
    for (integer ii = i-limit; ii < i; ii++) {
      squaredDifferencesSum += pow(inputPriceArray[ii] - mean, toFloat(2));
    }
    // // take the mean of the squared differences
    meanOfSquaredDifferences = squaredDifferencesSum / toFloat(limit);  // warnning : type cast needed
    outputStdevArray >> sqrt(meanOfSquaredDifferences);
  }
  return outputStdevArray;
}

float[] calcBollingerUpperBands (float[] inputPriceArray, float[] sma, float[] stdevArr, integer limit) 
{
  // bollinger_bands
  float upperBands[1];
  upperBands[0] = 0.0;

  for (integer x = 1; x < sizeof(inputPriceArray); x++) {
    if (x < limit) {
      upperBands >> 0.0;
    } else {
      upperBands >> (sma[x] + (k*stdevArr[x]));
    }
  }
  return upperBands;
}

float[] calcBollingerLowerBands (float[] inputPriceArray, float[] sma, float[] stdevArr, integer limit) 
{
  // bollinger_bands
  float lowerBands[1];
  lowerBands[0] = 0.0;

  for (integer x = 1; x < sizeof(inputPriceArray); x++) {
    if (x < limit) {
      lowerBands >> 0.0;
    } else {
      lowerBands >> (sma[x] - (k*stdevArr[x]));
    }
  }
  return lowerBands;
}

float inputPriceArray[1];//= {1.0, 1.1, 1.2, 1.1, 1.5, 1.9, 2.4, 2.7, 2.9, 3.2, 3.5, 3.7, 3.9, 5.0, 3.2, 2.2, 2.3, 2.5, 2.8, 2.9, 3.5, 4.4, 4.3, 4.2, 3.7, 3.5, 4.2, 4.5, 4.8, 5.2, 5.5, 5.7};
inputPriceArray[0] = 1.0;

// print(toString(sizeof(inputPriceArray)));
float sma[] = simpleMovingAverage(n, inputPriceArray);
float stdevArr[] = stdev(n, inputPriceArray);
float bollingerUpperBands[] = calcBollingerUpperBands(inputPriceArray, sma, stdevArr, n);
float bollingerLowerBands[] = calcBollingerLowerBands(inputPriceArray, sma, stdevArr, n);

print ("stdevArr is : " + stdevArr);

