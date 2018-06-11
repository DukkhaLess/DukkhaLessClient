exports.encryptImpl = function(algorithm, key, data) {
    return crypto.subtle.encrypt(algorithm, key, data);
};
