function Game_State(m_game, m_player) {
    this.game = m_game;
    this.player = m_player;
}

function Game(m_jushu, m_changfeng, m_benchang) {
    this.jushu = m_jushu; //局数
    this.changfeng = m_changfeng; //场风
    this.benchang = m_benchang; //本场数
    this.lichi_num = 0;
}

function Player(m_playerName, m_Point) {　　　　
    this.playerName = m_playerName;　　　　
    this.Point = m_Point;
    this.PointHistory = new Array();
}

var game = new Game(1, '东', 0);
var InitScore = 25000;
var player = [new Player('Aさん', InitScore), new Player('Bさん', InitScore), new Player('Cさん', InitScore), new Player('Dさん', InitScore)];

var rong_flag = [false, false, false, false]; //胡牌
var dianpao_flag = [false, false, false, false]; //点炮
var lichi_flag = [false, false, false, false]; //立直

var mainView = 0; //点差模式下主视角
var rong_list = [-1]; //[点炮者,[胡牌者1,点数],[胡牌者2,点数]]
var game_area_lock = false;

var game_state = new Array();

function $q(pattern, idx) { //jQuery辅助函数
    return $(pattern + ":eq(" + idx + ')');
}

function next_Game(Is_oya_win) {
    if (Is_oya_win) {
        game.benchang += 1;
    } else {
        game.benchang = 0;
        game.jushu += 1;
        if (game.jushu > 4) {
            game.jushu = 1;
            var cf = ['东', '南', '西', '北'];
            for (var i = 0; i < 4; i++) {
                if (cf[i] == game.changfeng) {
                    game.changfeng = cf[(i + 1) % 4];
                    break;
                }
            }
        }
    }
}

function DrawLine() {
    var data = {
        labels: [],
        datasets: [
            {
                fillColor: "rgba(255,255,255,0)",
                strokeColor: "rgb(220,0,220)", //线
                pointColor: "rgb(203, 22, 29)", //点
                pointStrokeColor: "#f00", //圈
                data: []
		},
            {
                fillColor: "rgba(255,255,255,0)",
                strokeColor: "rgb(18, 235, 60)",
                pointColor: "rgb(0, 250, 135)",
                pointStrokeColor: "#21fa7d",
                data: []
		}
        ,
            {
                fillColor: "rgba(255,255,255,0)",
                strokeColor: "rgb(25, 41, 234)",
                pointColor: "rgb(14, 148, 198)",
                pointStrokeColor: "#4e60c1",
                data: []
		}
        ,
            {
                fillColor: "rgba(255,255,255,0)",
                strokeColor: "rgb(237, 128, 109)",
                pointColor: "rgb(226, 93, 34)",
                pointStrokeColor: "#c9861c",
                data: []
		}
	]
    };
    for (var i = 0; i < game_state.length; i++) {
        data['labels'].push(game_state[i].game.changfeng + game_state[i].game.jushu + '-' + game_state[i].game.benchang);
        for (var player_idx = 0; player_idx < 4; player_idx++) {
            data['datasets'][player_idx]['data'].push(game_state[i].player[player_idx].Point);
        }
    }
    var ctx = document.getElementById("myChart").getContext("2d");
    window.myLine = new Chart(ctx).Line(data, {
        scaleOverlay: true,
        showScale: true,
        scaleLineColor: "rgba(0,0,0,1)",
        scaleLineWidth: 1,
        scaleShowLabels: true,
        scaleLabel: "<%=value%>",
        scaleFontFamily: "'Arial'",
        scaleFontSize: 20,
        scaleFontStyle: "normal",
        scaleFontColor: "#666",
        scaleShowGridLines: true,
        scaleGridLineColor: "rgba(0,0,0,.1)",
        scaleGridLineWidth: 3,
        bezierCurve: true,
        pointDot: true,
        pointDotRadius: 5,
        pointDotStrokeWidth: 1,
        datasetStrokeWidth: 2,
        datasetFill: false,
    });
}

