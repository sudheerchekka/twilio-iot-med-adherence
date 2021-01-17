// IMPORTS

#require "Twilio.class.nut:1.0"
#require "JSONEncoder.class.nut:2.0.0"

//TODO 
/* 
* should we use device id instead of agent id to store in DynamoDB
* create scheduler using https://developer.electricimp.com/libraries/utilities/scheduler
* cleanup HTML_STRING to remove unused functions
*/


// CONSTANTS
const HTML_STRING = @"<!DOCTYPE html><html lang='en-US'><meta charset='UTF-8'>
<html>
  <head>
    <title>Rx Tracker</title>
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css' integrity='sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk' crossorigin='anonymous'>
    <link href='//fonts.googleapis.com/css?family=Abel' rel='stylesheet'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <style>
      .center { margin-left: auto; margin-right: auto; margin-bottom: auto; margin-top: auto; }
      body {background-color: #6F6B60}
      p {color: white; font-family: Abel}
      h2 {color: #99ccff; font-family: Abel; font-weight:bold; padding: 20px;}
      h4 {color: white; font-family: Abel}
      a:link {color: white; font-family: Abel}
      a:visited {color: #cccccc; font-family: Abel}
      a:hover {color: black; font-family: Abel}
      a:active {color: black; font-family: Abel}
      .left_spc_image {
          padding-top: 50px;
          padding-right: 30px;
          padding-bottom: 0px;
          padding-left: 0px;
        }
    </style>
  </head>
  <body>
  
  
  
<table style='width:1200px;border: 0px solid black;'>
    <tr>
        <td style='border: 0px solid black;'>
            <div  style='padding: 20px'>
              <div style='border: 0px solid white'>
                <h2 class='text-center'>Rx Tracker</h2>
                 <h4 class='text-center'><b>Patient Name: </b>Sam</h4>
              </div>
            </div>
        </td>
        <td style='border: 0px solid black;'>

            <div class='left_spc_image'>
                <a>
                    <img src='https://black-bee-6064.twil.io/assets/iot_rx_tacker-2.png' width='289' height='144'>
                </a>
            </div>
        </td>
    </tr>

  <tr>
    <td style='border: 0px solid black;'>
      <div style='padding: 20px'>
          <div style='border: 0px solid white'>
           
            <br />
           <div class='update-button'>
             <p class='text-center'>Medication:  <select name='cars' id='cars'>
                                                <option value=''></option>
                                                <option value='volvo'>Metformin</option>
                                                <option value='saab'>Glipizide</option>
                                                <option value='opel'>Januvia</option>
                                              </select>   
                                              
                                              <input id='med3' style='width:50px;color:CornflowerBlue'></input> <b> times a day</b> 
                                              &nbsp; <input id='med3' style='width:150px;color:CornflowerBlue'></input> <br /> <br/>
              
            Medication:  <select name='cars' id='cars'>
                                                <option value=''></option>
                                                <option value='volvo'>Metformin</option>
                                                <option value='saab'>Glipizide</option>
                                                <option value='opel'>Januvia</option>
                                              </select>   
                                              
                                              <input id='med3' style='width:50px;color:CornflowerBlue'></input> <b> times a day</b>
                                              &nbsp; <input id='med3' style='width:150px;color:CornflowerBlue'></input> <br /> <br/>
              
             Medication:  <select name='cars' id='cars'>
                                                <option value=''></option>
                                                <option value='volvo'>Metformin</option>
                                                <option value='saab'>Glipizide</option>
                                                <option value='opel'>Januvia</option>
                                              </select>   
                                              
                                              <input id='med3' style='width:50px;color:CornflowerBlue'></input> <b> times a day</b>
                                              &nbsp; <input id='med3' style='width:150px;color:CornflowerBlue'></input><br /> <br/>
                     
              <br/><br/>
              <button onclick ='setLocation()' style='font-family:Abel' type='submit' class='btn btn-light btn-sm'>Send SMS</button></p> &nbsp;&nbsp;&nbsp
              
              <div style='width:700px; border: 0px solid black;' >
                <a href='twilio' target='_blank'>Reminders</a>
                <button onclick='send_led_signal(3)' style='font-family:Abel' type='submit' class='btn btn-light btn-sm'>9:00 AM</button> &nbsp;&nbsp;&nbsp              
                <button onclick='send_led_signal(2)' style='font-family:Abel' type='submit' class='btn btn-light btn-sm'>2:00 PM</button> &nbsp;&nbsp;&nbsp              
              </div>
                
            </div>
        
            <br />
            <p class='text-center'><a href='https://developer.electricimp.com/examples/webserver'><small>Powered by Electric Imp</small></a></p>
          </div>
        </div>
    </td>
    
    <td style='border: 0px solid black;'>
        
    </td>
  </tr>
 
</table>

    
  
    <script src='https://code.jquery.com/jquery-3.5.1.min.js'></script>
    <script>
      // Store the agent URL
      var agenturl = '%s';
      // Set the 'Set Location' button's action
      //$('.update-button button').click(getStateInput);
      $('.update-button button_reminder').click(send_led_signal);
      // Get the current state of the device, calling 'updateReadout()' when we have it
      getState(updateReadout);
      // Get State entry
      function getStateInput(e){
        e.preventDefault();
        var place = $('#med3').val();
        setLocation(place);
        $('#name-form').trigger('reset');
      }
      // Update the display when we receive device state information
      function updateReadout(data) {
        // Update the readouts
        $('.temp-status span').text(data.med1);
        $('.humid-status span').text(data.med2);
        $('.locale-status span').text(data.med3);
        // Display the current time and date (when the thermal data was received)
        var date = new Date();
        $('.timestamp span').text(date.toTimeString());
        // Auto-update in 2 minutes' time
        setTimeout(function() {
          getState(updateReadout);
        }, 120000);
      }
      // Send the content of the location field - ie. where the user has said the device
      // is placed - to the agent using Ajax
      function setLocation(place){
        $.ajax({
          url : agenturl + '/location',
          type: 'POST',
          data: JSON.stringify({ 'location' : place }),
          success : function(response) {
            if ('locale' in response) {
              $('.locale-status span').text(response.locale);
            }kkk
          }
        });
      }
      // Get the device state from the agent
      function getState(callback) {
        $.ajax({
          url : agenturl + '/state',
          type: 'GET',
          success : function(response) {
            if (callback) {
              callback(response);
            }
          }
        });
      }
      
      function send_led_signal(schedule, callback){
          $.ajax({
          url : agenturl + '/reminder?schedule=' + schedule,
          type: 'GET',
          success : function(response) {
            if (callback) {
              callback(response);
            }
          }
        });
      
      }
    </script>
  </body>
</html>";


//Twilio SMS config
local twilio_account_sid = __VARS.twilio_flex_account_sid;
local twilio_auth_token = __VARS.twilio_flex_auth_token;
local twilio_from_number = __VARS.from_number;
twilio <- Twilio(twilio_account_sid, twilio_auth_token, twilio_from_number);

local agentID = split(http.agenturl(), "/").top();


//pre-req: create base and table in Airtable with the right medication names and pre-set totals

function updateMedicationCount(medicationName){
    //local url = "https://thistle-aardvark-4642.twil.io/update_med_taken_count?med_name=" + medicationName; 
    local url = __VARS.twilio_update_meds_taken_function + "?med_name=" + medicationName; 

    server.log("in updateMedicationCount: " + medicationName);
    local request = http.get(url);
    
    local responseTable = request.sendsync();
 
    if (responseTable.statuscode == 200) {
        // Remote service has responded with 'OK' so decode
        // the response's body 'responseTable.body' and headers 'responseTable.headers'
        // Code omitted for clarity...
        server.log("successly updated med count in Airtable: " + responseTable.statuscode);
    } else {
        // Log an error
        server.log("Error while updating med count in Airtable                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  : " + responseTable.statuscode);
    }
}


//called from UI to send SMS to the patient
function sendSMS(){
    local recipientsNumber = __VARS.patient_number;
    local textMessage = "Sam, your prescription is ready. Should we send your prescription schedule to your Rx Tracker?";
    
    // Send the message synchronously
    local response = twilio.send(recipientsNumber, textMessage);
    server.log(response.statuscode + ": " + response.body);
}

/**
 * Send sensors data to Twilio Studio
 */
function sendSensorsDataToTwilioStudio(data, callback=null) {
    server.log("Sending data to Twilio Studio");

    local result = {
        "payload": data,
        "formatPayload": JSONEncoder.encode(data),
        "electricImpAgentURL": http.agenturl(),
        "patient_device_id": agentID
    }

    local url = __VARS.twilio_create_task_studio_url;
    local auth = http.base64encode(__VARS.twilio_flex_account_sid + ":" + __VARS.twilio_flex_auth_token);
    local headers = { "Authorization": "Basic " + auth };
    local body = http.urlencode({
        From = twilio_from_number,
        To = __VARS.patient_number,
        Parameters = http.jsonencode(result)
    });
    
    
    local request = http.post(url, headers, body);
    
    if(callback == null) {
        local result = request.sendsync();
        if (result.statuscode == 200 || result.statuscode == 201) {
            server.log("Successfully sent data to Twilio Studio.");
        } else {
            server.error("An error has occured when sending data to Twilio Studio");
            server.error("Error code: " + result.statuscode);
            server.error("Error Body: " + result.body);
        }
    } else {
        request.sendasync(callback);
    }
}

// Open listener for "reading" messages from the device and update the database
device.on("reading", function(reading) {
    server.log("reading: " + reading);
    if (reading == "send_light_task") //read light sensor
    {
        server.log("calling Task Router: ");
        sendSensorsDataToTwilioStudio(null);
    }
    else //receive accelerometer readings
    {
        server.log(http.jsonencode(reading));
        server.log( "medicationName: " + reading.color);
        //increment the med_taken count by 1 for the medication name
        updateMedicationCount(reading.color);
    }
})

http.onrequest (function(request, response) {
    local path = request.path.tolower();
    server.log("http.onrequest..." + path);
    
    if (path == "/")//load home page
    {
        local url = http.agenturl();
        response.send(200, format(HTML_STRING, url));
    }
    else if (path == "/location" || path == "/location/") //submit button
    {
        sendSMS();
    }
    else if (path == "/reminder" || path == "/reminder/") //SMS response webhook /reminder?schedule=3
    {
        server.log("sending reminder to the device....");
        
        //foreach(i,v in request.query) { server.log("parameter="+i); server.log("value="+v); }
        
        local sch = request.query["schedule"];
        server.log("schedule param: " + sch);
        
        if (sch == "3")
        {
            server.log("schedule 3: ");
            device.send("set.sch", "2020-10-22,0900,red,green,blue");
        }
        else if (sch == "2")  
        {
            server.log("schedule 2: ");
            device.send("set.sch", "2020-10-22,0900,red,green");
        }
        else
        {
            server.log("schedule 1: ");
            device.send("set.sch", "2020-10-22,0900,blue");
        }
    }
    else if (path == "/twilio" || path == "/twilio/") //SMS response webhook
    {
        // Twilio request handler
        try {
            local data = http.urldecode(request.body);
            local cleanSMSResponse = strip(data.Body).tolower();
            server.log("cleanSMSResponse: " + cleanSMSResponse);
            if (cleanSMSResponse == "send"){
                server.log("sending reminder to the device....");
                device.send("set.sch", "2020-10-22,0900,red,green,blue"); 
            }
            else if (cleanSMSResponse == "yes"){
                server.log("sending reminder to the device....");
                twilio.respond(response, "Please save the Rx Tracker LED mapping: 1. red --> Metamorphon; 2. green --> Glipizide; 3. blue --> Januvia");
            }
            else {
                local recipientsNumber = __VARS.patient_number;
                twilio.respond(response, "This messaging line is not monitored. To speak with a licensed health coach, please call this number")
            }
            
            //twilio.respond(response, "You just said '" + data.Body + "'");
        } catch(ex) {
            local message = "Uh oh, something went horribly wrong: " + ex;
            server.log(message);
        }
    }

   
    
});
