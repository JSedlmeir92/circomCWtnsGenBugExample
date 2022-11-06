#!/bin/bash

echo "Compiling the circuit"
circom circuit.circom --wasm --r1cs --c --sym
cd circuit_cpp && make && cd ..

echo ""
echo "Witness generation with node/wasm"
rm circuit_js/witness.wtns || echo "Nothing to delete so far"
node circuit_js/generate_witness.js circuit_js/circuit.wasm input.json circuit_js/witness.wtns
echo "Checking the witness"
stat circuit_cpp/witness.wtns || echo "No witness was created" && exit
snarkjs wtns debug circuit_js/circuit.wasm input.json circuit_js/witness.wtns circuit.sym && echo "Witness is ok" || echo "Witness is not ok"

echo ""
echo "Witness generation with C++"
rm circuit_cpp/witness.wtns || echo "Nothing to delete so far"
./circuit_cpp/circuit input.json circuit_cpp/witness.wtns
echo "Checking the witness"
stat circuit_cpp/witness.wtns || echo "No witness was created" && exit
snarkjs wtns debug circuit_js/circuit.wasm input.json circuit_cpp/witness.wtns circuit.sym && echo "Witess is ok" || echo "Witness is not ok"