const fs = require('fs');

async function main() {
  var data = fs.readFileSync('./scripts/data.json');
  data = JSON.parse(data);
  const salt = data['salt'];
  const kgAddress = data["kgAddress"]

  console.log("salt", salt);
  console.log("kgAddress", kgAddress);
    
  // deploy factory
  let Factory = await ethers.getContractFactory("Factory");
  let factory = await Factory.deploy();
  await factory.deployed();

  console.log("Factory deployed to:", factory.address);

  let byteCode = await factory.getBytecode(kgAddress);
  let create2Address = await factory.getAddress(byteCode, salt);
  
  console.log("create2Address:", create2Address);

  let deploy = await factory.deploy(byteCode, salt, {value: 0});
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
