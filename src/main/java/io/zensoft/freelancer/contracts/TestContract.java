package io.zensoft.freelancer.contracts;

import org.web3j.protocol.Web3j;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;

import java.math.BigInteger;

/**
 * Created by Igor Pahomov on 17.09.2017.
 */
public class TestContract extends Contract {

    protected TestContract(String contractBinary, String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(contractBinary, contractAddress, web3j, transactionManager, gasPrice, gasLimit);

    }



}
