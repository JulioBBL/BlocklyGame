var playing = true

function initApi(interpreter, scope) {
    // Add an API function for highlighting blocks.
    var wrapper = function(id) {
        id = id ? id.toString() : '';
        return interpreter.createPrimitive(JSHandler.highlightBlock(id));
    };
    interpreter.setProperty(scope, 'highlightBlock', interpreter.createNativeFunction(wrapper));
    
    
    // Add an API function for the say() block.
    wrapper = function(text) {
        text = text ? text.toString() : '';
        return interpreter.createPrimitive(JSHandler.say(text));
    };
    interpreter.setProperty(scope, 'say', interpreter.createNativeFunction(wrapper));
    
    
    // Add an API function for the changeBackgroundColor() block.
    wrapper = function(color) {
        color = color ? color.toString() : '';
        return interpreter.createPrimitive(JSHandler.changeBackgroundColor(color));
    };
    interpreter.setProperty(scope, 'changeBackgroundColor', interpreter.createNativeFunction(wrapper));
}

function stepInterpretedCode(code) {
    var myInterpreter = new Interpreter(code, initApi);
    
    function nextStep() {
        if (playing && myInterpreter.step()) {
            JSHandler.setTimeout(30);
            nextStep();
        }
    }
    
    nextStep();
}
