//Kovan: 0xa753228340459e92c270aecc968d3ac794b4869e
//Amber token: '0x4f0e13efb2bc2a8a6e642f491f609158b13b46f6';

pragma solidity ^0.4.19;

contract SafeMath {
    function safeSub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }

    function assert(bool assertion) internal {
        if (!assertion) revert();
    }
}


contract Token {
  function transfer(address _to, uint256 _value) returns (bool success) {}
  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
}


contract nfcEscrow is SafeMath {

    bool public isTokenLocked;
    address public admin;
    address public tokenAddress;
    mapping (address => uint) public tokenBalance;

    event DepositToken (address _tokenAddress, address _msgSender, uint _amount, uint _newBalance);
    event WithdrawToken (address _tokenAddress, address _msgSender, uint _amount, uint _newBalance);
    

    function nfcEscrow(address _tokenAddress){
        tokenAddress = _tokenAddress;
        admin=msg.sender;
        isTokenLocked = true;
    }

    function depositToken(uint _amount){
        if (!Token(tokenAddress).transferFrom(msg.sender, this, _amount)) revert();
        tokenBalance[msg.sender] = safeAdd(tokenBalance[msg.sender], _amount);
        DepositToken(tokenAddress, msg.sender, _amount, tokenBalance[msg.sender] );
    }

    function depositTokenFor(address _toAddress, uint _amount) public{
        if (!Token(tokenAddress).transferFrom(msg.sender, this, _amount)) revert();
        tokenBalance[_toAddress] = safeAdd(tokenBalance[_toAddress], _amount);
        DepositToken(tokenAddress, _toAddress, _amount, tokenBalance[msg.sender]);
    }

    function withdrawToken (uint _amount){
        if (isTokenLocked) revert();
        if (_amount > tokenBalance[msg.sender] ) revert();
        tokenBalance[msg.sender] = safeSub(tokenBalance[msg.sender], _amount);
        if (!Token(tokenAddress).transfer(msg.sender, _amount)) revert();
        WithdrawToken(tokenAddress, msg.sender, _amount, tokenBalance[msg.sender]);
    }

    function lockToken () returns (bool) {
        if (msg.sender != admin) revert();
        if (isTokenLocked) revert();
        isTokenLocked = true;
        return isTokenLocked;
    }

    function unlockToken ()  returns (bool) {
        if (msg.sender != admin) revert();
        if (! isTokenLocked) revert();
        isTokenLocked = false;
        return isTokenLocked;
    }

}