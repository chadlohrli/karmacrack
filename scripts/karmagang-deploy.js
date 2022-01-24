async function main() {
  let KG = await ethers.getContractFactory("KarmaGang");
  let kg = await KG.deploy();
  await kg.deployed();

  console.log("KG deployed to:", kg.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });