import web3 from "./web3";
import Kaizen from "./build/KaizenFactory.json";

const instance=new web3.eth.Contract(
  Kaizen.abi,
  '0x60D462Eb946A9CFdC37532A9f7f952B1dca0ce13'
);

export default instance;
