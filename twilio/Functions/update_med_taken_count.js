const airtable = require("airtable");
const twilio = require("twilio");

exports.handler = function (context, event, callback) {

    const base = new airtable({apiKey: context.AIRTABLE_API_KEY}).base(context.AIRTABLE_BASE_RXTRACKER);
    console.log("Airtable key:" + context.AIRTABLE_API_KEY);
    console.log("Airtable base:" + context.AIRTABLE_BASE_RXTRACKER);
    console.log("medication name: " + event.med_name);
    
    let record_id, meds_taken;

   base
    .table("medication_tracker")
    .select()
    .all()
    .then((records) => {
      const sendingMessages = records.map((record) => {
        const client = context.getTwilioClient();
          if (record.get('Type') === "consumed" && record.get('Name') === event.med_name){
              console.log("Name: " + record.get('Name'));
              console.log("Record Id: " + record.getId());
              console.log(record.get('meds_taken'));
              
              record_id = record.getId();
              if (record.get('meds_taken') >= 0){
                meds_taken = record.get('meds_taken');
              }
              else 
                meds_taken = 0;
             

          }
      });
      return Promise.all(sendingMessages);
    })
    .then(() => {
        base("medication_tracker").update(
            record_id, 
            {"meds_taken": meds_taken+1},
             (error, record) => {
              if (error) {
                console.error(error);
                throw error;
              } else {
                console.log("done");
                callback(null, "Success!!!!");
    
            }
        });
    })
    .catch((err) => {
      callback(err);
    });
};
   