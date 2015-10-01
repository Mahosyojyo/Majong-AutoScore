function FigureStartAngel(maxidx) {
    var player1Rate = player[maxidx].Point / (player[0].Point + player[1].Point + player[2].Point + player[3].Point);
    return ((5-maxidx)%4)*90-player1Rate/2*360;
}

function DrawPieChart() {
    var maxidx = 0;
    for (var i = 1; i < 4; i++) {
        if (player[i].Point > player[maxidx].Point)
            maxidx = i;
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        theme: "theme2",
        animationEnabled: true,
        animationDuration: 500,
        title: {
            text: ""
        },
        data: [
            {
                type: "pie",
                showInLegend: true,
                toolTipContent: "{indexLabel}<br/>{y}",
                indexLabelPlacement: "inside",
                indexLabelFontColor: "black",
                indexLabelFontSize: 18,
                showInLegend: false,
                startAngle: FigureStartAngel(maxidx),
                dataPoints: [
                    {
                        y: player[maxidx].Point,
                        indexLabel: player[maxidx].playerName
                    },
                    {
                        y: player[(maxidx+3)%4].Point,
                        indexLabel: player[(maxidx+3)%4].playerName
                    },
                    {
                        y: player[(maxidx+2)%4].Point,
                        indexLabel: player[(maxidx+2)%4].playerName
                    },
                    {
                        y: player[(maxidx+1)%4].Point,
                        indexLabel: player[(maxidx+1)%4].playerName
                    }
			]
		}
		]
    });
    chart.render();
}