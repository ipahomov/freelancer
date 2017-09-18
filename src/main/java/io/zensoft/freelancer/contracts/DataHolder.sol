pragma solidity ^0.4.4;

/**
*@title Holds the addresses of the other contracts
*
*/
contract DataHolder {
    address TokenHolderTribunal;
    address ContractHolder;
    address TokenContract=0xF5266aEF432905370364C5B5BE50Db53F8C3B3d8;
    address master;
    
    function DataHolder(){
        master=msg.sender;
    }
    
	/**
	*@notice returns address of THT
	*@return the THT
	*/
    function getTokenHolderTribunal() external constant returns(address){
        return TokenHolderTribunal;
    }
    
	/*
	*@notice returns address of contract holder
	*@return the contract holder
	*/
    function getContractHolder() external constant returns(address){
        return ContractHolder;
    }
    
	/*
	*@notice setter for THT
	*@param _TokenHolderTribunal address of THT to set
	*/
    function setTokenHolderTribunal(address _TokenHolderTribunal) external{
        if(msg.sender!=master)throw;
        TokenHolderTribunal=_TokenHolderTribunal;
    }
    
	/*
	*@notice setter for contract holder
	*@param _ContractHolder the address of the contract holder
	*/
    function setContractHolder(address _ContractHolder) external{
        if(msg.sender!=master)throw;
        ContractHolder=_ContractHolder;
    }
    
	/*
	*@notice returns the address of the Lancer TokenHolderTribunal
	*@return the address of the Lancer Token
	*/
    function getToken() external constant returns(address){
        return TokenContract;
    }
    
	/**
	*@notice setter for the Lancer Token contract
	*@param _TokenContract the address of the Lancer token
	*/
    function setToken(address _TokenContract) external{
        if(msg.sender!=master)throw;
        TokenContract=_TokenContract;
    }
}