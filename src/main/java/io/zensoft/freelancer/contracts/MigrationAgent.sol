pragma solidity ^0.4.8;

/**@title The old contract. This contract is going to be replaced. Just an Interface
*/
contract Token{
	function totalSupply() constant returns (uint256);
}

/**
*@title The new contract. This contract replaces the old contract. Just an Interface
*/
contract NewToken{
	function totalSupply() constant returns (uint256);
	
	function finalizeMigration();
	
	//creates token on the new contract
	function createToken(address from, uint256 amount);
}

/**
*@title Allows to migrate to a new contract
*/
contract MigrationAgent {

	//only the owner is allowed to do some things
    address master;
	
	//old and new Token address
    address oldToken;
    address NewToken;

	//total amount of migrated token
    uint256 tokenSupply;

	/**@notice set the old Token address at the creation master = sender
	*@param _oldToken The contract that should be replaced
	*/
    function MigrationAgent(address _oldToken) {
        master = msg.sender;
        oldToken = _oldToken;
    }
	
	/**
	*@notice return the total amount of migrated token  -> allows everyone to easiely see the progress of the migration
	*@return how many tokens are already migrated
	*/
	function totalSupply() constant returns(uint256){
		return tokenSupply;
	}

	/**
	*@notice The address of the new token contract
	*@param _NewToken The address of the new token contract
	*/
	function setNewTokenAddress(address _NewToken) {
        if (msg.sender != master) throw;
        if (NewToken != 0) throw;

        NewToken = _NewToken;
    }

	/**
	*@notice check conditions, if migration is possible
	*@param _value how many tokens should be migrated
	*/
    function safetyCheck(uint256 _value) private {
        if (NewToken == 0) throw;
        if (Token(oldToken).totalSupply() + NewToken(NewToken).totalSupply() != tokenSupply - _value) throw;
    }

    /**
	*@notice migrate from function is called in the old contract. Starts migartion
	*@param _from from whom should the tokens migrate
	*@param _value how many tokens should migrate
	*/
    function migrateFrom(address _from, uint256 _value) {
        if (msg.sender != oldToken) throw;
        if (NewToken == 0) throw;

        //Right here oldToken has already been updated, but corresponding GNT have not been created in the NewToken contract yet
        safetyCheck(_value);

        NewToken(NewToken).createToken(_from, _value);

        //Right here totalSupply invariant must hold
        safetyCheck(0);
    }

	/**
	*@notice Finish the migration process. Stops further migration. Allows working with the new contract.
	*/
    function finalizeMigration() {
        if (msg.sender != master) throw;

        safetyCheck(0);

		//finish the migration and stop further migration
        NewToken(NewToken).finalizeMigration();

        oldToken = 0;
        NewToken = 0;

        tokenSupply = 0;
    }
}