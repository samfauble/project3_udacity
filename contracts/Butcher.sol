pragma solidity >=0.6.0;

import "./Base.sol";

contract Butcher is Base {
    //Fields
    address _butcherAddress;
    uint8 _zipCode;

    mapping (uint256 => Cow) butcherCows;
    mapping (uint256 => Cow) meatForSale;
    mapping(address => string) happyConsumers;


    //Methods:
    function buyCow(uint256 cowId) onlyButcher public {
        cows[cowId].butcher = msg.sender;
        cows[cowId].state = uint(State.Sold);
    }
    function confirmTransport(uint256 cowId) onlyButcher enoughButcherFunds(cowId)  public payable returns (bool) {
        uint256 fees = cows[cowId].weight * cows[cowId].price;
        cows[cowId].farmer.transfer(fees);
        cows[cowId].state = uint(State.TransportConfirmed);
    }

    function butcherCow(uint256 cowId) onlyButcher public {
        require(cows[cowId].state == uint(State.TransportConfirmed));
        
        cows[cowId].isMeat = true;

        cows[cowId].state = uint(State.Butchered);
        
        uint256 newPrice = cows[cowId].price * 2;
        cows[cowId].price = newPrice;

        uint256 newWeight = cows[cowId].weight / 2;
        cows[cowId].weight = newWeight;
    }
    function sellMeat(uint256 cowId) onlyButcher public {
        require(cows[cowId].state == uint(State.Butchered));
        cows[cowId].state = uint(State.ForSale);
    }
}