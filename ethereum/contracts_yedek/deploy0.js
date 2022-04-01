const HDWalletProvider=require('@truffle/hdwallet-provider');
const Web3=require('web3');
const compiledFactory = require('./build/QKCToken.json');

/*
const provider=new HDWalletProvider(
  'swift mixture reform step tube question once quiz job negative smoke sentence',
  'https://rinkeby.infura.io/v3/91fd89f63cb94781a4665384fbc7f9ef'
);
*/
const provider=new HDWalletProvider(
  '86bcfff18d34945fc7e5ca9b171f8d14247d073386474d4f96680736f11d770a',
  'http://localhost:7545'
);

const web3=new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  console.log('Attempting to deploy from account',accounts[0]);
  const result=await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({data: compiledFactory.bytecode})
    .send({from: accounts[0],gas:'6000000'});

  console.log('Contract deployed to',result.options.address);
  provider.engine.stop();
};
deploy();
