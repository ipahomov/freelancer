pragma solidity ^0.4.4;

import "EmploymentContract.sol";

/**
 * @title Interface for DataHolder
 */
contract DataHolder{
    function getTokenHolderTribunal() external constant returns(address);

    function getContractHolder() external constant returns(address);
}

/**
 * @title Interface for TokenHolderTribunal
 */
contract TokenHolderTribunal{
    function createDispute(address disputeContract) external;
    function FinalizeDispute(address disputeContract) external returns(uint);
}

/** @title The contract holder */
contract ContractHolder {

    /**data of the client*/
    struct User{
    int ClientScore;
    int FreelancerScore;
    int totalContracts;
    }

    /**address to the  data holder -> contains the addresses to all important contractState
    allows us to just replace a single contract with another one
    after replacing everything works the same as before - except this contract communicate with a different contract */
    address aDataHolder=0x5AA72B91805713fAed3672C759f305B751C0a8D3;

    //array of the job contracts
    address[] aContracts;

    /**for TESTING only
    the master is allowed to change certain parts of this contract */
    address master;

    mapping(address => User) Users;
    mapping(address => uint) Contracts;

    function ContractHolder(){
        master=msg.sender;
    }

    /**
         *@notice get all the active contracts
         *@return  all active contracts */
    function getActiveContracts() constant external returns(address[]){
        return aContracts;
    }

    /**
         * @notice create a new job contract
         * @param link location of information about the employment contract
         * @dev link can be a URL or an IPFS hash
         * */
    function createNewFreelanceContract(string link) {
        //create a new contract
        address newContract = new EmploymentContract(link,msg.sender);
        aContracts.push(newContract);
        Contracts[newContract]=aContracts.length-1;
    }

    /**
         * @notice After the contract is fullfilled the client pays to the freelancer and gives a rating to the freelancer
         * @param _client address of the client
         * @param _rating the rating of the freelancer
         */
    function ContractFullfilled(address _client,int _rating){
        //only a registered job contract is allowed to call this function
        if(aContracts[Contracts[msg.sender]]!=msg.sender) throw;

        Users[_client].totalContracts++;
    }

    /**
         * @notice If dispute happens, freelancer or client can call this function. Tokenholder tribunal is informed and a dispute is registered
         */
    function dispute(){
        //only a registered job contract is allowed to call this function
        if(aContracts[Contracts[msg.sender]]!=msg.sender) throw;

        //register this dispute in the token holder tribunal
        TokenHolderTribunal(DataHolder(aDataHolder).getTokenHolderTribunal()).createDispute(msg.sender);
    }

    /**
         * @notice get called by the job contract after the token holder tribunal made decision. The winner of the THT gets the money locked in the contract
         * @return The winner of the THT is returned
         * */
    function finalizeDispute() returns(uint){
        if(aContracts[Contracts[msg.sender]]!=msg.sender) throw;
        return TokenHolderTribunal(DataHolder(aDataHolder).getTokenHolderTribunal()).FinalizeDispute(msg.sender);
    }

}