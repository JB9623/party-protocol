// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8;

import "./LibRawResult.sol";

interface IReadOnlyDelegateCall {
    // Marked `view` so that `_readOnlyDelegateCall` can be `view` as well.
    function delegateCallAndRevert(address impl, bytes memory callData)
        external
        view;
}

// Performs read-only delegate calls.
contract ReadOnlyDelegateCall {
    using LibRawResult for bytes;

    // Delegatecall into impl and revert with the raw result.
    function delegateCallAndRevert(address impl, bytes memory callData)
        external
    {
        // Attempt to gate to only `_readOnlyDelegateCall()` invocations.
        require(msg.sender == address(this));
        (bool s, bytes memory r) = impl.delegatecall(callData);
        // Revert with success status and return data.
        abi.encode(s, r).rawRevert();
    }

    // Perform a delegateCallAndRevert() then return the raw result data.
    function _readOnlyDelegateCall(address impl, bytes memory callData)
        internal
        view
    {
        try IReadOnlyDelegateCall(address(this)).delegateCallAndRevert(impl, callData) {
            // Should never happen.
            assert(false);
        }
        catch (bytes memory r) {
            (bool success, bytes memory resultData) = abi.decode(r, (bool, bytes));
            if (!success) {
                resultData.rawRevert();
            }
            resultData.rawReturn();
        }
    }
}
