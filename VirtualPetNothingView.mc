import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;
import Toybox.UserProfile;
class VirtualPetNothingView extends WatchUi.WatchFace {
  
function initialize() {  WatchFace.initialize(); }

function onLayout(dc as Dc) as Void { }

function onShow() as Void { }

function onUpdate(dc as Dc) as Void {
/*                 _       _     _           
  __   ____ _ _ __(_) __ _| |__ | | ___  ___ 
  \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
   \ V / (_| | |  | | (_| | |_) | |  __/\__ \
    \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
                                           */

    /*----------System Variables------------------------------*/
    var mySettings = System.getDeviceSettings();
    var screenHeightY = (System.getDeviceSettings().screenHeight)/360;
    var screenWidthX = (System.getDeviceSettings().screenWidth)/360;
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
    if (System.getDeviceSettings().screenHeight ==390){
        screenHeightY=screenHeightY*1.1;
        screenWidthX=screenWidthX *1.07;
    }
    if (System.getDeviceSettings().screenHeight ==416){
        screenHeightY=screenHeightY*1.15;
        screenWidthX=screenWidthX *1.17;
    }
    if (System.getDeviceSettings().screenHeight ==454){
        screenHeightY=screenHeightY*1.25;
        screenWidthX=screenWidthX *1.27;
    }
    var myStats = System.getSystemStats();
    var info = ActivityMonitor.getInfo();
    
    /*----------Clock and Calendar Variables------------------------------*/
    var timeFormat = "$1$:$2$";
    var clockTime = System.getClockTime();
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var hours = clockTime.hour;
    if (!System.getDeviceSettings().is24Hour) {
        if (hours == 0) {
            hours = 12; // Display midnight as 12:00
        } else if (hours > 12) {
            hours = hours - 12;
        }
    } else {
        timeFormat = "$1$:$2$";
        hours = hours.format("%02d");
    }
    var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
    var timeStamp= new Time.Moment(Time.today().value());
    var weekdayArray = ["Day", "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"] as Array<String>;
    var monthArray = ["Month", "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"] as Array<String>;
   
    //----------------Horoscope-------------------//
   
   // var profile = UserProfile.getProfile();
   // var userBIRTH = 1989; // Default birth year

  //  if (profile != null && profile.birthYear != null) {
  //      userBIRTH = profile.birthYear.toNumber();
  //  }
    /* Array representing the Chinese horoscope symbols
    r: Monkey
    q: Rooster
    j: Dog
    s: Pig
    h: Rat
    K: Bull
    k: Tiger
    m: Rabbit
    d: Dragon
    o: Snake
    p: Horse
    L: Sheep*/
    //var chinesehoroscope = ["r", "q", "j", "s", "h", "K", "k", "m", "d", "o", "p", "L"] as Array<String>;
    // Current year
   // var currentYear = today.year.toNumber();
    //Get Gender
   // var gender = "y"; // Default value if gender is unspecified or null
    /*
    if (profile != null && profile.gender != null) {
        if (profile.gender == UserProfile.GENDER_FEMALE) {
            gender = "u";
        } else if (profile.gender == UserProfile.GENDER_MALE) {
            gender = "t";
        } else if (profile.gender == UserProfile.GENDER_UNSPECIFIED) {
            gender = "y"; // You could keep this as "y" for unspecified, or choose a different value if desired
        }else {gender = "y";}
        }else {gender = "y";}
        //u-female, t-male y-Robot
        
    */

    /*----------Battery------------------------------*/
    var userBattery = "0";
    var batteryMeter = 1;

    if (myStats.battery != null) {
        userBattery = myStats.battery.toNumber().toString(); // Convert to string without zero padding
    } else {
        userBattery = "0";
    }

    if (myStats.battery != null) {
        batteryMeter = myStats.battery.toNumber();
    } else {
        batteryMeter = 1;
    }
        
    /*----------Steps------------------------------*/
    var userSTEPS = 0;
  if (info.steps != null){userSTEPS = info.steps.toNumber();}else{userSTEPS=0;} 
    var userCAL = 0;
    if (info.calories != null){userCAL = info.calories.toNumber();}else{userCAL=0;}  
   
   /*----------Weather------------------------------*/
   var getCC = Toybox.Weather.getCurrentConditions();
    var TEMP = "000";
    var FC = "0";
    if (getCC != null && getCC.temperature != null) {
        if (System.getDeviceSettings().temperatureUnits == 0) {
            FC = "C";
            TEMP = getCC.temperature.format("%d");
        } else {
            TEMP = (((getCC.temperature * 9) / 5) + 32).format("%d");
            FC = "F";
        }
    } else {
        TEMP = "000";
    }

    var cond = 0;
    if (getCC != null && getCC.condition != null) {
        cond = getCC.condition.toNumber();
    } else {
        cond = 0; // Default to sun condition if unavailable
    }

    var positions;
    if (getCC != null && getCC.observationLocationPosition != null) {
        positions = getCC.observationLocationPosition;
    } else {
        positions = new Position.Location({
            :latitude => 33.684566,
            :longitude => -117.826508,
            :format => :degrees
        });
    }
    //Default set to Southern California 

    /*----------------Sunrise Sunset-------------------*/
    //Adding Null checks and formating for both the minute and hour
    var sunrise = Toybox.Weather.getSunrise(positions, timeStamp);
    var sunriseHour;
    var sunriseMin;
    if (sunrise == null) {
        sunriseHour = 6; // Default sunrise hour
        sunriseMin = 0; // Default sunrise minute
    } else {
        var sunriseInfo = Time.Gregorian.info(sunrise, Time.FORMAT_MEDIUM);
        sunriseHour = sunriseInfo.hour;
        sunriseMin = sunriseInfo.min;
    }
    if (!System.getDeviceSettings().is24Hour && sunriseHour > 12) {
        sunriseHour = (sunriseHour - 12).abs();
    } else {
        sunriseHour = sunriseHour.format("%02d");
    }
    sunriseMin = sunriseMin.format("%02d");

    var sunset = Toybox.Weather.getSunset(positions, timeStamp);
    var sunsetHour;
    var sunsetMin;
    if (sunset == null) {
        sunsetHour = 6; // Default sunset hour
        sunsetMin = 0; // Default sunset minute
    } else {
        var sunsetInfo = Time.Gregorian.info(sunset, Time.FORMAT_MEDIUM);
        sunsetHour = sunsetInfo.hour;
        sunsetMin = sunsetInfo.min;
    }
    if (!System.getDeviceSettings().is24Hour && sunsetHour > 12) {
        sunsetHour = (sunsetHour - 12).abs();
    } else {
        sunsetHour = sunsetHour.format("%02d");
    }
    sunsetMin = sunsetMin.format("%02d");

    var userHEART = "0";
    var heartRate = getHeartRate();

    if (heartRate == null) {
        userHEART = "0"; // Set to "0" if heart rate is unavailable
    } else {
        userHEART = heartRate.toString();
    }

    var moonnumber = getMoonPhase(today.year, ((today.month)-1), today.day);  
    var moon1 = moonArrFun(moonnumber);
    var centerX = (dc.getWidth()) / 2;
    var wordFont =  WatchUi.loadResource( Rez.Fonts.smallFont );
    var bigFont= WatchUi.loadResource( Rez.Fonts.bigFont );
    View.onUpdate(dc);

 /*     _                           _            _    
     __| |_ __ __ ___      __   ___| | ___   ___| | __
    / _` | '__/ _` \ \ /\ / /  / __| |/ _ \ / __| |/ /
   | (_| | | | (_| |\ V  V /  | (__| | (_) | (__|   < 
    \__,_|_|  \__,_| \_/\_/    \___|_|\___/ \___|_|\_\
                                                   */
   
   // dc.setColor(0x415F5F, Graphics.COLOR_TRANSPARENT);        
    //dc.fillCircle(centerX, centerX, centerX) ;     
    //dc.setColor(0x3F5E4F, Graphics.COLOR_TRANSPARENT);       
    //dc.fillCircle(centerX, centerX, centerX*2/3) ;   
    //dc.setColor(0x4D6A5D, Graphics.COLOR_TRANSPARENT);        
    //dc.drawCircle(centerX, centerX, centerX) ; 
    //dc.setColor(0x4D6A5D, Graphics.COLOR_TRANSPARENT);       
    //dc.drawCircle(centerX, centerX, centerX*1/2) ;   
    //dc.setColor(0x7B8863, Graphics.COLOR_TRANSPARENT);       
    //dc.fillCircle(centerX, centerX, centerX*1/2) ;  
   

    /*----Draw Graphics----------*/
    var water= waterPhase(today.sec);
    water.draw(dc);
    var dog = dogPhase(today.sec,userSTEPS); //userSTEPS or (today.sec*180) fix 15 and 16 and 17 to be higher
    dog.draw(dc);
    dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);       
     dc.fillRectangle(0,280* screenHeightY , 360,360 );
    dc.fillRectangle(0,-220* screenHeightY , 360,360 );
    
