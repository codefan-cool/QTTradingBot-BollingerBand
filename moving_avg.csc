script moving_avg;

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

integer length = 120;
integer collectionSpan = 1000000; // 1000 - every ms 1 - every microsecond

float bestBids[length];
float bestAsks[length];
float buyAmount = 0.10;

integer lastTimeSinceCycle = getCurrentTime();

float avg(float[] data) {
    float result = 0.0;

    for(integer i = 0; i < sizeof(data); i++) {
        result += data[i];
    }

    result = result / toFloat(sizeof(data));
    return result;
}


event onOwnOrderFilled(string ex, transaction t) {
    if(t.isAsk) {
        print("Sell Order executed");
    }
    print("Buy Order executed");
};


// Data Collecting Phase
for(integer i = 0; i < length; i++) {
    while(getCurrentTime() < lastTimeSinceCycle + collectionSpan);
    
    bestBids[i] = getOrderBookBid(exchange, symbol);
    bestAsks[i] = getOrderBookAsk(exchange, symbol);

    print("Second " + toString(i) + "# Best bid: " + toString(bestBids[i]) + " Best ask: " + toString(bestAsks[i]));

    lastTimeSinceCycle = getCurrentTime();
}


// If Last Order was a buy, we would now want to sell

lastTimeSinceCycle = getCurrentTime();
while(true) {
    while(getCurrentTime() < lastTimeSinceCycle + 1000000);
    float currentPrice = 0.0;        

    
    currentPrice = getOrderBookBid(exchange, symbol);
    print("Avg Ask Price " + toString(avg(bestAsks)) + " Avg Bid Price " + toString(avg(bestBids)) + " Avg Spread: " + toString(avg(bestAsks) - avg(bestBids)));
    if(currentPrice > avg(bestAsks) - 0.000001 || currentPrice > avg(bestAsks) + 0.000001 ) {
        drawPoint(getCurrentTime(), currentPrice, false, exchange, symbol);
        print("Market Buy Order Sent Price: " + toString(currentPrice) + ", Amount: " + toString(buyAmount));
        // Buy here      
        buyMarket(exchange, symbol, buyAmount, 0);
    }
    
    
    currentPrice = getOrderBookAsk(exchange, symbol);
    //print("Avg Bid Price " + toString(avg(bestBids)) + " Avg Ask Price" + toString(avg(bestAsks)) + " Avg Spread: " + toString(avg(bestAsks) - avg(bestBids)));
    if(currentPrice > avg(bestBids) - 0.000001 || currentPrice > avg(bestBids) + 0.000001 ) {
       drawPoint(getCurrentTime(), currentPrice, true, exchange, symbol);
       print("Market Sell Order Sent Price: " + toString(currentPrice) + ", Amount: " + toString(buyAmount));            
       // Buy here      
       sellMarket(exchange, symbol, buyAmount, 0);
    }
    

    // Update Prices
    bestAsks >> getOrderBookAsk(exchange, symbol);
    delete bestAsks[0];
    bestBids >> getOrderBookBid(exchange, symbol);
    delete bestBids[0];

    lastTimeSinceCycle = getCurrentTime();
}

