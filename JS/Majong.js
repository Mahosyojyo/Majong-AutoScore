var playerName = ['Aさん', 'Bさん', 'Cさん', 'Dさん'];
var PointLeft = [25000, 25000, 25000, 25000];
var jushu = 1; //局数
var changfeng = '东'; //场风
var benchang = 0; //本场数

var rong_flag = [false, false, false, false];
var dianpao_flag = [false, false, false, false];
var lichi_flag = [false, false, false, false];
var mainView = 0; //点差模式下主视角

function $q(pattern, idx) { //jQuery辅助函数
    return $(pattern + ":eq(" + idx + ')');
}

$(document).ready(
    function () {
        $('input').bind('change', EditPlayerName);
        UpdateUserName();

        $('#myonoffswitch').change(ChangePointShowMode);
        ShowPoint(false);

        UpdateAllView();
    }
);

function UpdateAllView() {
    ChangePointShowMode(); //更新点差显示模式
    UpdateGameProcess(); //更新右上角进度
    UpdateFengwei(); //更新风位
    UpdateRank(); //更新顺位
}

function sortRank(a,b)
{
    /*同分逻辑需要重写，高位同分首庄开始算起(已完成)，地位同分离高位近的开始算起！！*/
    return PointLeft[a] < PointLeft[b] || b<a;
}

function UpdateRank() {
    var ori = [0,1,2,3];
    ori = ori.sort(sortRank);
    for(var i = 0;i < 4;i++)
    {
        $q('.weici',ori[i]).text(i+1+'位');
    }
}

function ShowPoint(DiffMode) {
    for (var i = 0; i < 4; i++) {
        if (DiffMode) {
            $('.playerscore', $('.playerinfoarea')[i]).text(PointLeft[i] - PointLeft[mainView] * (i != mainView));
        } else {
            $('.playerscore', $('.playerinfoarea')[i]).text(PointLeft[i]);
        }
    }
}

function UpdateFengwei() //更新风位
{
    $q('.playerpos', (jushu + 3) % 4).text('东');
    $q('.playerpos', (jushu + 4) % 4).text('南');
    $q('.playerpos', (jushu + 5) % 4).text('西');
    $q('.playerpos', (jushu + 6) % 4).text('北');

}

function ChangePointShowMode() {
    $('.playerpos').not(function (id) {
        return id == mainView
    }).removeClass('mainviewcl');
    $q('.playerpos', mainView).addClass('mainviewcl');
    ShowPoint(!$("#myonoffswitch").is(':checked'));
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

function UpdateGameProcess() {
    var chn = ['一', '二', '三', '四'];
    $("#changkuang").text(changfeng + chn[jushu - 1] + '局');
    $("#benchangshu").text(benchang + '本场');
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

function rong_click(idx) {
    rong_flag[idx] = !rong_flag[idx];
    if (rong_flag[idx] == false) {
        $("#player" + idx + "_rong")[0].value = "胡牌";
        $("#player" + idx + "_rong").removeClass('t_btn_click');
    } else {
        $("#player" + idx + "_rong")[0].value = "取消";
        $("#player" + idx + "_rong").addClass('t_btn_click');
        if (dianpao_flag[idx] == true) {
            $("#player" + idx + "_dianpao")[0].value = "点炮";
            $("#player" + idx + "_dianpao").removeClass('t_btn_click');
            dianpao_flag[idx] = false;
        }
    }
}

function dianpao_click(idx) {
    dianpao_flag[idx] = !dianpao_flag[idx];
    if (dianpao_flag[idx] == false) {
        $("#player" + idx + "_dianpao")[0].value = "点炮";
        $("#player" + idx + "_dianpao").removeClass('t_btn_click');
    } else {
        $("#player" + idx + "_dianpao")[0].value = "取消";
        $("#player" + idx + "_dianpao").addClass('t_btn_click');
        if (rong_flag[idx] == true) {
            $("#player" + idx + "_rong")[0].value = "胡牌";
            $("#player" + idx + "_rong").removeClass('t_btn_click');
            rong_flag[idx] = false;
        }
    }
}

function lichi_click(idx)
{
    lichi_flag[idx] = !lichi_flag[idx];
    lichi_flag[idx] ? $q('.playerinfoarea',idx).addClass("lichi") : $q('.playerinfoarea',idx).removeClass("lichi");
}

function changeView(idx) {
    mainView = idx;
    ChangePointShowMode();
}