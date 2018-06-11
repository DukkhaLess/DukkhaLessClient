exports.encryptImpl = function(algorithm, key, data) {
    return crypto.subtle.encrypt(algorithm, key, data);
};

exports.decryptImpl = function(algorithm, key, data) {
    return crypto.subtle.decrypt(algorithm, key, data);
};
