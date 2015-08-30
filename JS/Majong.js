var playerName = ['Aさん', 'Bさん', 'Cさん', 'Dさん'];
var PointLeft = [25000, 25000, 25000, 25000];
$(document).ready(
    function () {
        $('input').bind('change', EditPlayerName);
        UpdateUserName();

        $('#myonoffswitch').change(ChangePointShowMode);
        ShowPoint(false);
    }
);

function ShowPoint(DiffMode) {
    for (var i = 0; i < 4; i++) {
        if (DiffMode) {
            $('.playerscore', $('.playerinfoarea')[i]).text(PointLeft[i] - PointLeft[0] * (i != 0));
        } else {
            $('.playerscore', $('.playerinfoarea')[i]).text(PointLeft[i]);
        }
    }
}

function ChangePointShowMode() {
    ShowPoint(!$(this).is(':checked'))
}

function EditPlayerName() {
    for (var i = 0; i < 4; i++) {
        playerName[i] = $('#playerName input')[i].value;
    }
    UpdateUserName();
}

function UpdateUserName() {
    for (var i = 0; i < 4; i++) {
        $("#playerName  input")[i].value = playerName[i];
        $('.playername', $('.playerinfoarea')[i]).text(playerName[i]);
        $('#randpos input')[i].value = playerName[i];
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