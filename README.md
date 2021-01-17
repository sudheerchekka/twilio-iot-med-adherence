

### Project Overview

> CDC estimates that patients do not take medications as prescribed 50% of the time. This non-adherence causes 125K deaths per year in the US. Common reasons for patients not following the healthcare provider instructions especially for long-term treatments are:
* not understanding the directions
* forgetfulness
* multiple medications with different schedules 
* refilling a prescription in time

The goal of **Rx Tracker** is to 
* provide timely reminders of the complex medication schedule
* keep a log of the medcines taken by the patients
* protection from medication pilfering
* automated prescription refill reminders.



### Setup Instructions

> 
* Electric Imp
    * Import source code files [agent.nut and device.nut](electric-imp) into your Electric Imp console.
    * Set up the environment variables in electric imp console based on [electricimp.sample.env](electric-imp/electricimp.sample.env) file. We are using 2 separate Twilio accounts: one for SMS and other for Flex and Studio.  So there is a placeholder for primay account SID (SMS) and Flex account SID (studio) environment variables.
* Twilio SMS
    * Configure Messsaging webhook URL for your Twilio phone number to <YOUR_AGENT_URL>/twilio
* Airtable
    * Follow the instructions in [Twilio Functions Readme file](Twilio%20Serverless/Functions/read.MD) to configure Twilio function to access associated Airtable 
* Twilio Flex
    * Set up new Flex instance (if needed) and follow the instructions in "Supporting Assets/ Documentation/ Links" section below to create Studio flow, Function, and Assets (for the Flex plugin)
    * We configured "iFrame a webpage" option of "Panel2 Configurator" plugin in the Flex instance to display [Patient Dashboard](Twilio%20Serverless/Assets/patient_dashboard.html) page when an inbound task is selected by the agent.
    * Configure PANEL 2 CONFIG OVERRIDES with https://thistle-aardvark-4642.twil.io/assets/ for "URL to show when task is selected" 
* Dashboards [optional]
    * Prescription usage dashboard 
    * set up Rockset (cloud indexing database) - Most of the reporting tools don't work directly on DynomoDB
    * Configure Apache Superset on localhost using Rockset library

##### How to run the demo
* Access the landing page (health portal) which is you electric imp agent url
* Click "Send SMS" to send a sample prescription schedule to the patient
* Click "9:00AM" button to send morning prescription schedule to the electric imp device
* LED should blink. Move the iot device to acknowledge that you took the medicine
* DynamoDB will be updated with the acknowledgements.
* Click "2:00PM" button to send afternoon prescription schedule to the electric imp device
* Note: There is no scheduler configured yet and so click "9:00AM" and "2:00PM" buttons to send different schedules to the electric imp device manually
* Place your hand on the electric imp's light sensor to make it dark. This will simulate a patient not taking his medcine for a day and will trigger an event to create Flex Task
* When the agent accepting the Flex task, they are presented with patient's dashboard (mock)



### Supporting Assets/ Documentation/ Links
* [Twilio Functions and Function Readme.md](twilio/Functions)
* [Twilio Studio Flows and Studio Readme.MD](twilio/Studio)
* [Twilio Assets and Asset Readme.md](twilio/Assets)
* [Getting Started with Twilio Flex](https://support.twilio.com/hc/en-us/articles/360010784193-Getting-Started-with-Twilio-Flex)
* [Creating Plugins for Flex](https://support.twilio.com/hc/en-us/articles/360019473713-Creating-Plugins-for-Twilio-Flex)
> ...
