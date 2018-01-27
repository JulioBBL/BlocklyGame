var isPlaying = false;

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
    
    
    // Add an API function for the changeSquareColor() block.
    wrapper = function(color) {
        color = color ? color.toString() : '';
        return interpreter.createPrimitive(JSHandler.changeSquareColor(color));
    };
    interpreter.setProperty(scope, 'changeSquareColor', interpreter.createNativeFunction(wrapper));
    
    
    // Add an API function for the moveForward() block.
    wrapper = function() {
        return interpreter.createPrimitive(JSHandler.moveForward());
    };
    interpreter.setProperty(scope, 'moveForward', interpreter.createNativeFunction(wrapper));
    
    
    // Add an API function for the rotate() block.
    wrapper = function(direction) {
        direction = direction || '';
        return interpreter.createPrimitive(JSHandler.rotate(direction));
    };
    interpreter.setProperty(scope, 'rotate', interpreter.createNativeFunction(wrapper));
    
    
    // Add an API function for the canGo() block.
    wrapper = function(direction) {
        direction = direction ? direction.toString() : '';
        return interpreter.createPrimitive(JSHandler.canGo(direction));
    };
    interpreter.setProperty(scope, 'canGo', interpreter.createNativeFunction(wrapper));
    
    
    // Add an API function for the hasFinished() block.
    wrapper = function() {
        return interpreter.createPrimitive(JSHandler.hasFinished());
    };
    interpreter.setProperty(scope, 'hasFinished', interpreter.createNativeFunction(wrapper));
}

function stepInterpretedCode(code) {
    var myInterpreter = new Interpreter(code, initApi);
    
    function nextStep() {
        if (isPlaying && myInterpreter.step()) {
            JSHandler.setTimeout(30);
            nextStep();
        }
    }
    
    nextStep();
}
