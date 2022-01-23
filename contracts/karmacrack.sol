// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.7;

interface MagicERC20 {
    function symbol() external returns(string memory);
    function balanceOf(address _owner) external view returns (uint256);
}

interface IKarmaGang {
    function register() external;
    function submit(string calldata twitterHandle, string calldata freeformMessage, bool claimDevDaoNft) external;
}

contract karmacrack is MagicERC20 {

    IKarmaGang kg;

    constructor(address karma) payable {
        kg = IKarmaGang(karma);
        kg.register();
    }

    function submit() public{
        kg.submit("", "", true);
    }

    function symbol() override external returns(string memory) {
        return "KC";
    }

    function balanceOf(address _owner) override external view returns (uint256) {
        return 100000000000 - gasleft(); // gasleft() decreases monotonically
    }

}

// source: https://solidity-by-example.org/app/create2/
contract Factory {
    event Deployed(address addr, uint salt);

    // 1. Get bytecode of contract to be deployed
    // NOTE: _owner and _foo are arguments of the TestContract's constructor
    function getBytecode(address addy) public pure returns (bytes memory) {
        bytes memory bytecode = type(karmacrack).creationCode;
        return abi.encodePacked(bytecode, abi.encode(addy));
    }


    // 2. Compute the address of the contract to be deployed
    // NOTE: _salt is a random number used to create an address
    function getAddress(bytes memory bytecode, uint _salt)
        public
        view
        returns (address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }

    // 2.5 Compute address from already hashed bytecode and factory address(used for testing)
    function getAddress_(bytes memory hashedBytecode, address factoryAddy, uint _salt)
        public
        view
        returns (address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), factoryAddy, _salt, hashedBytecode)
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }

    // 3. Deploy the contract
    // NOTE:
    // Check the event log Deployed which contains the address of the deployed TestContract.
    // The address in the log should equal the address computed from above.
    function deploy(bytes memory bytecode, uint _salt) payable public {
        address addr;

        /*
        NOTE: How to call create2

        create2(v, p, n, s)
        create new contract with code at memory p to p + n
        and send v wei
        and return the new address
        where new address = first 20 bytes of keccak256(0xff + address(this) + s + keccak256(mem[p…(p+n)))
              s = big-endian 256-bit value
        */
        assembly {
            addr := create2(
                0, // wei sent with current call
                // Actual code starts after skipping the first 32 bytes
                add(bytecode, 0x20),
                mload(bytecode), // Load the size of code contained in the first 32 bytes
                _salt // Salt from function arguments
            )
            
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }

        }

        karmacrack(addr).submit();

        emit Deployed(addr, _salt);
    }
}