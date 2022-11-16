import IO;
import Trades;

event onOwnOrderOpen(string exchange, order o)
{
    print("order has been opened: price=" + toString(o.price) +
          ", amount=" + toString(o.amount) + 
          ", marker=" + toString(o.marker));
}

event onOwnOrderFilled(string exchange, transaction t)
{
    print("order has been filled: txID=" + toString(t.id));
}

event onOwnOrderError(string exchange, string symbol, integer marker, string error)
{
    print("unable to open an order: marker=" + toString(marker) + " - " + error);
}

string exchange     = "centrabit";
string currencyPair = "BTC/USDT";
float  amount  = 0.0001;
float  balance = getAvailableBalance(exchange, "BTC");

if (balance >= amount)
    sell(exchange, currencyPair, amount, 50000.0, 1);
else
    print("unable to open an order: insufficient funds = " + toString(balance));