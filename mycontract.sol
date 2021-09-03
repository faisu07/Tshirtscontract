pragma solidity >=0.7.0 <0.9.0;

contract tshirts{
    struct order{ // the main struct to maintain orders and their delivery
        uint id;
        uint quantity;
        uint cost;
        string status;
    }
    mapping(uint => order) private orders;
    
    struct payment_status{
        uint order_id;
        string status;
        string proof;
        uint userCount;
    }
    
    mapping(uint => payment_status) private payment;
    constructor(){
        init(msg.sender);
    }

    function init(address _ad) private{
        userCount++;
        User[_ad]="Admin";
        user[User[_ad]]=Users(userCount, User[_ad], 1); 
    }
    function makeOrder(uint _quant, uint _typ) public{
        require(user[User[msg.sender]].role==2);
        require(_typ>=1);
        orderCount++;
        uint _cost=0;
        _cost=((_typ*33)/100)*_quant;
        orders[orderCount]=order(orderCount,_quant,_typ,_cost,"payment_incomplete");
    }
    function acceptOrder(uint _orderid, uint _stat) public {
        require(user[User[msg.sender]].role==1);
        require(_stat>0 && _stat<3);
        require(_orderid>0);
        order storage _order=orders[_orderid];
        if (_stat==1){
            _order.status="order_acknowledged";
        }
        else{
            _order.status="order_declined";
        }
    }
    function makePayment(uint _orderid, string memory _proof) public {
        require(user[User[msg.sender]].role==2);
        require(_orderid>0);
        paymentCount++;
        payment[paymentCount]=payment_status(_orderid,"Awaiting_Confirmation",_proof);
    }
    function acceptPayment(uint _payid, uint _stat) public {
        require(user[User[msg.sender]].role==1);
        require(_stat>=0 && _stat<1);
        require(_payid>0);
        payment_status storage _payment=payment[_payid];
        order storage _order=orders[_payment.order_id];
        if (_stat==1){
            _payment.status="Confirmed";
            _order.status="payment_done";
        }
    }
    
}