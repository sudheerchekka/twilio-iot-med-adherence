
// This is your new function. To start, set the name and path on the left.

exports.handler = function(context, event, callback) {
  // Here's an example of setting up some TWiML to respond to with this function
	const client = context.getTwilioClient();
  console.log(event);
  client.taskrouter.workspaces('WSXXXXX')
                 .tasks
                 .create({attributes: JSON.stringify({
                    name: 'Sam / ' + event.phone_number,
                    type: 'coaching',
                    phone_number: event.phone_number,
                    popurl: 'patient_dashboard.html'
                  }), workflowSid: 'WWXXXXX'})
                 .then(task => callback(null, task));
};
