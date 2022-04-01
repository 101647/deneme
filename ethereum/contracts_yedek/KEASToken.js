import web3 from "./web3";
import KEASToken from "./build/KEASToken.json";

export default (address)=>{
  return new web3.eth.Contract(
    JSON.parse(KEASToken.interface),
    address
  );
};
