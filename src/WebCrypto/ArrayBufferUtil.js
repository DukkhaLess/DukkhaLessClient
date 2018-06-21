exports.encodeStringToBuffer = function(str) {
    return (new TextEncoder('utf-8')).encode(str).buffer;
};

exports.decodeBufferToString = async function(buffer) {
    return (new TextDecoder('utf-8').decode(buffer));
};

exports.base64EncodeBuffer = function(buffer) {
    const reducer = function(a, n) {
        return a.push(String.fromCharCode(n));
    };
    const arr = new Array();
    return btoa(buffer.reduce(reducer, arr).join(''));
};

exports.base64DecodeImpl = async function(str) {
    var i = 0;
    const byteString = atob(str);
    var ns = new Uint8Array(byteString.length);
    for(i = 0; i < ns.length; i ++) {
        ns[i] = byteString.charCodeAt(i);
    }
    return ns;
};
