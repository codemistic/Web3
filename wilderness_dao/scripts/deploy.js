const { ethers } = require("hardhat");

async function main() {
    const MemberContract = await ethers.getContractFactory("Member");
    const deployedMemberContract = await MemberContract.deploy(10);
    await deployedMemberContract.deployed();
    console.log(
        "Member Contract Address:",
        deployedMemberContract.address
    );
}

main().then(() => process.exit(0)).catch((error) => {
        console.error(error);
        process.exit(1);
    });


