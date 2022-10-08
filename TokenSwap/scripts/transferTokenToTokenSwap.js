const { ethers, network}= require("hardhat")
const { INITIAL_SUPPLY } = require("../helper-hardhat-config")

async function transferTokens(){
    const tokenSwap= await ethers.getContract("TokenSwap")
    const smpToken= await ethers.getContract("SampleToken")
    const tx= await smpToken.transfer (tokenSwap.address, INITIAL_SUPPLY)
    await tx.wait(1)
    console.log("TokenSwap contract now has all available tokens")
    
}

transferTokens()
    .then(()=> process.exit(0))
    .catch((error)=>{
        console.log(error)
        process.exit(1)
    })