pragma solidity ^0.4.4;

library Math {
  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a < b ? a : b;
  }
}


library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}



contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) constant returns (uint256);
  function transfer(address to, uint256 value) returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}



 contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) returns (bool);
  function approve(address spender, uint256 value) returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) returns (bool) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of. 
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

}



contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amout of tokens to be transfered
   */
  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
    var _allowance = allowed[_from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[_to] = balances[_to].add(_value);
    balances[_from] = balances[_from].sub(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) returns (bool) {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifing the amount of tokens still avaible for the spender.
   */
  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}

 contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}


contract ChiliToken is StandardToken, owned {

string public constant name = "CHILI";
string public constant symbol = "CHL";
uint32 public constant decimals = 3;
uint256 public  exchangeRate=200;
uint256 public INITIAL_SUPPLY = 100000000 * 1000;
 address public sellAgent;
 
 uint256 public START_PRESALE_TIMESTAMP   = 1501595111;
 uint256 public START_PREICO_TIMESTAMP   = 1501595111;
 uint256 public START_ICO_TIMESTAMP   = 1501595111;
 
  uint256 public END_PRESALE_TIMESTAMP   = 0;
 uint256 public END_PREICO_TIMESTAMP   = 0;
 uint256 public END_ICO_TIMESTAMP   = 0;
 
  uint256 public LOCKUP_3M_ICO_TIMESTAMP   = 0;
  uint256 public LOCKUP_6M_ICO_TIMESTAMP   = 0;
 
  uint32 public  PRESALE_HARDCAP=250000;
  uint32 public   PREICO_HARDCAP=700000;
  uint32 public      ICO_HARDCAP=10500000;
  
    uint256 public   PRESALE_PERIOD=14;
    uint256 public   PREICO_PERIOD=28;
  uint256 public     ICO_PERIOD=28;
 
    address addressPayForService=0x15d6C4FFF2bBc8Abf9c11307FF4FB9e0DE270644;
    address addressBounty=0x15d6C4FFF2bBc8Abf9c11307FF4FB9e0DE270644;
    address addressSiteReg=0x15d6C4FFF2bBc8Abf9c11307FF4FB9e0DE270644;
    address addressFond=0x15d6C4FFF2bBc8Abf9c11307FF4FB9e0DE270644;
    address addressCreators=0x15d6C4FFF2bBc8Abf9c11307FF4FB9e0DE270644;

event PayForServiceETHEvent(address indexed from, uint256 value);
event PayForServiceCHLEvent(address indexed from, uint256 value);

function ChiliToken() {
  totalSupply = INITIAL_SUPPLY;
 
     balances[addressBounty] = INITIAL_SUPPLY.mul(4).div(100);
     balances[addressSiteReg] = INITIAL_SUPPLY.div(100);
     balances[addressFond] = INITIAL_SUPPLY.mul(42).div(1000);
     balances[addressCreators] = INITIAL_SUPPLY.mul(2).div(10);
     balances[msg.sender] = INITIAL_SUPPLY-balances[addressBounty]-balances[addressSiteReg]-balances[addressFond]-balances[addressCreators];
 
 END_PRESALE_TIMESTAMP=START_PRESALE_TIMESTAMP+(PRESALE_PERIOD * 1 days);  
 END_PREICO_TIMESTAMP=START_PREICO_TIMESTAMP+(PREICO_PERIOD * 1 days);   
 END_ICO_TIMESTAMP=START_ICO_TIMESTAMP+(ICO_PERIOD * 1 days);   
 
 LOCKUP_3M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(90 * 1 days); 
 LOCKUP_6M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(180 * 1 days);  
 
 
 
}
    function setRate( uint32 newRate)  onlyOwner {
	  exchangeRate = newRate;
     }
     
       function update_START_PRESALE_TIMESTAMP( uint256 newTS)  onlyOwner {
	  START_PRESALE_TIMESTAMP = newTS;
	   END_PRESALE_TIMESTAMP=START_PRESALE_TIMESTAMP+(PRESALE_PERIOD * 1 days);  
     }
       function update_START_PREICO_TIMESTAMP( uint256 newTS)  onlyOwner {
	  START_PREICO_TIMESTAMP = newTS;
	  END_PREICO_TIMESTAMP=START_PREICO_TIMESTAMP+(PREICO_PERIOD * 1 days);  
     }
     
        function update_START_ICO_TIMESTAMP( uint256 newTS)  onlyOwner {
	  START_PREICO_TIMESTAMP = newTS;
	 END_ICO_TIMESTAMP=START_ICO_TIMESTAMP+(ICO_PERIOD * 1 days);  
	  LOCKUP_3M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(90 * 1 days);  
 LOCKUP_6M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(180 * 1 days);  
     }
     
     
function updateSellAgent(address new_address) onlyOwner {
   sellAgent=new_address;
  }
 
   function transferSellAgent(address _to, uint256 _value) returns (bool) {
    balances[owner] = balances[owner].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(owner, _to, _value);
    return true;
  }
  
   function endICO() public onlyOwner {
   
    balances[addressFond] = balances[addressFond].add( balances[owner] );
     Transfer(owner, addressFond,   balances[owner]);
     balances[owner] =0;
      balances[addressFond] = balances[addressFond].add( balances[addressSiteReg] );
        Transfer(addressSiteReg, addressFond,   balances[addressSiteReg]);
     balances[addressSiteReg] =0;
    
   
   
  }
  
   modifier isSelling() {
    require( ((now>START_PRESALE_TIMESTAMP&&now<END_PRESALE_TIMESTAMP ) ||(now>START_PREICO_TIMESTAMP&&now<END_PREICO_TIMESTAMP ) ||(now>START_ICO_TIMESTAMP&&now<END_ICO_TIMESTAMP ) ) );
     require(balances[owner]>0 );
    
    
    _;
  }
  
    function transfer(address _to, uint256 _value) returns (bool) {
        require(msg.sender!=addressCreators||now>LOCKUP_6M_ICO_TIMESTAMP);
        require(msg.sender!=addressBounty||now>LOCKUP_3M_ICO_TIMESTAMP);
        
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }
  
  
    function() external payable isSelling {
        
        
     
      
     uint tokens = exchangeRate.mul(5000).mul(msg.value).div(1 ether);
     uint addingBalance=exchangeRate.mul(msg.value).div(1 ether);

if (now>START_PRESALE_TIMESTAMP&&now<END_PRESALE_TIMESTAMP)
{
    require((addingBalance+balanceOf(owner))<PRESALE_HARDCAP);
    
       tokens=tokens.mul(3).div(2);
    
       
} else 

if (now>START_PREICO_TIMESTAMP&&now<END_PREICO_TIMESTAMP)
{
    require((addingBalance+balanceOf(owner))<PREICO_HARDCAP);
    
      uint bonusTokens = 0;
        if(now < START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4)) {
          bonusTokens = tokens.mul(3).div(10);
        } else if(now >= START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4) && now < START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4).mul(2)) {
          bonusTokens = tokens.div(4);
        } else if(now >= START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4).mul(2) && now < START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4).mul(3)) {
          bonusTokens = tokens.div(5);
        } else
        {
             bonusTokens = tokens.mul(3).div(20);
        }
        
        
        tokens += bonusTokens;
       
       
} else 
     
     if (now>START_ICO_TIMESTAMP&&now<END_ICO_TIMESTAMP)
{
    require((addingBalance+balanceOf(owner))<ICO_HARDCAP);
    
      uint bonusTokensICO = 0;
        if(now < START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4)) {
          bonusTokensICO = tokens.mul(3).div(10);
        } else if(now >= START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4) && now < START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4).mul(2)) {
          bonusTokensICO = tokens.div(4);
        } else if(now >= START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4).mul(2) && now < START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4).mul(3)) {
          bonusTokensICO = tokens.div(5);
        } else
        {
             bonusTokensICO = tokens.mul(3).div(20);
        }
        
        
        tokens += bonusTokensICO;
       
       
} else {
   revert();
}
  
     
  
    owner.transfer(msg.value);
    balances[owner] = balances[owner].sub(tokens);
    balances[msg.sender] = balances[msg.sender].add(tokens);
    Transfer(owner, msg.sender, tokens);
           
    }
     function PayForServiceETH() external payable  {
      
      addressPayForService.transfer(msg.value);
      PayForServiceETHEvent(msg.sender,msg.value);
      
  }
    function PayForServiceCHL(uint256 _value)  external    {
     
      require( balances[msg.sender]>=_value&&_value>0);
      
      balances[msg.sender] = balances[msg.sender].sub(_value);
      balances[addressPayForService] = balances[addressPayForService].add(_value);
      PayForServiceCHLEvent(msg.sender,_value);
      
  }
  
}

 