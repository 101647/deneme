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


contract Kaizen is KEASToken {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
        bool _is;
    }

    //Request[] public requests;
    mapping(uint=>Request) public requests;
    address public manager;


    struct Person{
        string fname;
        string lname;
        bool _is;

    }

    mapping(address => Person) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function deneme(){
        super.totalSupply();
    }

    constructor() public {
        manager = msg.sender;

    }

    function deposit() public payable {

    }

    function addApprover(address approver, string _fname, string _lname) public restricted {
        //require(msg.value > minimumContribution);
        require(approvers[approver]._is==false);
        approvers[approver].fname = _fname;
        approvers[approver].lname = _lname;
        approvers[approver]._is = true;
        approversCount++;

    }

    function showApprover(address approver) public view returns(string _fname, string _lname){
         _fname=approvers[approver].fname;
         _lname=approvers[approver].lname;
         return(_fname,_lname);
    }

    function removeApprover(address approver) public restricted{
         //require(approvers[approver]._is==true);
         approvers[approver]._is = false;
         delete approvers[approver];
         approversCount--;
    }

    function createKaizen(string description, uint value) public {
        require(!approvers[msg.sender]._is);
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: msg.sender,
           complete: false,
           approvalCount: 0,
           _is: true
        });

        requests[value]=newRequest;
    }

    function approveKaizen(uint value) public {
        require(approvers[msg.sender]._is);
        Request storage request = requests[value];
        require(request._is==true);

        //request.approvals[msg.sender] = true;
        request.approvalCount++;
        request._is=false;
    }

    function payKaizen(uint value) public restricted {
        Request storage request = requests[value];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        //request.recipient.transfer(100);
        super.transfer(request.recipient,100);
        request.complete = true;
    }


}
