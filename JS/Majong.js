function Game(m_jushu, m_changfeng, m_benchang) {
    this.jushu = m_jushu; //局数
    this.changfeng = m_changfeng; //场风
    this.benchang = m_benchang; //本场数
}

function Player(m_playerName, m_Point) {　　　　
    this.playerName = m_playerName;　　　　
    this.Point = m_Point;
}

var game = new Game(1, '东', 0);
var InitScore = 25000;
var player = [new Player('Aさん', InitScore), new Player('Bさん', InitScore), new Player('Cさん', InitScore), new Player('Dさん', InitScore)];

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
        $('#fanfu_ok').attr("disabled", true);
    }
);

function UpdateAllView() {
    ChangePointShowMode(); //更新点差显示模式
    UpdateGameProcess(); //更新右上角进度
    UpdateFengwei(); //更新风位
    UpdateRank(); //更新顺位
}

function sortRank(a, b) {
    /*同分逻辑需要重写，高位同分首庄开始算起(已完成)，地位同分离高位近的开始算起！！*/
    return player[a].Point < player[b].Point || b < a;
}

function UpdateRank() {
    var ori = [0, 1, 2, 3];
    ori = ori.sort(sortRank);
    for (var i = 0; i < 4; i++) {
        $q('.weici', ori[i]).text(i + 1 + '位');
    }
}

function ShowPoint(DiffMode) {
    for (var i = 0; i < 4; i++) {
        if (DiffMode) {
            $('.playerscore', $('.playerinfoarea')[i]).text(player[i].Point - player[mainView].Point * (i != mainView));
        } else {
            $('.playerscore', $('.playerinfoarea')[i]).text(player[i].Point);
        }
    }
}

function UpdateFengwei() //更新风位
{
    $q('.playerpos', (game.jushu + 3) % 4).text('东');
    $q('.playerpos', (game.jushu + 4) % 4).text('南');
    $q('.playerpos', (game.jushu + 5) % 4).text('西');
    $q('.playerpos', (game.jushu + 6) % 4).text('北');

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
        player[i].playerName = $('#playerName input')[i].value;
    }
    UpdateUserName();
}

function UpdateUserName() {
    for (var i = 0; i < 4; i++) {
        $("#playerName  input")[i].value = player[i].playerName;
        $('.playername', $('.playerinfoarea')[i]).text(player[i].playerName);
    }
}

function UpdateGameProcess() {
    var chn = ['一', '二', '三', '四'];
    $("#changkuang").text(game.changfeng + chn[game.jushu - 1] + '局');
    $("#benchangshu").text(game.benchang + '本场');
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
    var name_tmp = [player[0].playerName, player[1].playerName, player[2].playerName, player[3].playerName]
    name_tmp = randomOrder(name_tmp)
    for (var i = 0; i < 4; i++)
        player[i].playerName = name_tmp[i];
    UpdateUserName();
}

function rong_click(idx) {
    rong_flag[idx] = !rong_flag[idx];
    if (rong_flag[idx] == false) {
        $("#player" + idx + "_rong")[0].value = "自摸";
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
    Set_OKbtn_Text();
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
            $("#player" + idx + "_rong")[0].value = "自摸";
            $("#player" + idx + "_rong").removeClass('t_btn_click');
            rong_flag[idx] = false;
        }
    }

    var has_dianpao = dianpao_flag[0] || dianpao_flag[1] || dianpao_flag[2] || dianpao_flag[3];
    for (var i = 0; i < 4; i++) {
        if (rong_flag[idx] == false) {
            $("#player" + i + "_rong")[0].value = has_dianpao ? "胡牌" : "自摸";
        }
    }

}

function lichi_click(idx) {
    lichi_flag[idx] = !lichi_flag[idx];
    lichi_flag[idx] ? $q('.playerinfoarea', idx).addClass("lichi") : $q('.playerinfoarea', idx).removeClass("lichi");
}

function changeView(idx) {
    mainView = idx;
    ChangePointShowMode();
}


function Set_OKbtn_Text() {
    var text = "确定";
    $('#fanfu_ok').attr("disabled", true);
    for (var i = 0; i < 4; i++) {
        if (rong_flag[i]) {
            text += "(" + player[i].playerName + ")";
            $('#fanfu_ok').attr("disabled", false);
            break;
        }
    }
    $('#fanfu_ok')[0].value = text;
}

function Cal_BaseScore() { //基本点计算
    var fanshu_idx = -1;
    var fushu_idx = -1;
    $('#fanshu_field .fanfu_btn').each(function (idx) {
        if ($q('#fanshu_field .fanfu_btn', idx).hasClass('fanshu_clk'))
            fanshu_idx = idx;
    })
    if (fanshu_idx == -1) {
        return -1;
    }

    if (fanshu_idx < 4) { //  ≤4番
        $('#fushu_field .fanfu_btn').each(function (idx) {
            if ($q('#fushu_field .fanfu_btn', idx).hasClass('fushu_clk'))
                fushu_idx = idx;
        })
        if (fushu_idx == -1) {
            return -2;
        }
        var t = parseInt($q('#fushu_field .fanfu_btn', fushu_idx)[0].value) * Math.pow(2, fanshu_idx + 1 + 2);
        return t < 2000 ? t : 2000;

    } else {
        var score_idx = [2000, 3000, 4000, 6000]; //满贯，跳满，倍满，三倍满
        if (fanshu_idx != 8)
            return score_idx[fanshu_idx - 4];
        else
            return 8000 * parseInt($q('#fanshu_field .fanfu_btn', 8)[0].value[0]); //役满数目
    }
}

function CalScore_OK() {
    var base_score = Cal_BaseScore();
    if (base_score == -1) {
        $('#fanfu_ok')[0].value = '番数未设置';
        var t1 = setTimeout("Set_OKbtn_Text()", 1000);
        return;
    }
    if (base_score == -2) {
        $('#fanfu_ok')[0].value = '符数未设置';
        var t1 = setTimeout("Set_OKbtn_Text()", 1000);
        return;
    }
    var is_zimo = !dianpao_flag[0] && !dianpao_flag[1] && !dianpao_flag[2] && !dianpao_flag[3];
    if (is_zimo & rong_flag[0] + rong_flag[1] + rong_flag[2] + rong_flag[3] > 1) {
        $('#fanfu_ok')[0].value = '自摸人数太多了！！！';
        var t1 = setTimeout("Set_OKbtn_Text()", 1000);
        return;
    }

    if (is_zimo) {}
}

function liuju() {
    if($('#liuju_btn')[0].value=='流')
    {
        $(".liuju_icon").css("visibility","visible");
        $('#liuju_btn')[0].value='定';
    }
    else{
        $('#liuju_btn')[0].value='流';
        $('.liuju_icon').removeClass('liuju_ting');
        $('.liuju_icon').addClass('liuju_noting');
        //流局逻辑
    }
}

function liuju_clk(idx){
    if($q('.liuju_icon',idx).hasClass('liuju_noting')){
        $q('.liuju_icon',idx).removeClass('liuju_noting');
        $q('.liuju_icon',idx).addClass('liuju_ting');
    }
    else{
        $q('.liuju_icon',idx).removeClass('liuju_ting');
        $q('.liuju_icon',idx).addClass('liuju_noting');
    }
}