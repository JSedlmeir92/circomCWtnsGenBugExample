pragma circom 2.1.0;
include "./circom-ecdsa-circuits/ecdsa.circom";
component main { public [TPreComputes, U] } = ECDSA(64, 4);
