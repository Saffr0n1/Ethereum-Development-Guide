pragma solidity >= 0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol";

contract TestAdoption {
    // The address to be tested -- Calls the DeployedAddress smart contract 
    Adoption adoption = Adoption(DeployedAddresses.Adoption());

    // petID used for testing
    uint expectedPetID = 8;

    // Contract that is the expected owner of this pet -- 'this' is a contract-wide 
    // variabe that gets the current contract's address, since TestAdoption will be
    // sending the transaction
    address expectedAdopter = address(this);

    // Testing adopt()
    function testUserCanAdoptPet() public {
        uint returnedID = adoption.adopt(expectedPetID);
        
        Assert.equal(returnedID, expectedPetID,"Adoption of the expected pet should match what is returned.");
    }

    // Testing retrieval of a single pet's owner
    function testGetAdopterAddressByPetId() public {
        address adopter = adoption.adopters(expectedPetID);
        Assert.equal(adopter, expectedAdopter, "Owner of the expected pet should be this contract");
    }

    // Testing retrieval of all pet owners
    function testGetAdopterAddressByPetIdInArray() public {
    // Store adopters in memory rather than contract's storage
        address[16] memory adopters = adoption.getAdopters();
        Assert.equal(adopters[expectedPetID], expectedAdopter, "Owner of the expected pet should be this contract");
    }

    
}