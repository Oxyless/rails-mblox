var selectedLine = null;

function showExplanation(event) {
	var index = event.data.index;
	var expel = $('#codeinspector' + index + ' #explanation');
	expel.empty();
	
	var currentLine = '#' + event.data.line;
	if (selectedLine != currentLine) { 
		
		var prevLine = selectedLine;
		$(prevLine).css('background-color', '#FFFFFF');
		
		if ($(prevLine).hasClass('optional')) {
			$(prevLine).css('color', '#999999');
		} else {
			$(prevLine).css('color', '#000000');
		}
		
		$(prevLine).hover(
			function() {$(prevLine).css('background-color', '#66AAFF'); $(prevLine).css('color', '#FFFFFF');},
			function() {$(prevLine).css('background-color', '#FFFFFF'); 					
						if ($(prevLine).hasClass('optional')) {
							$(prevLine).css('color', '#999999');
						} else {
							$(prevLine).css('color', '#000000');
						}
						}
		);
		
		selectedLine = null;
	} 
		
	$(currentLine).unbind('mouseenter mouseleave');
	
	if (event.data.explanation != null) {
		var header = "<p>Line" + event.data.number + ":<strong> " + event.data.code.split(/&lt;\/|&lt;|&gt;/)[1].split('&nbsp;')[0] + '</strong></p><hr>';
		
		expel.append(header);
		expel.append($('#' + event.data.explanation).html());
		
	} 
	
	selectedLine = currentLine;
	$(selectedLine).css('background-color', '#999999');
	$(selectedLine).css('color', '#FFFFFF'); 
	
}

function processCodeSnippet(source) {
	var index = source.substring(4);
	var line = $('#' + source).text().split(/\r\n|\r|\n|!!!/g);

	var numel = $('#codeinspector' + index + ' #number');
	var codeel = $('#codeinspector' + index + ' #code');
	var expel = $('#codeinspector' + index + ' #explanation');
	numel.empty();
	codeel.empty();
	expel.empty();
	
	var n = 1;
	for (var i=0; i<line.length; i++) {
		if ($.trim(line[i]) != "") {
			var num = ("0000" + n).slice(-3);
			
			var c = line[i].split('|||');
			var number, code, explanation;
			var codeLine = c[0].replace(/ /g, '&nbsp;').replace(/\</g,"&lt;").replace(/\>/g,"&gt;");
			if (n == 1) {
				number = "<div class='num first'>" + num + "</div>";
				code = "<div id='" + index + "code" + n + "' class='line first'>" + codeLine  + "</div><div style='clear:both;'></div>";
			} else {
				number = "<div class='num'>" + num + "</div>";
				code = "<div id='" + index + "code" + n + "' class='line'>" + codeLine  + "</div><div style='clear:both;'></div>";
			}
			
			numel.append(number); 
			codeel.append(code);
			if (c.length > 2) {
				$('#' + index + 'code' + n).addClass(c[2]);
			}			
			
			if (c.length > 1) {
				var currentLine = '#' + index + 'code' + n;
				$(currentLine).css('cursor', 'pointer');
				$(currentLine).on("click", {explanation: c[1], line: index + "code"+n, number: num, code: codeLine, index: index}, showExplanation);
				if (n == 1) {
					$(currentLine).trigger("click");
				}
				$(currentLine).hover(
					function() {$(this).css('background-color', '#66AAFF'); $(this).css('color', '#FFFFFF');},
					function() {$(this).css('background-color', '#FFFFFF'); 					
								if ($(this).hasClass('optional')) {
									$(this).css('color', '#999999');
								} else {
									$(this).css('color', '#000000');
								}
								}
				);				
			} 

			n++;
		} 
	}
	
	numel.addClass('last');
	codeel.addClass('last');
	
	expel.css('height', ((n-1)*21 - 14) + 'px');
}

$(document).ready(function() {
	snippets = $('[id^=code]');

	$.each(snippets, function() {
		processCodeSnippet($(this).attr('id'));
	});
	
});