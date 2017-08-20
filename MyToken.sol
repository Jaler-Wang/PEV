a solidity ^0.4.0;

contract owned{
    address public owner;
    function owned(){
        owner = msg.sender;
    }
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner) onlyOwner{
        require(newOwner != owner);
        owner = newOwner;
    }
    
}
contract MyToken is owned{
    string public name;
    string public symbol;
    uint8 public decimal;
    uint public totalSupply;
    uint public sellPrice;
    uint public buyPrice;
    uint minBalanceForAccount = 0.005 ether;
    bytes32 public currentChallenge;
    uint public timeOfLastProof;
    uint public difficulty;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => bool) public blacklist;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event FrozenFund(address target, bool freeze);
    
    function MyToken(string _name, 
                        string _symbol, 
                        uint8 _decimal,
                        address centerMiner,
                        uint initialSupply){
        name = _name;
        symbol = _symbol;
        decimal = _decimal;
        totalSupply = initialSupply;
        if(centerMiner != 0){
            owner = centerMiner;
        }
    }
    
    function _transfer(address _from, address _to, uint value) internal{
        require(!blacklist[_from]);
        require(!blacklist[_to]);
        require(balanceOf[_from] >= value);
        require(balanceOf[_to] + value > balanceOf[_to]);
        require(_to != address(0));
        balanceOf[_from] -= value;
        balanceOf[_to] += value;
        Transfer(_from, _to, value);
    }
    
    function transfer(address _to, uint value){
        if(msg.sender.balance < minBalanceForAccount){
            sell((minBalanceForAccount - msg.sender.balance)/sellPrice);
        }
        _transfer(msg.sender, _to, value);
    }
    
    function mintToken(address target, uint mintedAmount) onlyOwner{
        totalSupply += mintedAmount;
        balanceOf[target] += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }
    
    function freezeAccount(address target, bool freeze) onlyOwner{
        blacklist[target] = freeze;
        FrozenFund(target, freeze);
    }
    
    function setPrices(uint _sellPrice, uint _buyPrice) onlyOwner{
        sellPrice = _sellPrice;
        buyPrice = _buyPrice;
    }
    
    function buy() payable returns(uint amount){
        amount = msg.value/sellPrice;
        require(balanceOf[this] >= amount);
        balanceOf[this] -= amount;
        balanceOf[msg.sender] += amount;
        Transfer(this, msg.sender, amount);
    }
    
    function sell(uint amount) payable returns(uint revenue){
        require(balanceOf[msg.sender] >= amount);
        revenue = amount * sellPrice;
        balanceOf[msg.sender] -= amount;
        balanceOf[this] += amount;
        msg.sender.transfer(revenue);
        Transfer(msg.sender, this, amount);
        
    }
    
    function setMinBalance(uint minBalance) onlyOwner{
        minBalanceForAccount = minBalance * 1 finney;
    }
    
    function pow(uint nonce){
        bytes8 n = bytes8(sha3(nonce, currentChallenge));
        require(n >= bytes8(difficulty));
        
        uint timeSinceLastProof = now - timeOfLastProof;
        require(timeSinceLastProof >= 5 seconds);
        balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;
        timeOfLastProof = now;
        difficulty = difficulty * 10 minutes/timeSinceLastProof + 1;
        currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number -1));
    }
    
}
