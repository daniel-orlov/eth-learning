const erc20Token = artifacts.require("ERC20Token");
const supplyChain = artifacts.require("SupplyChain");

module.exports = function(deployer) {
    deployer.deploy(erc20Token, 10000, "TotalSem Token", 18, "TST");
    deployer.deploy(supplyChain);
}