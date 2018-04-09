pragma solidity ^0.4.21;


contract Escrow {
    
    enum State {UNINITIATED, AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE}
    State  public currentState;
    
    address public buyer; 
    address public seller;
    uint public price;
    
    bool public buyer_in;
    bool public seller_in;
    
    /* DRY Code - Avoid repeatation of code */
    modifier inState(State expectedState) { require(currentState == expectedState); _;}
    modifier correctPrice() { require(msg.value == price); _; }
    modifier buyerOnly() { require(msg.sender == buyer); }
    
    function Escrow(address _buyer, address _seller, uint _price) {
        buyer = _buyer;
        seller = _seller;
        price = _price;
    }
    
    /* Burn Contract - both seller and buyer needs to put some money and it's returned if the transaction is successful */
    function initiateContract() correctPrice inState(State.UNINITIATED) payable {
        /* require(msg.value == price); */
        
        if (msg.sender == buyer) {
            buyer_in = true;
        }
        
        if (msg.sender == seller) {
            seller_in = true;
        }
        
        if (buyer_in && seller_in) {
            currentState = State.AWAITING_PAYMENT;
        }
    }
    
    function confirmPayment() correctPrice inState(State.AWAITING_PAYMENT) payable {
        require(msg.sender == buyer);
        /* require(msg.value == price); */
        currentState = State.AWAITING_DELIVERY;
    }
    
    function confirmDelivery() inState(State.AWAITING_DELIVERY) {
        /* require(msg.sender == buyer); */
        seller.send(price * 2);
        buyer.send(price);
        currentState = State.COMPLETE;
    }
    
}
