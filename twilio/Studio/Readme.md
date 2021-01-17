To deploy your studio flows please follow the below in your flex account
1) Navigate to studio and click create a new flow
2) Name your flow "Create Task"
3) Import Flow from json
4) Copy and paste the json in the file named create_task.json. Create the flow
5) There should be one widget to run a function. Open this and update "Service", "Eviornment", and "Function" to point the the function created in previous steps (it should pre-populate)
6) Save and publish
7) Enter into your flow named "Voice IVR" (This is already created in your Flex Project)
8) Click on the Rest API Trigger and go to "show flow json".
9) Copy and paste the json found in the voice_flow.json file into the UI
10) CLick Save.
11) Ensure that the send to flex widget is pointing to your default Flex "Assign to Anyone" Workflow with the channel set to "Voice"
12) Click Publish
