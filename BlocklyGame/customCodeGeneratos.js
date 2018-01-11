Blockly.JavaScript['custom_say'] = function(block) {
    var value = Blockly.JavaScript.valueToCode(block, 'string', Blockly.JavaScript.ORDER_Member) || '\'\'';
    return 'JSHandler.say(' + value + ');\n';
};

Blockly.JavaScript['custom_changebgcolor'] = function(block) {
    var value = Blockly.JavaScript.valueToCode(block, 'color', Blockly.JavaScript.ORDER_Member) || '\'#000000\'';
    return 'JSHandler.changeBGColor(' + value + ');\n';
};
