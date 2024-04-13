// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IPaymaster.sol";
import "../libraries/EIP712.sol";
import "../libraries/ECDSA.sol";

contract TestPaymaster is IPaymaster, EIP712 {
    struct SignData {
        bytes32 suggestedSignedHash;
    }

    address public owner;

    constructor(string memory name, string memory version) EIP712(name, version) {
        owner = msg.sender;
    }

    function signDataTypeHash() internal pure returns (bytes32) {
        return keccak256("SignData(bytes32 suggestedSignedHash)");
    }

    function signDataMessage(bytes32 suggestedSignedHash) internal view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(
            signDataTypeHash(),
            suggestedSignedHash
        )));
    }

    function validateAndPayForPaymasterTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        bytes memory _authenticationSignature,
        Transaction calldata _transaction
    ) external payable returns (bytes4 magic, bytes memory context) {
        if (_suggestedSignedHash == 0x0) {
            return (0x00000001, context);
        } else {
            require(_suggestedSignedHash != bytes32(uint256(1)), "Paymaster: Test revert");
        }
        return (PAYMASTER_VALIDATION_SUCCESS_MAGIC, context);
    }

    function postTransaction(
        bytes calldata _context,
        Transaction calldata _transaction,
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        ExecutionResult _txResult,
        uint256 _maxRefundedGas
    ) external payable {

    }
}