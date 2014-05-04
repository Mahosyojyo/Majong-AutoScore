function nTabs(thisObj, Num) {
    if (thisObj.className == "active") return;
    var tabObj = thisObj.parentNode.id;
    var tabList = document.getElementById(tabObj).getElementsByTagName("li");
    for (i = 0; i < tabList.length; i++) {
        if (i == Num) {
            thisObj.className = "active";
            document.getElementById(tabObj + "_Content" + i).style.display = "block";
        } else {
            tabList[i].className = "normal";
            document.getElementById(tabObj + "_Content" + i).style.display = "none";
        }
    }
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
    //
    var tempArray3 = new Array();

    for (var i = 0; i < arrayLength; i++) {
        tempArray3[i] = targetArray[tempArray2[i]]
    }

    return tempArray3
}


function make_random_position() {
    var origin_pos = ["东", "南", "西", "北"];
    newpos = randomOrder(origin_pos)
    for (i = 1; i <= 4; i++) {
        playerName = document.getElementsByName("Player" + i + "Name")[0].value;
        document.getElementsByName("Player" + i + "Name_pos")[0].value = playerName;
        document.getElementById("player" + i + "_random_pos").innerHTML = newpos[i - 1];

    }

}

function update_position() {
    //反向更新座位
    alert("未开发")
}