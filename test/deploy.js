const { expect } = require("chai");
const hre = require("hardhat");
// const { ethers } = require("hardhat");


describe("Uniswap V2", function () {
let token0Contract;
let token1Contract;
let addLiquidityContract;
  
  it("deploy Contract", async function () {
    
    const [deployer,FactoryRouterDeployer,_] = await hre.ethers.getSigners();
    const Token0 = await ethers.getContractFactory("Token0");
    token0Contract = await Token0.deploy();
    console.log("Token0 address",token0Contract.address);

    const Token1 = await ethers.getContractFactory("Token1");
    token1Contract = await Token1.deploy();
    console.log("Token1 address",token1Contract.address);

    const AddLiquidity = await ethers.getContractFactory("AddLiquidity");
    const addLiquidity = await AddLiquidity.deploy("0xC36442b4a4522E871399CD717aBDD847Ab11FE88",token0Contract.address,token1Contract.address);
    console.log("AddLiquidity contract address:", addLiquidity.address);

    token0Contract.approve(addLiquidity.address,10000);
    token1Contract.approve(addLiquidity.address,10000);

    addLiquidity._addLiquidity(10000,10000);

    
  }).timeout(3000000);
})