#!/bin/bash 

echo "Witness generation with C++"
rm circuit_cpp/witness.wtns || echo "Nothing to delete so far"
./circuit_cpp/circuit input.json circuit_cpp/witness.wtns
echo "Checking the witness"
stat circuit_cpp/witness.wtns || echo "No witness was created" && exit
snarkjs wtns debug circuit_js/circuit.wasm input.json circuit_cpp/witness.wtns circuit.sym && echo "Witess is ok" || echo "Witness is not ok"