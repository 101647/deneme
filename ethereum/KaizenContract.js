import web3 from "./web3";
import KaizenContract from "./build/KaizenContract.json";

export default (address)=>{
  return new web3.eth.Contract(
    KaizenContract.abi,
    address
  );
};
