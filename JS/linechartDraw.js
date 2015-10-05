function DrawLine() {
    //    var data = {
    //        labels: [],
    //        datasets: [
    //            {
    //                fillColor: "rgba(255,255,255,0)",
    //                strokeColor: "rgb(220,0,220)", //线
    //                pointColor: "rgb(203, 22, 29)", //点
    //                pointStrokeColor: "#f00", //圈
    //                data: []
    //		},
    //            {
    //                fillColor: "rgba(255,255,255,0)",
    //                strokeColor: "rgb(18, 235, 60)",
    //                pointColor: "rgb(0, 250, 135)",
    //                pointStrokeColor: "#21fa7d",
    //                data: []
    //		}
    //        ,
    //            {
    //                fillColor: "rgba(255,255,255,0)",
    //                strokeColor: "rgb(25, 41, 234)",
    //                pointColor: "rgb(14, 148, 198)",
    //                pointStrokeColor: "#4e60c1",
    //                data: []
    //		}
    //        ,
    //            {
    //                fillColor: "rgba(255,255,255,0)",
    //                strokeColor: "rgb(237, 128, 109)",
    //                pointColor: "rgb(226, 93, 34)",
    //                pointStrokeColor: "#c9861c",
    //                data: []
    //		}
    //	]
    //    };
    //    for (var i = 0; i < game_state.length; i++) {
    //        data['labels'].push(game_state[i].game.changfeng + game_state[i].game.jushu + '-' + game_state[i].game.benchang);
    //        for (var player_idx = 0; player_idx < 4; player_idx++) {
    //            data['datasets'][player_idx]['data'].push(game_state[i].player[player_idx].Point);
    //        }
    //    }
    //    var ctx = document.getElementById("myChart").getContext("2d");
    //    window.myLine = new Chart(ctx).Line(data, {
    //        scaleOverlay: true,
    //        showScale: true,
    //        scaleLineColor: "rgba(0,0,0,1)",
    //        scaleLineWidth: 1,
    //        scaleShowLabels: true,
    //        scaleLabel: "<%=value%>",
    //        scaleFontFamily: "'Arial'",
    //        scaleFontSize: 20,
    //        scaleFontStyle: "normal",
    //        scaleFontColor: "#666",
    //        scaleShowGridLines: true,
    //        scaleGridLineColor: "rgba(0,0,0,.1)",
    //        scaleGridLineWidth: 3,
    //        bezierCurve: Draw_Line_Curl,
    //        pointDot: true,
    //        pointDotRadius: 5,
    //        pointDotStrokeWidth: 1,
    //        datasetStrokeWidth: 2,
    //        datasetFill: false,
    //    });

    var chart = new CanvasJS.Chart("linechartContainer", {
        animationEnabled: true,
        animationDuration: 500,
        title: {
            //text: "分数走势图"
        },
        axisY: {
            valueFormatString: "#######",
            labelFontSize: 20,
            gridDashType: "dot",
            gridThickness: 2,
            minimum: 0,
            stripLines: [
                {
                    startValue: 25000,
                    endValue: 100000,
                    color: "#f0ddba"
			},
                {
                    startValue: 0,
                    endValue: 25000,
                    color: "#e0d6d6"
			}
			]
        },
        axisX: {
            labelAngle: -45,
            labelFontSize: 20,
            minimum: 0,
            gridDashType: "dot",
            gridThickness: 2,
            gridColor: "orange",
        },
        legend: {
            fontSize: 18,
            horizontalAlign: "right",
            verticalAlign: "top",
        },
        toolTip: {
            shared: true,
            contentFormatter: function (e) {
                var content = "<strong><center>" + e.entries[0].dataPoint.label + "</center></strong>";
                for (var i = 0; i < e.entries.length; i++) {
                    content += "<span style='color:" + e.entries[i].dataSeries.color + "'>" + e.entries[i].dataSeries.name + "</span>:" + "<strong>" + e.entries[i].dataPoint.y + "</strong>";
                    content += "<br/>";
                }
                return content;
            }
        },
        data: [
            {
                name: player[0].playerName,
                showInLegend: true,
                highlightEnabled: true,
                type: Draw_Line_Curl ? 'spline' : 'line',
                dataPoints: []
      },
            {
                name: player[1].playerName,
                showInLegend: true,
                highlightEnabled: true,
                type: Draw_Line_Curl ? 'spline' : 'line',
                dataPoints: []
      },
            {
                name: player[2].playerName,
                showInLegend: true,
                highlightEnabled: true,
                type: Draw_Line_Curl ? 'spline' : 'line',
                dataPoints: []
      }, {
                name: player[3].playerName,
                showInLegend: true,
                highlightEnabled: true,
                type: Draw_Line_Curl ? 'spline' : 'line',
                dataPoints: []
      }
      ]

    });

    var last_score = [InitScore, InitScore, InitScore, InitScore];
    var min_score = 100000;
    for (var i = 0; i < game_state.length; i++) {
        for (var player_idx = 0; player_idx < 4; player_idx++) {
            chart.options.data[player_idx].dataPoints.push({
                y: game_state[i].player[player_idx].Point,
                label: game_state[i].game.changfeng + game_state[i].game.jushu + '-' + game_state[i].game.benchang,
                markerSize: 12,
                markerColor: game_state[i].player[player_idx].Point > last_score[player_idx] ? "#2defd8" : (game_state[i].player[player_idx].Point < last_score[player_idx] ? "tomato" : "green"),
                markerType: game_state[i].player[player_idx].Point > last_score[player_idx] ? "triangle" : (game_state[i].player[player_idx].Point < last_score[player_idx] ? "cross" : "square")
            })
            last_score[player_idx] = game_state[i].player[player_idx].Point;
            if (game_state[i].player[player_idx].Point < min_score)
                min_score = game_state[i].player[player_idx].Point;
        }
    }
    chart.options.axisY.minimum = min_score - 1000;
    chart.render();
}