	var SetTimeOutPeriod, dthen, dnow;

	/* Countdown ticker */
	
	function calcage(secs, num1, num2) {
		s = ((Math.floor(secs/num1))%num2).toString();
		if (LeadingZero && s.length < 2)
			s = "0" + s;
		return "<b>" + s + "</b>";
	}
	
	function CountBack(secs) {
		if (secs < 0) {
			document.getElementById("cntdwn").innerHTML = FinishMessage;
			return;
		}
		DisplayStr = DisplayFormat.replace(/%%D%%/g, calcage(secs,86400,100000));
		DisplayStr = DisplayStr.replace(/%%H%%/g, calcage(secs,3600,24));
		DisplayStr = DisplayStr.replace(/%%M%%/g, calcage(secs,60,60));
		DisplayStr = DisplayStr.replace(/%%S%%/g, calcage(secs,1,60));
		
		document.getElementById("cntdwn").innerHTML = DisplayStr;
		if (CountActive)
			setTimeout("CountBack(" + (secs+CountStepper) + ")", SetTimeOutPeriod);
	}
	
	function putspan(backcolor, forecolor) {
		document.write("<span id='cntdwn'></span>");
	   //document.write("<span id='cntdwn' style='background-color:" + backcolor + 
	   //               "; color:" + forecolor + "'></span>");
	}
	
	
function print_countdown() {
	if (typeof(BackColor)=="undefined")
		BackColor = "white";
	if (typeof(ForeColor)=="undefined")
		ForeColor= "black";
	if (typeof(TargetDate)=="undefined")
		TargetDate = "1/7/2010 5:00 PM";
	if (typeof(DisplayFormat)=="undefined")
		DisplayFormat = "%%D%% days, %%H%% hours, %%M%% minutes, %%S%% seconds 'till GAMETIME!!";
	if (typeof(CountActive)=="undefined")
		CountActive = true;
	if (typeof(FinishMessage)=="undefined")
		FinishMessage = "Go Longhorns!!";
	if (typeof(CountStepper)!="number")
		CountStepper = -1;
	if (typeof(LeadingZero)=="undefined")
		LeadingZero = true;

	 CountStepper = Math.ceil(CountStepper);
	if (CountStepper == 0)
		CountActive = false;
	 SetTimeOutPeriod = (Math.abs(CountStepper)-1)*1000 + 990;
	
	putspan(BackColor, ForeColor);
	
	 dthen = new Date(TargetDate);
	 dnow = new Date();
	
	if(CountStepper>0)
		ddiff = new Date(dnow-dthen);
	else
		ddiff = new Date(dthen-dnow);
		
	gsecs = Math.floor(ddiff.valueOf()/1000);
	CountBack(gsecs);
}
	
