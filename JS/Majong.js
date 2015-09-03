var playerName = ['Aさん', 'Bさん', 'Cさん', 'Dさん'];
var PointLeft = [25000, 25000, 25000, 25000];
var jushu = 1;//局数
var changfeng = '东';//场风
var benchang = 0;//本场数

var rong_flag = [false,false,false,false];
var dianpao_flag = [false,false,false,false];

$(document).ready(
    function () {
        $('input').bind('change', EditPlayerName);
        UpdateUserName();

        $('#myonoffswitch').change(ChangePointShowMode);
        ShowPoint(false);
        
        UpdateGameProcess();
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

function UpdateGameProcess()
{
    var chn = ['一','二','三','四'];
    $("#changkuang").text(changfeng+chn[jushu-1]+'局');
    $("#benchangshu").text(benchang+'本场');
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

function rong_click(idx)
{
    rong_flag[idx] = !rong_flag[idx];
    if(rong_flag[idx] == false)
    {
        $("#player"+idx+"_rong")[0].value = "胡牌";
        $("#player"+idx+"_rong").removeClass('t_btn_click');
    }
    else{
        $("#player"+idx+"_rong")[0].value = "取消";
        $("#player"+idx+"_rong").addClass('t_btn_click');
        if(dianpao_flag[idx] == true)
        {
            $("#player"+idx+"_dianpao")[0].value = "点炮";
            $("#player"+idx+"_dianpao").removeClass('t_btn_click');
            dianpao_flag[idx] = false;
        }
    }
}

function dianpao_click(idx)
{
    dianpao_flag[idx] = !dianpao_flag[idx];
    if(dianpao_flag[idx] == false)
    {
        $("#player"+idx+"_dianpao")[0].value = "点炮";
        $("#player"+idx+"_dianpao").removeClass('t_btn_click');
    }
    else{
        $("#player"+idx+"_dianpao")[0].value = "取消";
        $("#player"+idx+"_dianpao").addClass('t_btn_click');
        if(rong_flag[idx] == true)
        {
            $("#player"+idx+"_rong")[0].value = "胡牌";
            $("#player"+idx+"_rong").removeClass('t_btn_click');
            rong_flag[idx] = false;
        }
    }
}