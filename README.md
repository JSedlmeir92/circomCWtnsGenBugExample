# How to reproduce the segmentation fault when using C++ based withness generation

Make sure to clone the repository recursively or to copy the latest version of the circomlib into the top level of the project

```./bootstrap.sh```

The script should demonstrate that wasm/node-based witness generation succeeds, while c++-based witness generation causes a segmentation fault

The segmentation fault can be resolved by editing CheckCarryToZero_22_run in circuit_cpp/circuit.cpp, line 57333 (remove the release_memory_component call). After doing so, compile with ```make``` and retry (e.g., by running ```./generateWtnsWithCpp.sh```).
This time, a valud witness should be generated with C++.

Versions: 
- circom: 2.1.0 
- snarkjs: 0.5.0
