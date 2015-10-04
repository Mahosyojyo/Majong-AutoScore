function $q(pattern, idx) { //jQuery辅助函数
    return $(pattern + ":eq(" + idx + ')');
}

function clone(myObj) { //deep copy of object
    if (typeof (myObj) != 'object' || myObj == null) return myObj;
    var newObj = new Object();
    for (var i in myObj) {
        newObj[i] = clone(myObj[i]);
    }
    return newObj;
}

function randomOrder(targetArray) {
    var arrayLength = targetArray.length
    var tempArray1 = new Array();
    for (var i = 0; i < arrayLength; i++) {
        tempArray1[i] = i
    }
    var tempArray2 = new Array();
    for (var i = 0; i < arrayLength; i++) {
        tempArray2[i] = tempArray1.splice(Math.floor(Math.random() * tempArray1.length), 1)
    }
    var tempArray3 = new Array();
    for (var i = 0; i < arrayLength; i++) {
        tempArray3[i] = targetArray[tempArray2[i]]
    }
    return tempArray3
}