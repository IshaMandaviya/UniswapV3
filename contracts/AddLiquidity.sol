// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.7.6;
pragma abicoder v2;
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import '@uniswap/v3-core/contracts/libraries/TickMath.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/base/LiquidityManagement.sol';
contract AddLiquidity is IERC721Receiver {
    // address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public tokenA;
    address public tokenB;
    uint24 public constant poolFee = 3000;

    INonfungiblePositionManager public immutable nonfungiblePositionManager;
    constructor(INonfungiblePositionManager _nonfungiblePositionManager,address _tokenA,address _tokenB) {
        nonfungiblePositionManager = _nonfungiblePositionManager;
        tokenA=_tokenA;
        tokenB=_tokenB;
    }
    function _addLiquidity(uint256 amountA,uint256 amountB) public
    {
        TransferHelper.safeTransferFrom(tokenA,msg.sender, address(this), amountA);
        TransferHelper.safeTransferFrom(tokenB,msg.sender, address(this), amountB);
        TransferHelper.safeApprove(tokenA, address(nonfungiblePositionManager), amountA);
        TransferHelper.safeApprove(tokenB, address(nonfungiblePositionManager), amountB);

        INonfungiblePositionManager.MintParams memory params =
            INonfungiblePositionManager.MintParams({
                token0: tokenA,
                token1: tokenB,
                fee: poolFee,
                tickLower: TickMath.MIN_TICK,
                tickUpper: TickMath.MAX_TICK,
                amount0Desired: amountA,
                amount1Desired: amountB,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp
            });

         nonfungiblePositionManager.mint(params);

        
    }
    function onERC721Received(
        address operator,
        address,
        uint256 tokenId,
        bytes calldata
    ) external override returns (bytes4) {
        // get position information

        

        return this.onERC721Received.selector;
    }
}