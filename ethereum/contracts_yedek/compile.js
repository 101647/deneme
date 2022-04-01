const path=require('path');
const fs=require('fs-extra');
const solc=require('solc')

//Delete all contents of build folder
const buildPath=path.resolve(__dirname,'build');
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname,'contracts','Kaizen.sol');
const source = fs.readFileSync(campaignPath,'utf8');
const output = solc.compile(source,1).contracts;

fs.ensureDirSync(buildPath);

for (let contract in output){
  fs.outputJsonSync(
    path.resolve(buildPath,contract.replace(':','') + '.json'),
    output[contract]
  );
}
