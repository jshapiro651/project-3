const LimitOrder = artifacts.require("LimitOrder")

module.exports = async function (deployer) {
    await deployer.deploy(LimitOrder)
};