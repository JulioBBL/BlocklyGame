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

Blockly.JavaScript['custom_change_square_color'] = function(block) {
    var value = Blockly.JavaScript.valueToCode(block, 'color', Blockly.JavaScript.ORDER_MEMBER) || '\'#000000\'';
    return 'changeSquareColor(' + value + ');\n';
};

Blockly.JavaScript['movement_forward'] = function(block) {
    return 'moveForward();\n';
};

Blockly.JavaScript['movement_rotate'] = function(block) {
    var dropdown_name = block.getFieldValue('DIRECTION') || '\'\'';
    var code = 'rotate(\'' + dropdown_name + '\');\n';
    return code;
};

Blockly.JavaScript['movement_check_path'] = function(block) {
    var dropdown_name = block.getFieldValue('DIRECTION') || '\'\'';
    var code = 'canGo(\'' + dropdown_name + '\')';
    return [code, Blockly.JavaScript.ORDER_NONE];
};

Blockly.JavaScript['check_completion'] = function(block) {
    var code = 'hasFinished()';
    return [code, Blockly.JavaScript.ORDER_NONE];
};
