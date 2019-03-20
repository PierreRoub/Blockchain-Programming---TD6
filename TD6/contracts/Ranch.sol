pragma solidity ^0.4.25;

// Thank you Kenji
//https://github.com/GLAUKEN/ico-erc20/blob/master/contracts/Crowdsale.sol



import "./ERC721.sol";
import "../math/SafeMath.sol";

contract Ranch is ERC721 {
    using SafeMath for uint256;
    address private _moderator;

    struct Animal 
    {
        address creator;
        string name;
        string kind;
        int age;
        int strength;
        bool sort;   // true = female,  false= male
        bool alive;
    }

    Animal[] public Animals;

    event RegisterBreederedAdded(address indexed account);
    event declaredAnimal(uint objectNumber);

    mapping (address => bool) private _registerBreeder;
    mapping (uint256 => address) private _tokenOwner;

    modifier onlyOwner() {
        require(msg.sender == _moderator, "Owner 0x0");
        _;
    }

    function owner() public view returns (address) {
        return _moderator;
    }

    modifier isRegister(address _address) {
        require(_registerBreeder[_address], "not in registerBreeder");
        _;
    }

    function addRegisterBreeder(address _address) public onlyOwner() {
        require(!_registerBreeder[_address], "aldready in registerBreeder");
        _registerBreeder[_address] = true;
        emit RegisterBreederedAdded(_address);
    }

    function isInRegister(address _address) public view returns (bool) {
        return _registerBreeder[_address];
    }

    function declareAnimal(string _name, string _kind, int _age, int _strength, bool _sort) public  // true = female,  false= male
    {
        Animal memory _Animal;
        require(isInRegister(msg.sender));

        _Animal.creator = msg.sender;
        _Animal.name = _name;
        _Animal.kind = _kind;
        _Animal.age = _age;
        _Animal.strength = _strength;
        _Animal.sort = _sort;
        _Animal.alive = true;

        Animals.push(_Animal) - 1;
        uint objectNumber = Animals.length - 1;
        _tokenOwner[objectNumber] = msg.sender;
        emit declaredAnimal(objectNumber);
    }

    function deadAnimal(uint _animalNumber) public {
        require(_tokenOwner[_animalNumber] == msg.sender);
        Animals[_animalNumber].alive = false;
    }


    function breedAnimal(uint _femaleNumber, uint _maleNumber, string _name,bool _sort ) public 
    {
        require((Animals[_femaleNumber].sort == true) && (Animals[_maleNumber].sort == false));
        require((_tokenOwner[_femaleNumber] == msg.sender) || (_tokenOwner[_maleNumber] == msg.sender));
        declareAnimal (_name, Animals[_femaleNumber].kind, 0, Animals[_maleNumber].strength,_sort);
    }


}

