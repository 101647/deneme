pragma solidity ^0.6.12;


contract KaizenFactory {

address[] public deployedKaizens;
address[] public approvers;

function addApprover(address __approver) public {
approvers.push(__approver);
}

function removeApprover(address __approver) public {
uint _length;
_length=approvers.length;
for(uint i=0; i<_length; i++){
        if(__approver==approvers[i]) {delete approvers[i];}
     }
}

function createKaizen(string memory __description) public {
address newKaizen = address(new KaizenContract(msg.sender,__description,approvers));
deployedKaizens.push(newKaizen);
}

function getDeployedKaizens() public view returns (address[] memory) {
    return deployedKaizens;
}

function getApprovers() public view returns (address[] memory) {
    return approvers;
}
}





contract KaizenContract{



address public creator;
string public description;
uint public approvalCount;
uint public approverCount=0;
address[] public approvers;
bool public check;



mapping(address => bool) public approvals;

constructor(address _creator, string memory _description, address[] memory _approvers) public {
creator=_creator;
description=_description;
approvers=_approvers;


for(uint i=0; i<approvers.length; i++){
        if(approvers[i]!=address(0x0)) {approverCount++;}
}

}

function approveKaizen() public {
for(uint i=0; i<approvers.length; i++){
        if(msg.sender==approvers[i]) {
        check=true;
        break;
        }
     }
require(check);
require(!approvals[msg.sender]);
approvals[msg.sender]=true;
approvalCount++;
check=false;
}

function getSummary() public view returns(string memory,address ,uint,uint){
    return(
      description,
      creator,
      approvalCount,
      approverCount
      );
}





}