function clone(myObj) { //deep copy of object
    if (typeof (myObj) != 'object' || myObj == null) return myObj;
    var newObj = new Object();
    for (var i in myObj) {
        newObj[i] = clone(myObj[i]);
    }
    return newObj;
}

function RecordCurGameState() {
    game_state.push(new Game_State(clone(game), clone(player)));
    DrawLine();
}

function RecoverGameState() {
    game_state.pop();
    game = game_state[game_state.length - 1].game;
    player = game_state[game_state.length - 1].player;
    DrawLine();
    UpdateAllView();
}

function resizeCanvas() {
    $("#myChart").width(document.documentElement.clientWidth - $(".nTab").width() - 80 + 'px');
    $("#myChart").height(250 + 'px');
    //$("#myChart").width(50%);
};

resizeCanvas();

$(document).ready(
    function () {
        $(window).resize(resizeCanvas);
        resizeCanvas();
        $('input').bind('change', EditPlayerName);
        UpdateUserName();

        $('#myonoffswitch').change(ChangePointShowMode);
        ShowPoint(false);

        UpdateAllView();
        $('#fanfu_ok').attr("disabled", true);

        RecordCurGameState();
        set_tooltip();
    }
);

function UpdateAllView() {
    ChangePointShowMode(); //更新点差显示模式
    UpdateGameProcess(); //更新右上角进度
    UpdateFengwei(); //更新风位
    UpdateRank(); //更新顺位
    $("#lichi_num").text(game.lichi_num);
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
    if (game_area_lock) return;
    rong_flag[idx] = !rong_flag[idx];
    if (rong_flag[idx] == false) {
        $("#player" + idx + "_rong").text("自摸");
        $("#player" + idx + "_rong").removeClass('t_btn_click');
    } else {
        $("#player" + idx + "_rong").text("取消");
        $("#player" + idx + "_rong").addClass('t_btn_click');
        if (dianpao_flag[idx] == true) {
            $("#player" + idx + "_dianpao").text("点炮");
            $("#player" + idx + "_dianpao").removeClass('t_btn_click');
            dianpao_flag[idx] = false;
        }
    }
    Set_OKbtn_Text();
}

function dianpao_click(idx) {
    if (game_area_lock) return;
    dianpao_flag[idx] = !dianpao_flag[idx];
    if (dianpao_flag[idx] == false) {
        $("#player" + idx + "_dianpao").text("点炮");
        $("#player" + idx + "_dianpao").removeClass('t_btn_click');
    } else {
        $("#player" + idx + "_dianpao").text("取消");
        $("#player" + idx + "_dianpao").addClass('t_btn_click');
        if (rong_flag[idx] == true) { //不可能同时胡牌和点炮
            $("#player" + idx + "_rong").text("自摸");
            $("#player" + idx + "_rong").removeClass('t_btn_click');
            rong_flag[idx] = false;
        }
        for (var i = 0; i < 4; i++) //逻辑保证只能有一个点炮的
        {
            if (i == idx) continue;
            dianpao_flag[i] = false;
            $("#player" + i + "_dianpao").removeClass('t_btn_click');
        }
    }

    var has_dianpao = dianpao_flag[0] || dianpao_flag[1] || dianpao_flag[2] || dianpao_flag[3];
    for (var i = 0; i < 4; i++) {
        if (rong_flag[idx] == false) {
            $("#player" + i + "_rong").text(has_dianpao ? "胡牌" : "自摸");
        }
    }

}

