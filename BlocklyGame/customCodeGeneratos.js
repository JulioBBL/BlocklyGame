Blockly.JavaScript.STATEMENT_PREFIX = 'highlightBlock(%1);\n';
Blockly.JavaScript.addReservedWords('highlightBlock');

Blockly.JavaScript['custom_say'] = function(block) {
    var value = Blockly.JavaScript.valueToCode(block, 'string', Blockly.JavaScript.ORDER_MEMBER) || '\'\'';
    return 'say(' + value + ');\n';
};

Blockly.JavaScript['custom_changebgcolor'] = function(block) {
    var value = Blockly.JavaScript.valueToCode(block, 'color', Blockly.JavaScript.ORDER_MEMBER) || '\'#000000\'';
    return 'changeBackgroundColor(' + value + ');\n';
};
