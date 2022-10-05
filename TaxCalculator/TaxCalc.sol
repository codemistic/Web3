// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TaxCal{

    uint public Totalincome;
    uint public TotalDed;
    uint public PerMonth;
    uint256 public Taxin;
    uint public brac1;
    uint public  brac2;
    uint public brac3;
    uint public result;
 

    constructor(uint _Totalincome, uint _TotalDed){
        Totalincome = _Totalincome;
        TotalDed = _TotalDed;
    }
    
    function TaxCalcutor() public returns (uint){

        PerMonth = Totalincome/12;

        Taxin = Totalincome - TotalDed;
     
        if(Taxin > 250000){
            if(Taxin > 500000){
                if(Taxin > 1000000){
                    brac1 = ((Taxin - 1000000)*3/10)+112500;
                    result = (Totalincome - brac1)/12;
                    }
                else{
                     brac2 = ((Taxin-500000)*2/10) +12500;
                     result = (Totalincome - brac2)/12; 
                    }
            }
            else{
                brac3= (Taxin-250000)*5/100;
                result= (Totalincome - brac3)/12;
                }    
        }
    
        else{
            result = 0;
        }
        return result;
        
    }
        
}
