var playerName = ['Aさん','Bさん','Cさん','Dさん'];

$(document).ready(
    function(){
        $('input').bind('change',EditPlayerName)
        UpdateUserName();
    }
);

function EditPlayerName()
{
    for(var i = 0;i < 4;i++)
    {
        playerName[i] = $('input',$('form',$("#playerName")))[i].value;
    }
    UpdateUserName();
}

function UpdateUserName()
{
    for(var i = 1;i <= 4;i++)
    {
        $('input',$('form',$("#playerName")))[i-1].value = playerName[i-1];
        $('.playername',$('.playerinfoarea',$('#gamearea'))[i-1]).text(playerName[i-1]);
        $('input',$('form',$('#randpos')))[i-1].value = playerName[i-1];
    }
}


//随机换座位
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
    playerName = randomOrder(playerName)
    UpdateUserName();
}