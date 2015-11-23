
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  console.log("Hello logger!!!");
  response.success("Hello world! This is a test of cloud code functionality.");
});

Parse.Cloud.job("schoolDayStructureDeletion", function(request, response) {
  // Set up to modify user data
  //Parse.Cloud.useMasterKey();
  // Query for all users
  var query = new Parse.Query("SchoolDayStructure");
  query.ascending("schoolDayID");
  query.first({
  	success: function(object) {
    	object.destroy({
    		success: function(myObject) {
    			response.success("Yay!");
  		},
  		error: function(myObject, error) {
  			response.error("No!");
  		}
    });
  },
  	error: function(error) {
    	alert("Error: " + error.code + " " + error.message);
    	response.error("No!");
  	}
 });
 });

Parse.Cloud.job("communityServiceStructureDeletion", function(request, response) {
	var query = new Parse.Query("CommunityServiceStructure");
	query.ascending("communityServiceID");
	query.find({
		success: function(structures) {
			for (var i = 0; i < structures.length; i++) {
      			var currentStructure = structures[i];
      			var thisDate = currentStructure.get("endDate");
      			var now = new Date();
      			var one_day=1000*60*60*24;
  				var date1_ms = thisDate.getTime();
  				var date2_ms = now.getTime();
  				var difference_ms = date2_ms - date1_ms;Math.round(difference_ms/one_day);
  				if (difference_ms > 3) {
  					currentStructure.destroy({
  						success: function() {
  							console.log("Just deleted an object!!!");
  						},
  						error: function(error) {
  							response.error(error);
  						}
  					});
  				};
  				if (i == structures.length - 1) {
  					response.success("Done!!!");
  				};
    		}
		},
		error: function() {
			response.error("Error.");
		}
	});
});
