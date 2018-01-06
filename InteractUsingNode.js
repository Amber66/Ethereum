-----------

var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider("http://localhost:8545"));
eth=web3.eth;

src= "" +
"pragma solidity ^0.4.6;\n"  +
"contract myTestContract {\n" +
"   function multiply(uint a, uint b) constant returns(uint) {\n" +
"       return a * b;\n" +
"   }\n" +
"}\n";

inputName="\'localContract\'"
inputContractName='myTestContract'
input ={
    'fileContract' : fs.readFileSync('/tmp/porosity/vulnerable.sol', 'utf8'),
    'inputName' : src,
}
solc=require('solc')


// compiled= eth.compile.solidity(src);
// code =compiled.code;
// abi = compiled.info.abiDefinition;

compiled=solc.compile({sources:input}, 1)
abi=JSON.parse(compiled.contracts['inputName:myTestContract'].interface)
bytecode =  compiled.contracts['inputName:myTestContract'].bytecode

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
