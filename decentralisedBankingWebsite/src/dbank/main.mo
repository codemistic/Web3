import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Float "mo:base/Float";
actor DBank{
  stable var price : Float = 100;
  // price:=100;
  // let id=14541146144456;
  // Debug.print(debug_show(id));
  public func topUp(amount: Float){
    price+=amount;
    Debug.print(debug_show(price));
  };
  stable var startTime=Time.now();
  Debug.print(debug_show(startTime));
  public func withdraw(amount: Float){
    let temp: Float = price - amount;
    if(temp>=0){
      price-=amount;
      Debug.print(debug_show(price));
    }
    else{
      Debug.print("Sorry not enough balance in your account");
    }
  };
  public query func checkBalance(): async Float{
    return price;
  };
  public func compound(){
    let currTime=Time.now();
    let timeElapsedNS=currTime-startTime;
    let timeElapsed=timeElapsedNS/1000000000;//decreased interest rate by 1000 times ;)
    price := price * (1.00001 ** Float.fromInt(timeElapsed));
    Debug.print(debug_show(price));
    startTime:=currTime;
  };
}