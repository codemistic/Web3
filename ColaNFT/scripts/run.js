const hre = require("hardhat");

async function main() {
  const ColaNFT = await hre.ethers.getContractFactory("ColaNFT");
  const cola = await ColaNFT.deploy();

  await cola.deployed();

  console.log("ColaNFT deployed to:", cola.address);

  let txn = await cola.mintNFT();
  await txn.wait();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
