pragma solidity ^0.5.0.0;

import "./SFC.sol";
import "../erc20/base/ERC20Burnable.sol";
import "../erc20/base/ERC20Mintable.sol";
import "../common/Initializable.sol";

contract Spacer {
    address private _owner;
}

contract StakeTokenizer is Spacer, Initializable {
    SFC internal sfc;

    mapping(address => mapping(uint256 => uint256)) public outstandingSsesa;

    address public ssesaTokenAddress;

    function initialize(address payable _sfc, address _ssesaTokenAddress) public initializer {
        sfc = SFC(_sfc);
        ssesaTokenAddress = _ssesaTokenAddress;
    }

    function mintSsesa(uint256 toValidatorID) external {
        revert("ssesa minting is disabled");
//        address delegator = msg.sender;
//        uint256 lockedStake = sfc.getLockedStake(delegator, toValidatorID);
//        require(lockedStake > 0, "delegation isn't locked up");
//        require(lockedStake > outstandingSsesa[delegator][toValidatorID], "ssesa is already minted");
//
//        uint256 diff = lockedStake - outstandingSsesa[delegator][toValidatorID];
//        outstandingSsesa[delegator][toValidatorID] = lockedStake;
//
//        // It's important that we mint after updating outstandingSsesa (protection against Re-Entrancy)
//        require(ERC20Mintable(ssesaTokenAddress).mint(delegator, diff), "failed to mint ssesa");
    }

    function redeemSsesa(uint256 validatorID, uint256 amount) external {
        require(outstandingSsesa[msg.sender][validatorID] >= amount, "low outstanding ssesa balance");
        require(IERC20(ssesaTokenAddress).allowance(msg.sender, address(this)) >= amount, "insufficient allowance");
        outstandingSsesa[msg.sender][validatorID] -= amount;

        // It's important that we burn after updating outstandingSsesa (protection against Re-Entrancy)
        ERC20Burnable(ssesaTokenAddress).burnFrom(msg.sender, amount);
    }

    function allowedToWithdrawStake(address sender, uint256 validatorID) public view returns(bool) {
        return outstandingSsesa[sender][validatorID] == 0;
    }
}
