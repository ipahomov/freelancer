package io.zensoft.freelancer.GethTest;

import org.junit.Test;
import org.web3j.crypto.CipherException;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.EthCompileSolidity;
import org.web3j.protocol.core.methods.response.Web3ClientVersion;
import org.web3j.protocol.http.HttpService;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertNotNull;

/**
 * Created by Igor Pahomov on 17.09.2017.
 */
public class GethConnectTest {

    @Test
    public void clientVersionTest() throws ExecutionException, InterruptedException {
        Web3j web3 = Web3j.build(new HttpService());
        Web3ClientVersion web3ClientVersion = web3.web3ClientVersion().sendAsync().get();

//        System.out.println(web3ClientVersion.getWeb3ClientVersion());
//        System.out.println(web3.ethBlockNumber().sendAsync().get().getBlockNumber());
//        System.out.println(web3.ethCoinbase().sendAsync().get().getAddress());

        List<String> compilers = web3.ethGetCompilers().sendAsync().get().getCompilers();
        System.out.println(compilers);
    }

    public void testSmartContract() throws IOException, CipherException {
        Web3j web3 = Web3j.build(new HttpService());

        Credentials credentials = WalletUtils.loadCredentials("igor", "");
    }

    public void createContracttest() {
        Web3j web3 = Web3j.build(new HttpService());

//        TestContract testContract =  new TestContract();
//
//        SolidityFunctionWrapperGenerator.run("");


    }

    @Test
    public void getAccountsTest() throws ExecutionException, InterruptedException {
        Web3j web3 = Web3j.build(new HttpService());

        System.out.println(web3.ethAccounts().sendAsync().get().getAccounts());

    }

    @Test
    public void testEthCompileSolidity() throws Exception {
        Web3j web3j = Web3j.build(new HttpService());

        String sourceCode = "pragma solidity ^0.4.0;"
                + "\ncontract test { function multiply(uint a) returns(uint d) {"
                + "   return a * 7;   } }"
                + "\ncontract test2 { function multiply2(uint a) returns(uint d) {"
                + "   return a * 7;   } }";
        EthCompileSolidity ethCompileSolidity = web3j.ethCompileSolidity(sourceCode)
                .send();
        assertNotNull(ethCompileSolidity.getCompiledSolidity());
        assertThat(
                ethCompileSolidity.getCompiledSolidity().get("test2").getInfo().getSource(),
                is(sourceCode));
    }

}
