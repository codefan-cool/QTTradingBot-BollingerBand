script DrawTest;

import IO;
import Trades;
import Math;
import Time;
import Charts;

print("Starting Simple Moving AVG Script 120 Second");

string exchange = "Centrabit";
string symbol = "LTC/BTC"; 

setChartsExchange(exchange);
setChartsSymbol(symbol);

// lastTimeSinceCycle = getCurrentTime();
while(true) {
    drawLine(getCurrentTime(), 0.0035);
    drawPoint(getCurrentTime(), 0.0036, false, exchange, symbol);

    msleep(300);	// delaying for 10ms
}
