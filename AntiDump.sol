// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AntiDumpHook {
    event BlockedDump(address attacker, uint256 amount);
    event BigWhale(address trader, uint256 reward);

    function beforeSwap(address swapper, uint256 amountETH) external {
        if (amountETH < 1 ether) {
            emit BlockedDump(swapper, amountETH); // Log attackers
            revert("Swap too small!");
        } else if (amountETH > 5 ether) {
            emit BigWhale(swapper, amountETH / 100); // Reward 1% of trade
        }
    }
}