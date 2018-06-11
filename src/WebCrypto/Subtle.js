exports.encryptImpl = function(algorithm, key, data) {
    return crypto.subtle.encrypt(algorithm, key, data);
};

exports.decryptImpl = function(algorithm, key, data) {
    return crypto.subtle.decrypt(algorithm, key, data);
};

exports.showArrayBufferImpl = function(arrayBuffer) {
    const decoder = new TextDecoder();
    const bytes = new Uint8Array(arrayBuffer);
    return decoder.decode(bytes);
};
