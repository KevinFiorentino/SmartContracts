//2_initial_migration.js
const CrowdFunding = artifacts.require("CrowdFunding");

module.exports = function (deployer) {
  deployer.deploy(CrowdFunding);
};