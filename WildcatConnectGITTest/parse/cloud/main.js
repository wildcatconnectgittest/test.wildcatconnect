//WildcatConnect Parse.com Server-Side Logic

Parse.Cloud.job("schoolDayStructureDeletion", function(request, response) {
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

Parse.Cloud.job("lunchMenusStructureDeletion", function(request, response) {
  var query = new Parse.Query("LunchMenusStructure");
  query.ascending("lunchStructureID");
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
  				var difference_ms = date2_ms - date1_ms;
          difference_ms = Math.round(difference_ms/one_day);
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
        if (structures.length == 0) {
          response.success("No objects to delete!!!");
        };
		},
		error: function() {
			response.error("Error.");
		}
	});
});

Parse.Cloud.job("pollStructureDeletion", function(request, response) {
  var query = new Parse.Query("PollStructure");
  query.ascending("pollID");
  query.find({
    success: function(structures) {
      for (var i = 0; i < structures.length; i++) {
            var currentStructure = structures[i];
            var thisDate = currentStructure.get("createdAt");
            var now = new Date();
            var one_day=1000*60*60*24;
          var date1_ms = thisDate.getTime();
          var date2_ms = now.getTime();
          var difference_ms = date2_ms - date1_ms;
          difference_ms = Math.round(difference_ms/one_day);
          if (difference_ms > currentStructure.get("daysActive")) {
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
        if (structures.length == 0) {
          response.success("No objects to delete!!!");
        };
    },
    error: function() {
      response.error("Error.");
    }
  });
});

Parse.Cloud.job("extracurricularUpdateStructureDeletion", function(request, response) {
  var query = new Parse.Query("ExtracurricularUpdateStructure");
  query.ascending("extracurricularUpdateID");
  query.find({
    success: function(structures) {
      for (var i = 0; i < structures.length; i++) {
            var currentStructure = structures[i];
            var thisDate = currentStructure.get("updatedAt");
            var now = new Date();
            var one_day=1000*60*60*24;
          var date1_ms = thisDate.getTime();
          var date2_ms = now.getTime();
          var difference_ms = date2_ms - date1_ms;
          difference_ms = Math.round(difference_ms/one_day);
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
        if (structures.length == 0) {
          response.success("No objects to delete!!!");
        };
    },
    error: function() {
      response.error("Error.");
    }
  });
});

Parse.Cloud.job("newsArticleStructureDeletion", function(request, response) {
  var query = new Parse.Query("NewsArticleStructure");
  query.ascending("articleID");
  query.find({
    success: function(structures) {
      for (var i = 0; i < structures.length; i++) {
            var currentStructure = structures[i];
            var thisDate = currentStructure.get("updatedAt");
            var now = new Date();
            var one_day=1000*60*60*24;
          var date1_ms = thisDate.getTime();
          var date2_ms = now.getTime();
          var difference_ms = date2_ms - date1_ms;
          difference_ms = Math.round(difference_ms/one_day);
          if (difference_ms > 10) {
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
        if (structures.length == 0) {
          response.success("No objects to delete!!!");
        };
    },
    error: function() {
      response.error("Error.");
    }
  });
});

Parse.Cloud.job("alertStructureDeletion", function(request, response) {
  var query = new Parse.Query("AlertStructure");
  query.ascending("alertID");
  query.find({
    success: function(structures) {
      for (var i = 0; i < structures.length; i++) {
            var currentStructure = structures[i];
            var thisDate = currentStructure.get("updatedAt");
            var now = new Date();
            var one_day=1000*60*60*24;
          var date1_ms = thisDate.getTime();
          var date2_ms = now.getTime();
          var difference_ms = date2_ms - date1_ms;
          difference_ms = Math.round(difference_ms/one_day);
          console.log(difference_ms);
          if (difference_ms > 21) {
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
        if (structures.length == 0) {
          response.success("No objects to delete!!!");
        };
    },
    error: function() {
      response.error("Error.");
    }
  });
});

Parse.Cloud.afterSave("AlertStructure", function(request) {
  if (request.object.get("alertID") != null) {
    if (request.object.get("alertTime") == null && request.object.get("views") == 0) {
      var query = new Parse.Query("SchoolDayStructure");
      query.ascending("schoolDayID");
      query.first({
        success: function(structure) {
          var messageString = structure.get("messageString");
          if (messageString === "No alerts yet.") {
            messageString = request.object.get("titleString");
          } else {
            messageString = messageString + "\n\n" + request.object.get("titleString");
          };
          structure.set("messageString", messageString);
          structure.save(null, {
            success: function(structure) {
              // Execute any logic that should take place after the object is saved.
              //alert('New object created with objectId: ' + gameScore.id);
            },
            error: function(error) {
              // Execute any logic that should take place if the save fails.
              // error is a Parse.Error with an error code and message.
              //alert('Failed to create new object, with error code: ' + error.message);
            }
          });
        },
        error: function(errorTwo) {
          response.error("Error.");
        }
      });
      Parse.Push.send({
        channels: [ "global" ],
        data: {
          alert: request.object.get("titleString"),
          a: request.object.get("alertID"),
          badge: "Increment"
        }
      });
    };
  };
});

// Just a single icon push for non-critical updates!!!

Parse.Cloud.afterSave("NewsArticleStructure", function(request) {
  if (request.object.get("articleID") != null && request.object.get("views") == 0) {
    console.log("Hey Parse.");
    Parse.Push.send({
      channels: [ "global" ],
      data: {
        badge: "Increment"
      }
    });
  };
});

Parse.Cloud.afterSave("ExtracurricularUpdateStructure", function(request) {
  if (request.object.get("extracurricularUpdateID") != null) {
    Parse.Push.send({
      channels: [ "global" ],
      data: {
        badge: "Increment"
      }
    });
  };
});

Parse.Cloud.afterSave("CommunityServiceStructure", function(request) {
  if (request.object.get("communityServiceID") != null) {
    Parse.Push.send({
      channels: [ "global" ],
      data: {
        badge: "Increment"
      }
    });
  };
});

Parse.Cloud.afterSave("PollStructure", function(request) {
  if (request.object.get("pollID") != null) {
    Parse.Push.send({
      channels: [ "global" ],
      data: {
        badge: "Increment"
      }
    });
  };
});

Parse.Cloud.job("alertStatusUpdating", function(request, response) {
  var query = new Parse.Query("AlertStructure");
  query.ascending("alertID");
  query.equalTo("isReady", 0);
  query.find({
    success: function(structures) {
      for (var i = 0; i < structures.length; i++) {
            var currentStructure = structures[i];
            var thisDate = currentStructure.get("alertTime");
            var now = new Date();
          var date1_ms = thisDate.getTime();
          var date2_ms = now.getTime();
          var difference_ms = date2_ms - date1_ms;
          if (difference_ms >= 0) {
            currentStructure.set("isReady", 1);
            currentStructure.save(null, {
  success: function (currentStructure) {
    // Execute any logic that should take place after the object is saved.
    //alert('New object created with objectId: ' + gameScore.id);
    response.success();
  },
  error: function(currentStructure, error) {
    // Execute any logic that should take place if the save fails.
    // error is a Parse.Error with an error code and message.
    //alert('Failed to create new object, with error code: ' + error.message);
    response.error();
  }
});
            var query = new Parse.Query("SchoolDayStructure");
      query.ascending("schoolDayID");
      query.first({
        success: function(structure) {
          var messageString = structure.get("messageString");
          if (messageString === "No alerts yet.") {
            messageString = request.object.get("titleString");
          } else {
            messageString = messageString + "\n\n" + request.object.get("titleString");
          };
          structure.set("messageString", messageString);
          structure.save(null, {
            success: function(structure) {
              // Execute any logic that should take place after the object is saved.
              //alert('New object created with objectId: ' + gameScore.id);
            },
            error: function(error) {
              // Execute any logic that should take place if the save fails.
              // error is a Parse.Error with an error code and message.
              //alert('Failed to create new object, with error code: ' + error.message);
            }
          });
        },
        error: function(errorTwo) {
          response.error("Error.");
        }
      });
            Parse.Push.send({
              channels: [ "global" ],
              data: {
              alert: currentStructure.get("titleString"),
              a: currentStructure.get("alertID"),
              badge: "Increment",
              },
              push_time: currentStructure.get("alertTime")
            });
          };
          if (i == structures.length - 1) {
            response.success("Done!!!");
          };
        }
        if (structures.length == 0) {
          response.success("No objects to change!!!");
        };
    },
    error: function() {
      response.error("Error.");
    }
  });
});

Parse.Cloud.job("alertStatusUpdatingNight", function(request, response) {
  var query = new Parse.Query("AlertStructure");
  query.ascending("alertID");
  query.equalTo("isReady", 0);
  query.find({
    success: function(structures) {
      for (var i = 0; i < structures.length; i++) {
            var currentStructure = structures[i];
            var thisDate = currentStructure.get("alertTime");
            var now = new Date();
          var date1_ms = thisDate.getTime();
          var date2_ms = now.getTime();
          var difference_ms = date2_ms - date1_ms;
          if (difference_ms >= 0 || (thisDate.getHours() === now.getHours() && thisDate.getMinutes() === now.getMinutes())) {
            currentStructure.set("isReady", 1);
            currentStructure.save(null, {
  success: function (currentStructure) {
    // Execute any logic that should take place after the object is saved.
    //alert('New object created with objectId: ' + gameScore.id);
    response.success();
  },
  error: function(currentStructure, error) {
    // Execute any logic that should take place if the save fails.
    // error is a Parse.Error with an error code and message.
    //alert('Failed to create new object, with error code: ' + error.message);
    response.error();
  }
});
            Parse.Push.send({
              channels: [ "global" ],
              data: {
              alert: currentStructure.get("titleString"),
              a: currentStructure.get("alertID"),
              badge: "Increment",
              },
              push_time: currentStructure.get("alertTime")
            });
          };
          if (i == structures.length - 1) {
            response.success("Done!!!");
          };
        }
        if (structures.length == 0) {
          response.success("No objects to change!!!");
        };
    },
    error: function() {
      response.error("Error.");
    }
  });
});