function lichi_click(idx) {
    if (game_area_lock) return;
    lichi_flag[idx] = !lichi_flag[idx];
    if (lichi_flag[idx]) {
        $q('.playerinfoarea', idx).addClass("lichi");
        player[idx].Point -= 1000;
        game.lichi_num += 1;
    } else {
        $q('.playerinfoarea', idx).removeClass("lichi");
        player[idx].Point += 1000;
        game.lichi_num -= 1
    }
    UpdateAllView();
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
        if (fushu_idx == 0 && fanshu_idx == 0) //1番20符的特例要变1番30符
        {
            fushu_idx = 2;
        }
        if (fushu_idx == 1 && fanshu_idx == 0) //1番25符的情况不存在
        {
            return -3;
        }
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

function ScoreUpper(score) {
    return parseInt(score / 100) * 100 + (score % 100 == 0 ? 0 : 100);
}

function ShowErrorStr(base_score) {
    if (base_score == -1)
        $('#fanfu_ok')[0].value = '番数未设置';
    if (base_score == -2)
        $('#fanfu_ok')[0].value = '符数未设置';
    if (base_score == -3)
        $('#fanfu_ok')[0].value = '一番25符是不可能的！！';
    if (base_score == -4)
        $('#fanfu_ok')[0].value = '自摸人数太多了！！';
    if (base_score == -5)
        $('#fanfu_ok')[0].value = '一炮三响是流局！！';
    if (base_score == -6)
        $('#fanfu_ok')[0].value = '四人点炮你逗我？！！';
    setTimeout("Set_OKbtn_Text()", 1000);
}

function score_give(from, to, score) {
    player[from].Point -= score;
    player[to].Point += score;
}

function CalScore_OK() {
    var rong_num = rong_flag[0] + rong_flag[1] + rong_flag[2] + rong_flag[3];
    var is_zimo = !dianpao_flag[0] && !dianpao_flag[1] && !dianpao_flag[2] && !dianpao_flag[3];

    if (!is_zimo && rong_num == 3) { //一炮三响
        ShowErrorStr(-5);
        liuju_cal([0, 0, 0, 0], !rong_flag[game.jushu - 1]);
        return;
    }
    if (!is_zimo && rong_num == 4) { //胡牌人数四个人，你特么在逗我？！
        ShowErrorStr(-6);
        return;
    }

    if (is_zimo & rong_num > 1) { //超过1人自摸
        ShowErrorStr(-4);
        return;
    }

    var base_score = Cal_BaseScore();
    if (base_score < 0) {
        ShowErrorStr(base_score);
        return;
    }

    var zimo_idx = rong_flag[0] ? 0 : (rong_flag[1] ? 1 : (rong_flag[2] ? 2 : 3));
    if (is_zimo) { //自摸    
        if (zimo_idx == game.jushu - 1) { //庄家自摸
            for (var i = 0; i < 4; i++) {
                if (i == zimo_idx) continue;
                score_give(i, zimo_idx, ScoreUpper(base_score * 2) + 100 * game.benchang);
            }
            next_Game(true);
        } else { //闲家自摸
            for (var i = 0; i < 4; i++) {
                if (i == zimo_idx) continue;
                score_give(i, zimo_idx, ScoreUpper(base_score * (1 + (i == game.jushu - 1))) + 100 * game.benchang);
            }
            next_Game(false);
        }
        //处理立直棒
        collect_lichi(zimo_idx);
        Reset_Game_panel();
        UpdateAllView();
        RecordCurGameState();
    } //自摸-END
    else { //点炮
        var dianpao_player_idx = dianpao_flag[0] ? 0 : (dianpao_flag[1] ? 1 : (dianpao_flag[2] ? 2 : 3));
        rong_list[0] = dianpao_player_idx;
        for (var i = 0; i < 4; i++) {
            if (rong_flag[i]) {
                rong_flag[i] = false;
                $("#player" + i + "_rong").text("胡牌");
                $("#player" + i + "_rong").removeClass('t_btn_click');
                rong_list.push([i, base_score]);
                break;
            }
        }
        Set_OKbtn_Text();
        if (rong_flag[0] + rong_flag[1] + rong_flag[2] + rong_flag[3] == 0) { //处理完全部胡牌了
            deal_dianpao();
        } else {
            game_area_lock = true; //一炮双响,锁定面板，不允许操作
        }
    }

}

function collect_lichi(idx) { //第idx玩家获得剩下所有立直棒
    player[idx].Point += 1000 * game.lichi_num;
    game.lichi_num = 0;
}

function deal_dianpao() {
    var oya_win = false;

    var dianpao_player = rong_list[0];
    var nearest_dis = 999999;
    var nearest_idx = -1;
    for (var i = 1; i < rong_list.length; i++) {
        var rong_player = rong_list[i][0];
        var score = rong_list[i][1];
        score_give(dianpao_player, rong_player, ScoreUpper(score * (4 + 2 * (rong_player == game.jushu - 1))) + 300 * game.benchang);
        //寻找最近的作为立直棒所有者
        var dis = rong_player > dianpao_player ? rong_player - dianpao_player : rong_player - dianpao_player + 4;
        if (nearest_dis > dis) {
            nearest_dis = dis;
            nearest_idx = rong_player;
        }

        if (rong_player == game.jushu - 1) {
            oya_win = true;
        }
    }

    collect_lichi(nearest_idx);
    game_area_lock = false;
    next_Game(oya_win);
    UpdateAllView();
    Reset_Game_panel();
    RecordCurGameState();
    rong_list = [-1];
}

function liuju() {
    if (game_area_lock) return;
    if ($('#liuju_btn').text() == '流') {
        $(".liuju_icon").css("visibility", "visible");
        $('#liuju_btn').text('定');
        for (var i = 0; i < 4; i++) { //立直流局必然听牌。。。。。。吧。。。。反正可以撤销
            if ($q('.playerinfoarea', i).hasClass("lichi")) {
                $q('.liuju_icon', i).removeClass('liuju_noting');
                $q('.liuju_icon', i).addClass('liuju_ting');
            }
        }
    } else {
        //流局逻辑
        var tingpai = [0, 0, 0, 0];
        var tingpai_user_ct = 0;
        for (var i = 0; i < 4; i++) {
            if ($q('.liuju_icon', i).hasClass('liuju_ting')) {
                tingpai[i] = 1;
                tingpai_user_ct += 1;
            }
        }
        if (tingpai_user_ct == 0 || tingpai_user_ct == 4) {
            liuju_cal(0, 0, 0, 0, tingpai_user_ct > 0);
        } else {
            for (var i = 0; i < 4; i++) {
                if (tingpai_user_ct == 1)
                    tingpai[i] = tingpai[i] ? 3000 : -1000;
                else if (tingpai_user_ct == 2)
                    tingpai[i] = tingpai[i] ? 1500 : -1500;
                else
                    tingpai[i] = tingpai[i] ? 1000 : -3000;
            }
            liuju_cal(tingpai, tingpai[game.jushu - 1] > 0 ? false : true);
        }

        $('#liuju_btn').text('流');
        $('.liuju_icon').removeClass('liuju_ting');
        $('.liuju_icon').addClass('liuju_noting');
        $(".liuju_icon").css("visibility", "hidden");
    }
}

function Reset_Game_panel() {
    rong_flag = [false, false, false, false];
    dianpao_flag = [false, false, false, false];
    lichi_flag = [false, false, false, false];
    for (var i = 0; i < 4; i++) {
        $q('.rong_btn', i).text('自摸');
        $q('.dianpao_btn', i).text('点炮');
    }
    $('.rong_btn').removeClass('t_btn_click');
    $('.dianpao_btn').removeClass('t_btn_click');
    $('.playerinfoarea').removeClass("lichi");
}

function liuju_cal(score_list, oya_lose) {
    if (game_area_lock) return;
    for (var i = 0; i < 4; i++) {
        player[i].Point += score_list[i];
    }
    next_Game(!oya_lose);
    UpdateAllView();
    Reset_Game_panel();
    RecordCurGameState();
}