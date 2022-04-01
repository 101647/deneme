import web3 from "./web3";
import SafeMath from "./build/ERC20Interface.json";

export default (address)=>{
  return new web3.eth.Contract(
    JSON.parse(ERC20Interface.interface),
    address
  );
};
