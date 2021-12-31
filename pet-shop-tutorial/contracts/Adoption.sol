pragma solidity >= 0.5.0;

contract Adoption {
    address[16] public adopters;

    function adopt(uint petID) public returns (uint) {
        require(petID >=0 && petID <= 15);

        adopters[petID] = msg.sender;

        return petID;
    }

    function getAdopters() public view returns (address[16] memory) {
        return adopters;
    }
}