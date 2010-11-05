function range(first, last) {
  var arr = [];

  for(var i=first; i <= last; i=i+1) {
    arr.push(i);
  }

  return arr;
}


function changeFileName(name, replaceWith) {
  return name.replace(/^.+(\.\w+)$/, function() {
    return replaceWith + RegExp.$1
  });
}

function isBlank(value) {
  switch (typeOf(value)) {
    case 'string':
      return value == '';
      break;
    case 'array':
      return value.length == 0;
      break;
    case 'null':
      return true;
      break;
  }
}

function typeOf(obj) {
  if (obj == null) {
    return 'null';
  }

  if (typeof(obj) == 'object') {
    return (obj.length != null ? 'array' : 'object');
  } else {
    return typeof(obj);
  }
}

function getRand() {
  return parseInt(Math.random(10000) * 10000);
}
