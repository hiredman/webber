var W = window.W;

var line_count = 0;

var buffer_list = [];

function foo(){
    var buf = document.getElementById("io");
    var lines = buf.value.split("\n");
    var newlines = lines.slice(line_count, lines.length).join("\n");
    buf.value+="\n";
    try {
        buf.value+=eval(newlines);
    } catch (err) {
        buf.value+=err;
    }
    buf.value+="\n";
    var lines = buf.value.split("\n");
    line_count = lines.length;
    line_count--;
    buf.scrollTop=buf.scrollHeight;
    return false;
}

function onNewLine(event){
  if(event.keyCode == 13) {
    foo();
    return false;
  } else
    return true;
}

function go(url){
    W.runJS_code_(buffer_list[0],"location.href=\""+url+"\"");
}

function new_buffer () {
    var cur = buffer_list [0];
    buffer_list.unshift (W.createWebView ());
    if (cur != null) 
        W.removeSubview_ (cur);
    W.addSubview_ (buffer_list [0]);
    
}
