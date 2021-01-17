To deploy your function, please use the following instructions in your flex account:
1) Open your console and navigate to functions
2) Create a new service and give it a unique name. We used "EOC-Service-team2"
3) Create a new function called "/task_creation"
4) Copy and Paste the code found in task_creation.js into the UI
5) Ensure that the workspace and workflow SIDs are updated to match your default Taskrouter SIDs in your flex workspace
5) Click Save
6) Click Deploy All
7) Navigate to the studio folder and view the readme.md


Airtable function (update_med_taken_count.js)
* This function is to increment the medication taken count every time IoT Tracker indicates that the medication was taken 
* Configure Functions
    * Add key/value pair with AIRTABLE_API_KEY = you Airtable account API key
    * Create a base and then a table "medication_tracker" in that base. 
        * Columns Name, meds_taken, Type
        * initial data - add rows:
            * red, 100, total
            * blue, 100, total
            * green, 100, total
            * red, 0, consumed
            * blue, 0, consumed
            * green, 0, consumed
    * Add key/value pair with AIRTABLE_BASE_RXTRACKER = key for table "medication_tracker"
    * Add "airtable" NPN module dependency and leave version empty
    *[optional] Add bar chart to the dashboard
        * Y-axis: Field: meds_taken
        * Mean: group By "Type"