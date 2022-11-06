pragma circom 2.1.0;
include "./secp256k1_scalar_mult_cached_windowed.circom";

template ECDSA(n, k) {
    signal input s[k];
    signal input TPreComputes[65536]; // T = r^-1 * R
    signal input U[2*k]; // -(m * r^-1 * G)
    signal output pubKey[2*k];

    // s * T
    // or, s * r^-1 * R
    component sMultT = Secp256K1ScalarMultCachedWindowed(n, k);
    var stride = 8;
    var num_strides = div_ceil(n * k, stride);

    for (var i = 0; i < num_strides; i++) {
        for (var j = 0; j < 2 ** stride; j++) {
            for (var l = 0; l < k; l++) {
                sMultT.pointPreComputes[i][j][0][l] <== TPreComputes[2048*i + 8*j + 0*4 + l];
                sMultT.pointPreComputes[i][j][1][l] <== TPreComputes[2048*i + 8*j + 1*4 + l];
            }
        }
    }

      for (var i = 0; i < k; i++) {
        sMultT.scalar[i] <== s[i];
    }

    // s * T + U
    // or, s * r^-1 * R + -(m * r^-1 * G)
    component pointAdder = Secp256k1AddUnequal(n, k);
    for (var i = 0; i < k; i++) {
        pointAdder.a[0][i] <== sMultT.out[0][i];
        pointAdder.a[1][i] <== sMultT.out[1][i];
        pointAdder.b[0][i] <== U[0*4 + i];
        pointAdder.b[1][i] <== U[1*4 + i];
    }

    for (var i = 0; i < k; i++) {
        pubKey[0*4 + i] <== pointAdder.out[0][i];
        pubKey[1*4 + i] <== pointAdder.out[1][i];
    }
}
