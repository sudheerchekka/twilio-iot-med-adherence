// Reading a Sensor Device Code
// ---------------------------------------------------

// SENSOR LIBRARY
// ---------------------------------------------------
// Libraries must be included before all other code

// Temperature Humidity sensor Library
#require "HTS221.device.lib.nut:2.0.1"
#require "LPS22HB.device.lib.nut:2.0.0"
#require "WS2812.class.nut:3.0.0"
//accelerometer
#require "LIS3DH.device.lib.nut:2.0.1" 


local remDate, remTime;

const LENGTH_OF_ACQUISITION = 2.56;
const DATA_PER_SECOND = 100;

local totalAquiredData = 4 * LENGTH_OF_ACQUISITION * DATA_PER_SECOND;
local accelerometerData = blob(totalAquiredData);


local i2c = hardware.i2c89;
i2c.configure(CLOCK_SPEED_400_KHZ);

//initialize LED
local spi = hardware.spi257;
spi.configure(MSB_FIRST, 7500);
hardware.pin1.configure(DIGITAL_OUT, 1);
local led = WS2812(spi, 1);

//initialize accelerometer
local acc_i2c = hardware.i2c89;

acc_i2c.configure(CLOCK_SPEED_400_KHZ);
accelerometer <- LIS3DH(i2c, 0x32);
accelerometer.setDataRate(DATA_PER_SECOND);
accelerometer.setRange(8);

/*
    * pickSchedule() is called from agent.on() i.e. triggered by the agent
    * schd is a commom delimited string with date, time and medicines (colors)
    * parse "schd" to get the medicines(colors) and display in the LED

*/
function pickSchedule(schd){
    
    server.log("schd received: " + schd);
    remDate = schd.slice(0,10); //read the date
    server.log("date: " + remDate);
    remTime = schd.slice(11,15); //read the time
    server.log("time: " + remTime);
    local remSchd = schd.slice(16,schd.len()) //read the list of medicines(colors)
    server.log("actual schedule: " + remSchd);
    local pills = split(remSchd, ",");
    
    //call runcSchd() for each medicine to display appropriate color in the LED
    foreach (pill in pills) {
        server.log("pill: " + pill);
        if (pill == "red")
            runSchd([250,0,0], "red");
        else if (pill == "blue")
            runSchd([0,0,250], "blue");
        else if (pill == "green")
            runSchd([0,250,0], "green");
    }
}

/*
    runSchd() is called by pickSchedule() for each medicine
    display approrpiate color LED and wait for the device to be moved(accelerometer)
*/
function runSchd(color, colorName) {
    // Take a reading
    local accelData = accelerometer.getAccel(); //on ground x is in the range of 0 to 0.02 (tilt forward -0.45, tilt backward 0.7)

    server.log("color: " + color);
    server.log(format("Checking Acceleration (G): (%0.2f, %0.2f, %0.2f)", accelData.x, accelData.y, accelData.z));

    while (accelData.x <= -0.04||accelData.x >= 0.4){ //waiting for reset position

        accelData = accelerometer.getAccel();
    }
    
    
    accelData = accelerometer.getAccel();
    server.log(format("Checking Acceleration (G): (%0.2f, %0.2f, %0.2f)", accelData.x, accelData.y, accelData.z));
    
    local currentLightLevel;
    local light_sensor_counter =0;
    while (accelData.x > -0.04 && accelData.x < 0.4 ){ // wait till the end user moves the device to ack
        flashLED(color); 
        flashLED([0,0,0]); //clear LED

        accelData = accelerometer.getAccel();
        server.log(format("Checking Acceleration (G): (%0.2f, %0.2f, %0.2f)", accelData.x, accelData.y, accelData.z));
        server.log("light_sensor_counter: " + light_sensor_counter);
        
        //also check for light sensor
        currentLightLevel = hardware.lightlevel();
        if (currentLightLevel < 16000 && light_sensor_counter == 0) {
            // Let's log the reading
            server.log(format("it's dark!"));
            // Send the reading to the agent for Task Router
            agent.send("reading", "send_light_task");
            light_sensor_counter = light_sensor_counter +1;
        }
        

    }
    agent.send("reading", {"date": remDate, "time" : remTime, "color": colorName});
}

//flasLED() called by runSchd() to show blinking color
function flashLED(color){
        led.set(0, color).draw();
        imp.sleep(0.5);
        led.set(0, color).draw();
}


function checkLightSensor() {
    // Take a reading
    local currentLightLevel = hardware.lightlevel();
    // Check the result
    if ("error" in currentLightLevel) {
        // We had an issue taking the reading, lets log it
        server.error(result.error);
    } else if (currentLightLevel < 16000) {
        // Let's log the reading
        server.log(format("it's dark!"));
        // Send the reading to the agent for Task Router
        agent.send("reading", "send_light_task");
    } else {
        server.log(format("Current Light Level: %0.2f", currentLightLevel, "\r\n"));
    }
    imp.wakeup(3, checkLightSensor);
}


//checkLightSensor();

server.log("Device running...");

//agent will send the schedule in "set.sch" which will be processed by pickSchedule
agent.on("set.sch", pickSchedule);

