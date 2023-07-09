BYTECODE=$(forge inspect src/AdoptAHyphen.sol:AdoptAHyphen bytecode)
ARGS=$(cast abi-encode "constructor(address,address)" "0x73d24948fD946AE7F20EED63D7C0680eDfaF36f1" "0x08995fAC0a721170E5f2179A1402C786f86535a3")
CALLDATA=$(cast --concat-hex "$BYTECODE" "$ARGS")
echo $CALLDATA > bytecode-with-constructor.txt
