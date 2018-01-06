var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider("http://localhost:8545"));
eth=web3.eth;
// way 1:
src= "" +
"pragma solidity ^0.4.6;\n"  +
"contract myTestContract {\n" +
"   function multiply(uint a, uint b) constant returns(uint) {\n" +
"       return a * b;\n" +
"   }\n" +
"}\n";

//Way 2:
// input ={
//     'inputName' : src,
//     'fileContract' : fs.readFileSync('/tmp/porosity/vulnerable.sol', 'utf8'),
// }

//attention: need to change file path
input ={
    'fileContract' : fs.readFileSync('/Users/amber/projects/contracts/nfcEscrow.sol', 'utf8'),
}//tmp/nfcEscrow.sol

solc=require('solc')


// compiled= eth.compile.solidity(src);
// code =compiled.code;
// abi = compiled.info.abiDefinition;

compiled=solc.compile({sources:input}, 1)

//attention: ensure the key is correct. format: input:Contract name
abi=JSON.parse(compiled.contracts['fileContract:nfcEscrow'].interface)
bytecode =  compiled.contracts['fileContract:nfcEscrow'].bytecode

gasEstimate = web3.eth.estimateGas({data: bytecode});

deployAddr= eth.coinbase;
var inst;
eth.contract(abi).new(
    {data:bytecode, from: deployAddr, gas:gasEstimate }
    ,function (err, contract) {
  if(err){
    console.log("ERROR:" + err);
    return;
  } else if(contract.address){
      inst=contract;
    console.log('address: ' + contract.address);
  }
});

inst.multiply(2, 15)
