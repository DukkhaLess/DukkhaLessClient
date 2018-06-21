exports.encodeStringToBuffer = function(str) {
    return (new TextEncoder('utf-8')).encode(str).buffer;
};

exports.decodeBufferToString = async function(buffer) {
    return (new TextDecoder('utf-8').decode(buffer));
};
