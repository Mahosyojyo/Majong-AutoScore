function fanshu_click(idx) {
    var cur_btn = $q('#fanshu_field .fanfu_btn', idx);
    if (cur_btn.hasClass('fanshu_clk')) {
        if (idx == 8) { //役满递增处理
            var cur_yiman = parseInt(cur_btn[0].value[0]);
            if (cur_yiman < 6) {
                cur_btn[0].value = (cur_yiman + 1) + "倍役满";
            } else {
                cur_btn[0].value = "1倍役满";
                cur_btn.removeClass('fanshu_clk');
                ClearFushuSetting(false);
            }
        } else {
            cur_btn.removeClass('fanshu_clk');
            ClearFushuSetting(false);
        }
    } else {
        cur_btn.addClass('fanshu_clk');
        $('#fanshu_field .fanfu_btn').not(function (id) {
            return id == idx
        }).removeClass('fanshu_clk');
        if (idx >= 4) {
            ClearFushuSetting(true);
        } else {
            ClearFushuSetting(false);
        }
    }
}

function ClearFushuSetting(IsClear) {
    $('#fushu_field .fanfu_btn').attr('disabled', IsClear);
    $('.fanfu_help_btn').attr('disabled', IsClear);
    $('tr.mianzi_tr td .fu_btn').attr('disabled', IsClear);
    $('#fushu_ok').attr('disabled', IsClear);

    if (IsClear) {
        $('#fushu_field .fanfu_btn').removeClass('fushu_clk');
        $('.fanfu_help_btn').removeClass('fanfu_help_clk');
        $('tr.mianzi_tr td .fu_btn').removeClass('mz_cal_clk');
        $('tr.mianzi_tr td .fu_btn').each(function (idx) {
            $q('tr.mianzi_tr td .fu_btn', idx)[0].value = 0;
        })
    }
}


function fushu_click(idx) {
    var cur_btn = $q('#fushu_field .fanfu_btn', idx);
    if (cur_btn.hasClass('fushu_clk')) {
        cur_btn.removeClass('fushu_clk');
    } else {
        cur_btn.addClass('fushu_clk');
        $('#fushu_field .fanfu_btn').not(function (id) {
            return id == idx
        }).removeClass('fushu_clk');
    }
}

function toolhelp_clk(idx) {
    var cur_btn = $q('.fanfu_help_btn', idx);
    if (cur_btn.hasClass('fanfu_help_clk')) {
        cur_btn.removeClass('fanfu_help_clk');
    } else {
        cur_btn.addClass('fanfu_help_clk');
    }
    SetFushu();
}


function mianzi_cal(idx1, idx2) {
    var validLeft = 4;
    $('tr.mianzi_tr td .fu_btn').each(function (i) {
        validLeft -= parseInt($q('tr.mianzi_tr td .fu_btn', i)[0].value);
    });
    var idx = idx1 * 2 + idx2;
    var cur_btn = $q('tr.mianzi_tr td .fu_btn', idx);

    var cur_val = parseInt(cur_btn[0].value);
    cur_val = (validLeft == 0) ? 0 : cur_val + 1;
    cur_btn[0].value = '' + cur_val;
    if (cur_btn[0].value > 0)
        cur_btn.addClass('mz_cal_clk');
    else
        cur_btn.removeClass('mz_cal_clk');

    SetFushu();
}

function CalFu() { //计算符数
    var fushu = 20;
    if ($q('.fanfu_help_btn', 0).hasClass('fanfu_help_clk'))
        fushu += 2; //听牌符数
    if ($q('.fanfu_help_btn', 1).hasClass('fanfu_help_clk'))
        fushu += 10; //听牌符数
    if ($q('.fanfu_help_btn', 2).hasClass('fanfu_help_clk'))
        fushu += 2; //听牌符数

    for (var idx1 = 0; idx1 < 4; idx1++) {
        for (var idx2 = 0; idx2 < 2; idx2++) {
            var t = Math.pow(2, idx1 + idx2 + 1);
            var idx = idx1 * 2 + idx2;
            var cur_btn = $q('tr.mianzi_tr td .fu_btn', idx);
            fushu += t * parseInt(cur_btn[0].value);
        }
    }
    return fushu;
}

function SetFushu() {
    var fu = CalFu();
    var result_f = fu - fu % 10 + (fu % 10 == 0 ? 0 : 10);
    if (result_f > 120)
        result_f = 120; ///////////////最好考证一下！！！
    $('#fushu_field .fanfu_btn').each(function (idx) {
        $q('#fushu_field .fanfu_btn', idx)[0].value == result_f ? $q('#fushu_field .fanfu_btn', idx).addClass('fushu_clk') : $q('#fushu_field .fanfu_btn', idx).removeClass('fushu_clk');
    });
}

function liuju_clk(idx) {
    if ($q('.liuju_icon', idx).hasClass('liuju_noting')) {
        $q('.liuju_icon', idx).removeClass('liuju_noting');
        $q('.liuju_icon', idx).addClass('liuju_ting');
    } else {
        $q('.liuju_icon', idx).removeClass('liuju_ting');
        $q('.liuju_icon', idx).addClass('liuju_noting');
    }
}

function ScoreUpper(score) {
    return parseInt(score / 100) * 100 + (score % 100 == 0 ? 0 : 100);
}