    //dc.setPenWidth(10);
    // dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);       
    dc.drawLine(105,129, 105, (((userSTEPS%360)/3*(-1))+129+100)-today.sec%2);
    dc.setPenWidth(5);
     dc.setColor(0x7B8863, Graphics.COLOR_TRANSPARENT);
   dc.drawArc(115, (((userSTEPS%360)/3*(-1))+145+100)-today.sec%2,15,Graphics.ARC_COUNTER_CLOCKWISE, 180, 290);
    dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);       
    dc.drawLine(105,129, 105, ((userSTEPS%360)/3*(-1))+129+100-today.sec%2);
    dc.fillCircle(105, ((userSTEPS%360)/3*(-1))+129+100-today.sec%2,20);
   dc.setPenWidth(15);
   dc.setColor(0x7B8863, Graphics.COLOR_TRANSPARENT);
   dc.drawArc(105, (((userSTEPS%360)/3*(-1))+129+100-today.sec%2),15,Graphics.ARC_COUNTER_CLOCKWISE, 0, 180);
    dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT); 
    dc.fillCircle(105, ((userSTEPS%360)/3*(-1))+129+100-today.sec%2,8); 
    dc.setPenWidth(5);
    dc.drawLine(84,((userSTEPS%360)/3*(-1))+129+100-today.sec%2, 127,((userSTEPS%360)/3*(-1))+129+100 );
   dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT); 
   dc.fillCircle(105, ((userSTEPS%360)/3*(-1))+129+100-today.sec%2,4);
   
   //dc.drawArc(x, y, r, attr, degreeStart, degreeEnd)
   //ARC_COUNTER_CLOCKWISE	0
    dc.setColor(0x7B8863, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(90);
    dc.drawCircle(centerX,-127,220);
     dc.setColor(0x4D6A5D, Graphics.COLOR_TRANSPARENT);       
    dc.setPenWidth(5);
    dc.drawCircle(centerX,-100,240);
    dc.drawCircle(centerX,-135,180);
    
    //dc.fillCircle((360), -200, 360) ;  
    //dc.fillCircle(0, -200, 360) ;  
    /*
    dc.fillRectangle(0,280 , 360,360 );
    dc.fillRectangle(0,-220 , 360,360 );
    dc.setColor(0x7B8863, Graphics.COLOR_TRANSPARENT); 
    dc.fillRectangle(70,38 , 220,100 );
    dc.setColor(0x4D6A5D, Graphics.COLOR_TRANSPARENT);       
    dc.setPenWidth(5);
    dc.drawRectangle(70,38 , 220,100 );
*/
/*
    dc.setColor(0x2E3731, Graphics.COLOR_TRANSPARENT);   
    dc.fillCircle(centerX, -40, 200) ;  
    dc.setColor(0x48574C, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(centerX, -50, 200) ;  
    dc.setColor(0x75887B, Graphics.COLOR_TRANSPARENT);       
    dc.fillCircle(centerX, -60, 200) ;  
    dc.setColor(0x849F8C, Graphics.COLOR_TRANSPARENT);    
    dc.fillCircle(centerX, -150, 200) ;  
    dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);    //0x9EADA2   
    dc.fillCircle(centerX, -160, 200) ; 
*/
    //dc.setColor(0xBBCBC0, Graphics.COLOR_TRANSPARENT);       
    //dc.fillCircle(centerX, -170, 200) ; 
    //dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);       
    //dc.fillCircle(centerX, -180, 200) ; 
   
   
    moon1.draw(dc);

     
   
    /*--------Draw User Data Text---------------------------*/
    dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);   
    // dc.setColor(0x17231B, Graphics.COLOR_TRANSPARENT);  
  dc.drawText( centerX, screenHeightY, wordFont,  ("+"), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText( centerX, 20*screenHeightY, wordFont,  (userHEART), Graphics.TEXT_JUSTIFY_CENTER );
   // dc.drawText( 100 *screenWidthX,40*screenHeightY , wordFont,  ("^"), Graphics.TEXT_JUSTIFY_CENTER );
  // dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);  
    dc.drawText( 10 *screenWidthX,110*screenHeightY , wordFont,  ("^"+userSTEPS), Graphics.TEXT_JUSTIFY_LEFT );
   //5 130 355 130
   // dc.drawText( 260 *screenWidthX,40*screenHeightY , wordFont,  ("~"), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText( 350*screenWidthX,110*screenHeightY , wordFont,  userCAL+"~", Graphics.TEXT_JUSTIFY_RIGHT );
    //dc.drawText( 35, 240*screenHeightY, wordFont,  ("+"), Graphics.TEXT_JUSTIFY_CENTER );
    //dc.drawText( 35, 260*screenHeightY, wordFont,  (userHEART), Graphics.TEXT_JUSTIFY_CENTER );
   
/* Draw Weather and Temperature Text
baegifc Checks Weather Strings 
a: rain
e: cloud
g: wind
i: snow
f: whirlwind
c: suncloudrain*/
dc.setColor(0x17231B, Graphics.COLOR_TRANSPARENT);  
 dc.drawText( centerX,120*screenHeightY, wordFont, (TEMP+" " +FC), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText( centerX,85*screenHeightY, bigFont, weather(cond), Graphics.TEXT_JUSTIFY_CENTER );
    //125 - 90
    //Sunrise
    //130 165 180  > 35 15
    dc.drawText( 95 *screenWidthX,34*screenHeightY, bigFont,"l", Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText( 95 *screenWidthX,69*screenHeightY , wordFont,  ("SUNRISE"), Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText( 95 *screenWidthX,84*screenHeightY, wordFont,(sunriseHour + ":" + sunriseMin+ "AM"), Graphics.TEXT_JUSTIFY_CENTER );
    //Sunset
    dc.drawText( 265 *screenWidthX,34*screenHeightY, bigFont,"l", Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText( 265 *screenWidthX,69*screenHeightY , wordFont,  ("SUNSET"), Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText( 265 *screenWidthX,84*screenHeightY, wordFont,(sunsetHour + ":" + sunsetMin+ "PM"), Graphics.TEXT_JUSTIFY_CENTER );
    //300 294
    //Time Text
    dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
    dc.drawText(centerX,288*screenHeightY,wordFont,(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText(centerX,282*screenHeightY,bigFont,timeString,  Graphics.TEXT_JUSTIFY_CENTER  ); 
   
    //Bv@wFxCyHzGEIJ B-Capricorn v-Aquarius @-Pisces w-Aries F-Taurus x-Gemini C-Cancer y-r2d2 H- z-DarthVader G-Scorpio E-Sagitarius I-Libra J-Leo
    // Draw Month Horoscope
    //dc.drawText(72 *screenWidthX,220*screenHeightY,bigFont, getHoroscope(today.month, today.day),  Graphics.TEXT_JUSTIFY_CENTER  ); 
    // Drawing the Chinese horoscope based on the current year
    //rqjshKkmdopL
    //Monkey, rooster, dog, pig, rat, bull, tiger, rabit, dragon, snake, horse, sheep
    //dc.drawText(107 *screenWidthX, 256*screenHeightY, bigFont, chinesehoroscope[(currentYear % 12)], Graphics.TEXT_JUSTIFY_CENTER);
    // Drawing the Chinese horoscope based on the user's birth year
    //dc.drawText(268 *screenWidthX, 256*screenHeightY, bigFont, chinesehoroscope[(userBIRTH % 12)], Graphics.TEXT_JUSTIFY_CENTER);
    //dc.drawText(287 *screenWidthX,220*screenHeightY,bigFont, gender,  Graphics.TEXT_JUSTIFY_CENTER  ); 



    
    /*------------Draw Step Meter------------
    //Every 360 Steps Pikachu Levels up
    dc.setPenWidth(10);
    dc.setColor(0x6C7778, Graphics.COLOR_TRANSPARENT);
    dc.drawCircle(centerX, centerX, screenHeightY);
    dc.setColor(0x2F4237, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(centerX, centerX, screenHeightY, Graphics.ARC_COUNTER_CLOCKWISE, 1, (userSTEPS+2) ); 
*/
    
    /*---------------Draw Battery---------------*/
    dc.setColor(0x17231B, Graphics.COLOR_TRANSPARENT);  
    if(batteryMeter<33 &&batteryMeter>9){
        dc.fillRectangle(centerX*350/360, (centerX*145/360)+10, 9, 50/14);}
    else if(batteryMeter>33 && batteryMeter<66){
    dc.fillRectangle(centerX*350/360, (centerX*135/360)+10, 9, 50/14);
    dc.fillRectangle(centerX*350/360, (centerX*145/360)+10, 9, 50/14);}
    else if (batteryMeter >66){
    dc.fillRectangle(centerX*350/360, (centerX*125/360)+10, 9, 50/14);
    dc.fillRectangle(centerX*350/360, (centerX*135/360)+10, 9, 50/14);
    dc.fillRectangle(centerX*350/360, (centerX*145/360)+10, 9, 50/14);}
    else{}
    
}
/*            _     _ 
  __   _____ (_) __| |
  \ \ / / _ \| |/ _` |
   \ V / (_) | | (_| |
    \_/ \___/|_|\__,_|
                    */

function onHide() as Void { }
function onExitSleep() as Void {}
function onEnterSleep() as Void {}

/*                    _   _               
__      _____  __ _| |_| |__   ___ _ __ 
\ \ /\ / / _ \/ _` | __| '_ \ / _ \ '__|
 \ V  V /  __/ (_| | |_| | | |  __/ |   
  \_/\_/ \___|\__,_|\__|_| |_|\___|_|   
                                        */

function weather(cond) {
  if (cond == 0 || cond == 40){return "b";}//sun
  else if (cond == 50 || cond == 49 ||cond == 47||cond == 45||cond == 44||cond == 42||cond == 31||cond == 27||cond == 26||cond == 25||cond == 24||cond == 21||cond == 18||cond == 15||cond == 14||cond == 13||cond == 11||cond == 3){return "a";}//rain
  else if (cond == 52||cond == 20||cond == 2||cond == 1){return "e";}//cloud
  else if (cond == 5 || cond == 8|| cond == 9|| cond == 29|| cond == 30|| cond == 33|| cond == 35|| cond == 37|| cond == 38|| cond == 39){return "g";}//wind
  else if (cond == 51 || cond == 48|| cond == 46|| cond == 43|| cond == 10|| cond == 4){return "i";}//snow
  else if (cond == 32 || cond == 37|| cond == 41|| cond == 42){return "f";}//whirlwind 
  else {return "c";}//suncloudrain 
}

/*     _                                        
    __| |_ __ __ ___      __  _ __  _ __   __ _ 
   / _` | '__/ _` \ \ /\ / / | '_ \| '_ \ / _` |
  | (_| | | | (_| |\ V  V /  | |_) | | | | (_| |
   \__,_|_|  \__,_| \_/\_/   | .__/|_| |_|\__, |
                             |_|          |___/ */

//DrawOpacityGraphic - dog -
function dogPhase(seconds, steps){
  var screenHeightY = System.getDeviceSettings().screenHeight;
  var screenWidthX = System.getDeviceSettings().screenWidth;
  var venus2X = 110*screenWidthX/360;
  var venus2Y = (190*screenHeightY/360)-(seconds*40);
  if (seconds<15){venus2Y = (190*screenHeightY/360)-(seconds*40);}
  else{venus2Y = 200;
  venus2X = screenWidthX - (seconds%20)*40;
  }
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
  if (screenHeightY == 390){
   venus2Y = (200*screenHeightY/360);
  }
    if (screenHeightY == 416){
   venus2Y = (212*screenHeightY/360);
   venus2X = 120*screenWidthX/360;
  }
      if (screenHeightY == 454){
   venus2Y = (220*screenHeightY/360);
   venus2X = 130*screenWidthX/360;
  }
  var dogARRAY = [
   (new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog0,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog1,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog2,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog3,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog4,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog5,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog6,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog7,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog8,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog9,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog10,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog11,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog12,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog13,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog14,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog15,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog16,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog17,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog18,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog19,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog20,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog21,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog22,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog23,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog24,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog25,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog26,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog27,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog28,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog29,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog30,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog31,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog32,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog33,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog34,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog35,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog36,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog37,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog38,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog39,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog40,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog41,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog42,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog43,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog44,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog45,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog46,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog47,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog48,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog49,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog50,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog51,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog52,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog53,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog54,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog55,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog56,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog57,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog58,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog59,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog60,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog61,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog62,
    :locX=> venus2X,
    :locY=>venus2Y-100
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog63,
    :locX=> venus2X,
    :locY=>venus2Y-100
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog64,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog65,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog66,
    :locX=> venus2X,
    :locY=>venus2Y-50
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog67,
    :locX=> venus2X,
    :locY=>venus2Y-50
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog68,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog69,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog70,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog71,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog72,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog73,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog74,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog75,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog76,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog77,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog78,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog79,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog80,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog81,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog82,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog83,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog84,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog85,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog86,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog87,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog88,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog89,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog90,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog91,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog92,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog93,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog94,
    :locX=> venus2X,
    :locY=>venus2Y
})),
(new WatchUi.Bitmap({
    :rezId=>Rez.Drawables.dog95,
    :locX=> venus2X,
    :locY=>venus2Y
}))
        ];
       if (steps >= 8550 ){
         if (seconds>20 && seconds<50){return dogARRAY[94+ seconds%2];}
         else{return dogARRAY[92 + seconds%2];}}
       else{
        if (seconds>20 && seconds<50){
        return dogARRAY[(((steps/360)*4)+2) + seconds%2 ];}
        else{return dogARRAY[((steps/360)*4) + seconds%2 ];}
        }
}

//DrawOpacityGraphic - dog -
function waterPhase(seconds){
  var screenHeightY = System.getDeviceSettings().screenHeight;
  var screenWidthX = System.getDeviceSettings().screenWidth;
  var venus2X = 0-(seconds);
 // var venus2Y = 15;
  var venus2Y = 10;
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
  if (screenHeightY == 390){
   venus2Y = (200*screenHeightY/360);
  }
    if (screenHeightY == 416){
   venus2Y = (212*screenHeightY/360);
   venus2X = 120*screenWidthX/360;
  }
      if (screenHeightY == 454){
   venus2Y = (220*screenHeightY/360);
   venus2X = 130*screenWidthX/360;
  }
  var waterARRAY = [
    (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.water0,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
        ];
return  waterARRAY[0];  
  
}



/* _                     _       __       _       
  | |__   ___  __ _ _ __| |_    /__\ __ _| |_ ___ 
  | '_ \ / _ \/ _` | '__| __|  / \/// _` | __/ _ \
  | | | |  __/ (_| | |  | |_  / _  \ (_| | ||  __/
  |_| |_|\___|\__,_|_|   \__| \/ \_/\__,_|\__\___|
                                                */

private function getHeartRate() {
    // Initialize to null
    var heartRate = null;

    // Get the activity info if possible
    var info = Activity.getActivityInfo();
    if (info != null && info.currentHeartRate != null) {
        heartRate = info.currentHeartRate;
    } else { 
        // Fallback to `getHeartRateHistory`
        var history = ActivityMonitor.getHeartRateHistory(1, true);
        if (history != null) {
            var latestHeartRateSample = history.next();
            if (latestHeartRateSample != null && latestHeartRateSample.heartRate != null) {
                heartRate = latestHeartRateSample.heartRate;
            }
        }
    }

    // Could still be null if the device doesn't support it
    return heartRate;
}


/*
  ____        _ _           __  __         _   _    
 |_  /___  __| (_)__ _ __  |  \/  |___ _ _| |_| |_  
  / // _ \/ _` | / _` / _| | |\/| / _ \ ' \  _| ' \ 
 /___\___/\__,_|_\__,_\__| |_|  |_\___/_||_\__|_||_|
                                                    
*/
/*
function getHoroscope(month, day) {
    if (month == 0) { // January
        if (day <= 19) {
            return "B"; // Capricorn
        } else {
            return "v"; // Aquarius
        }
    } else if (month == 1) { // February
        if (day <= 18) {
            return "v"; // Aquarius
        } else {
            return "@"; // Pisces
        }
    } else if (month == 2) { // March
        if (day <= 20) {
            return "@"; // Pisces
        } else {
            return "w"; // Aries
        }
    } else if (month == 3) { // April
        if (day <= 19) {
            return "w"; // Aries
        } else {
            return "F"; // Taurus
        }
    } else if (month == 4) { // May
        if (day <= 20) {
            return "F"; // Taurus
        } else {
            return "x"; // Gemini
        }
    } else if (month == 5) { // June
        if (day <= 20) {
            return "x"; // Gemini
        } else {
            return "C"; // Cancer
        }
    } else if (month == 6) { // July
        if (day <= 22) {
            return "C"; // Cancer
        } else {
            return "J"; // Leo
        }
    } else if (month == 7) { // August
        if (day <= 22) {
            return "J"; // Leo
        } else {
            return "H"; // Virgo
        }
    } else if (month == 8) { // September
        if (day <= 22) {
            return "H"; // Virgo
        } else {
            return "I"; // Libra
        }
    } else if (month == 9) { // October
        if (day <= 22) {
            return "I"; // Libra
        } else {
            return "G"; // Scorpio
        }
    } else if (month == 10) { // November
        if (day <= 21) {
            return "G"; // Scorpio
        } else {
            return "E"; // Sagittarius
        }
    } else if (month == 11) { // December
        if (day <= 21) {
            return "E"; // Sagittarius
        } else {
            return "B"; // Capricorn
        }
    } else {
        return "w"; // Default to Aries if month is invalid
    }
}
  */         



/*
  __  __                 ___ _                 
 |  \/  |___  ___ _ _   | _ \ |_  __ _ ___ ___ 
 | |\/| / _ \/ _ \ ' \  |  _/ ' \/ _` (_-</ -_)
 |_|  |_\___/\___/_||_| |_| |_||_\__,_/__/\___|
 
*/
function getMoonPhase(year, month, day) {

      var c=0;
      var e=0;
      var jd=0;
      var b=0;

      if (month < 3) {
        year--;
        month += 12;
      }

      ++month; 

      c = 365.25 * year;

      e = 30.6 * month;

      jd = c + e + day - 694039.09; 

      jd /= 29.5305882; 

      b = (jd).toNumber(); 

      jd -= b; 

      b = Math.round(jd * 8); 

      if (b >= 8) {
        b = 0; 
      }
     
      return (b).toNumber();
    }

     /*
     0 => New Moon
     1 => Waxing Crescent Moon
     2 => Quarter Moon
     3 => Waxing Gibbous Moon
     4 => Full Moon
     5 => Waning Gibbous Moon
     6 => Last Quarter Moon
     7 => Waning Crescent Moon
     */
function moonArrFun(moonnumber){
    var screenHeightY = System.getDeviceSettings().screenHeight;
    var screenWidthX = System.getDeviceSettings().screenWidth;    
    var venus2Y = ((screenHeightY)*50/360);
    var venus2XL = ((screenWidthX)*119/360);
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
    if (screenHeightY == 390){
        venus2XL = ((screenWidthX)*124/360);
        venus2Y = ((screenHeightY)*135/360);
    }
    if (screenHeightY == 416){
        venus2XL = ((screenWidthX)*125/360);
        venus2Y = ((screenHeightY)*129/360);
    }
        if (screenHeightY == 454){
        venus2XL = ((screenWidthX)*132/360);
        venus2Y = ((screenHeightY)*130/360);
    }
  var moonArray= [
          (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.newmoon,//0
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxcres,//1
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.firstquar,//2
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxgib,//3
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.full,//4
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wangib,//5
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.thirdquar,//6
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
           (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wancres,//7
            :locX=> venus2XL,
            :locY=> venus2Y,
        })),
        ];
        return moonArray[moonnumber];
}


}

/* 
       Horoscope, Zodiac, and Weather Font:
        A FAR
        B capricorn
        C CELCIUS
        D Celcius
        E SAGIT
        F TAUR
        G SCORP
        H VIRGO
        I LIBRA
        J LEO
        K BULL
        L SHEEP
        M PM
        N AM
        0 :
        a rain
        b sun
        c rainsuncloud
        d dragon
        e cloud
        f whirl
        g wind
        h rat
        i snow
        j dog
        k tiger
        l sun up
        m rabbit
        n sun down
        o snake
        p horse
        q rooster
        r monkey
        s pig
        t male
        u female
        v aquarius
        w aries
        x gemini
        y leo
        z libra
        */

// questionmark=calorie *=heart [=battery ]=steps @=battery #=phone
// = is small battery ^ is small steps ~ is small calories + is small heart