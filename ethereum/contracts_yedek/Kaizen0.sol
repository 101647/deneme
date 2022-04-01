pragma solidity ^0.4.24;

//Safe Math Interface

contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


//ERC Token Standard #20 Interface

contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


//Contract function to receive approval and execute function in one call

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

//Actual token contract

contract KEASToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    address public YOUR_METAMASK_WALLET_ADDRESS=0x50e05c53Ab2054bc312646e4530CCAe1C83a9dF5;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "KEAS";
        name = "KEAS Token";
        decimals = 0;
        _totalSupply = 1000000000;
        balances[YOUR_METAMASK_WALLET_ADDRESS] = _totalSupply;
        emit Transfer(address(0), YOUR_METAMASK_WALLET_ADDRESS, _totalSupply);
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    function () public payable {
        revert();
    }
}

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

function createKaizen(string __description) public {
address newKaizen = new KaizenContract(msg.sender,__description,approvers);
deployedKaizens.push(newKaizen);
}

function getDeployedKaizens() public view returns (address[]) {
    return deployedKaizens;
}

function getApprovers() public view returns (address[]) {
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

constructor(address _creator, string _description, address[] _approvers) public {
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

function getSummary() public view returns(string,address,uint,uint){
    return(
      description,
      creator,
      approvalCount,
      approverCount
      );
}

function payKaizen() public {
KEASToken keas=KEASToken(0x0fc0F1766A189F6Dc181BF21bB2aA7A75ab99681);
keas.transfer(0x468473892fc33b94deC441567CB816C63Ce866d0,100);
}

}
