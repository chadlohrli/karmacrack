const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Karmacrack Test", function () {

  let karmagang;
  let factory;
  let owner;

  beforeEach(async function () {
    let KarmaGang = await ethers.getContractFactory("KarmaGang");
    karmagang = await KarmaGang.deploy();

    let Factory = await ethers.getContractFactory("Factory");
    factory = await Factory.deploy();
  })  

  describe("Test Factory Address", function() {
    
    it("should generate expected create2 address", async function() {
      let testBytecodeHash = "0x3d62012120f6a3aa34878aa91e0c7cf72d5ffc0e8f46cceebef78f45d05844f2";
      let testFactoryAddress = "0xEd2cf286D2DaA16cE4B34b6029F805647309426C";
      let expectedAddress = "0xc0De423eA0845A6a4216A4462C89CFb7e7C6345e";

      let address = await factory.getAddress_(testBytecodeHash, testFactoryAddress, 28683371);
      expect(address).to.equal(expectedAddress);
    })
  })
});