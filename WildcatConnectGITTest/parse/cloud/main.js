//WildcatConnect Parse.com Server-Side Logic

var Mailgun = require('mailgun');
Mailgun.initialize('wildcatconnect.org', 'key-21b93c07c71f9d42c7b0bec1fa68567f');

var Buffer = require('buffer').Buffer;

var Moment = require('moment');

Parse.Cloud.job("schoolDayStructureDeletion", function(request, response) {
  var query = new Parse.Query("SpecialKeyStructure");
  query.equalTo("key", "scheduleMode");
  query.first({
    success: function(object) {
      var date = new Date();
      if (object.get("value") === "NORMAL" && date.getDay() != 0 && date.getDay() != 1) {
        //Continue...
        var firstQuery = new Parse.Query("SchoolDayStructure");
        firstQuery.equalTo("isActive", 1);
        firstQuery.ascending("schoolDayID");
        firstQuery.first().then(function(day) {
          console.log(day);
          if (day.get("isSnow") === 0) {
            //Wasn't a snow day the day before...you can delete this one
            var query = new Parse.Query("SchoolDayStructure");
            query.equalTo("isActive", 1);
            query.ascending("schoolDayID");
            query.first({
              success: function(object) {
                var schoolDate = object.get("schoolDate");
                var now = Moment().format("MM-DD-YYYY");
                if (schoolDate === now) {
                  response.success("Date does not allow deletion at this time.");
                } else {
                  object.set("isActive", 0);
                  object.save(null, {
                    success: function(myObject) {
                      response.success("Yay!");
                    },
                    error: function(myObject, error) {
                      response.error(error);
                    }
                  });
                };
              },
              error: function(error) {
                //alert("Error: " + error.code + " " + error.message);
                response.error("No!");
              }
           });
          } else {
            response.error("Nope!");
          };
        });
      } else {
        response.success("Schedule mode does not allow deletion at this time.");
      };
    },
    error: function(error) {
      response.error(error);
    }
  });
 });

Parse.Cloud.job("schoolDayStructureGeneration", function(request, response) {
  var query = new Parse.Query("SpecialKeyStructure");
  query.equalTo("key", "scheduleMode");
  query.first({
    success: function(object) {
      var date = new Date();
      if (object.get("value") === "NORMAL" && date.getDay() != 0 && date.getDay() != 1) {
        var query = new Parse.Query("SchoolDayStructure");
        query.descending("schoolDayID");
        query.first({
          success: function(object) {
            var ID = object.get("schoolDayID") + 1;
            var oldDate = object.get("schoolDate");
            var oldDateDate =  Moment(oldDate, "MM-DD-YYYY");
            var thatDay = oldDateDate.day();
            if (thatDay === 5) {
              var newDateDate = oldDateDate.add('days', 3);
              var newDate = newDateDate.format("MM-DD-YYYY");
              var oldType = object.get("scheduleType");
              var newType = "*";
              if (oldType.indexOf("A") > -1) {
                newType = "B1";
              } else if (oldType.indexOf("B") > -1) {
                newType = "C1";
              } else if (oldType.indexOf("C") > -1) {
                newType = "D1";
              } else if (oldType.indexOf("D") > -1) {
                newType = "E1";
              } else if (oldType.indexOf("E") > -1) {
                newType = "F1";
              } else if (oldType.indexOf("F") > -1) {
                newType = "G1";
              } else if (oldType.indexOf("G") > -1) {
                newType = "A1";
              };
              var SchoolDayStructure = Parse.Object.extend("SchoolDayStructure");
              var newDay = new SchoolDayStructure();
              newDay.save({
                "hasImage": 0,
                "imageString" : "None.",
                "messageString" : "No alerts yet.",
                "scheduleType" : newType,
                "schoolDate" : newDate,
                "imageUser" : "None.",
                "customSchedule" : "None",
                "imageUserFullString" : "None.",
                "schoolDayID" : ID,
                "isActive" : 1,
                "customString" : "",
                "breakfastString" : "No breakfast yet.",
                "lunchString" : "No lunch yet.",
                "isSnow" : 0
              }, {
                success: function(savedObject) {
                  response.success("New day created.");
                },
                error: function(savedObject, error) {
                  response.error(error.code + " - " + error.message);
                }
              });
            } else {
              var newDateDate = oldDateDate.add('days', 1);
              var newDate = newDateDate.format("MM-DD-YYYY");
              var oldType = object.get("scheduleType");
              var newType = "*";
              if (oldType.indexOf("A") > -1) {
                newType = "B";
              } else if (oldType.indexOf("B") > -1) {
                newType = "C";
              } else if (oldType.indexOf("C") > -1) {
                newType = "D";
              } else if (oldType.indexOf("D") > -1) {
                newType = "E";
              } else if (oldType.indexOf("E") > -1) {
                newType = "F";
              } else if (oldType.indexOf("F") > -1) {
                newType = "G";
              } else if (oldType.indexOf("G") > -1) {
                newType = "A";
              };
              var SchoolDayStructure = Parse.Object.extend("SchoolDayStructure");
              var newDay = new SchoolDayStructure();
              newDay.save({
                "hasImage": 0,
                "imageString" : "None.",
                "messageString" : "No alerts yet.",
                "scheduleType" : newType,
                "schoolDate" : newDate,
                "imageUser" : "None.",
                "customSchedule" : "None",
                "imageUserFullString" : "None.",
                "schoolDayID" : ID,
                "isActive" : 1,
                "customString" : "",
                "breakfastString" : "No breakfast data.",
                "lunchString" : "No lunch data.",
                "isSnow" : 0
              }, {
                success: function(savedObject) {
                  response.success("New day created.");
                },
                error: function(savedObject, error) {
                  response.error(error.code + " - " + error.message);
                }
              });
            };
          },
          error: function(error) {
//alert("Error: " + error.code + " " + error.message);
            response.error("No!");
          }
       });
      } else {
        response.success("Schedule mode does not allow generation at this time.");
      };
    },
    error: function(error) {
      response.error(error);
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

Parse.Cloud.job("eventStructureDeletion", function(request, response) {
  var query = new Parse.Query("EventStructure");
  query.ascending("eventDate");
  query.find({
    success: function(structures) {
      for (var i = 0; i < structures.length; i++) {
            var currentStructure = structures[i];
            var thisDate = currentStructure.get("eventDate");
            var now = new Date();
          var date1_ms = thisDate.getTime();
          var date2_ms = now.getTime();
          var difference_ms = date2_ms - date1_ms;
          if (difference_ms >= 0) {
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
          if (difference_ms >= currentStructure.get("daysActive")) {
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
          if (difference_ms >= 3) {
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
            var thisDate = currentStructure.get("createdAt");
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

Parse.Cloud.job("userRegisterStructureDeletion", function(request, response) {
  var query = new Parse.Query("UserRegisterStructure");
  query.ascending("createdAt");
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
          console.log(difference_ms);
          if (difference_ms >= 2) {
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
    if (request.object.get("isReady") == 1 && request.object.get("views") == 0) {
      var query = new Parse.Query("SpecialKeyStructure");
      query.equalTo("key", "appActive");
      query.first({
        success: function(structure) {
          if (structure.get("value") === "1") {
            Parse.Push.send({
              channels: [ "global" ],
              data: {
                title: "WildcatConnect",
                alert: request.object.get("titleString"),
                a: request.object.get("alertID"),
                badge: "Increment"
              }
            });
          };
        },
        error: function(errorTwo) {
          response.error("Error.");
        }
      });
    };
  };
});

Parse.Cloud.define("countInstallations", function(request, response) {
  Parse.Cloud.useMasterKey();
  var query = new Parse.Query("_Installation");
  query.count({
    success: function(count) {
      response.success(count);
    },
    error: function(error) {
      response.error(error);
    }
  });
});

Parse.Cloud.define("snowDay", function(request, response) {
  var array = [];
  var ID = request.params.ID;
  var hasChanged = false;
  var query = new Parse.Query("SchoolDayStructure");
  query.descending("schoolDayID");
  query.find( {
    success: function (results) {
      for (var i = 0; i < results.length; i++) {
        if (results[i].get("schoolDayID") > ID && i != results.length - 1) {
          var nextScheduleType = results[i + 1].get("scheduleType");
          if (nextScheduleType === "*") {
            //Set the custom schedule as well!
            results[i].set("customSchedule", results[i + 1].get("customSchedule"));
            results[i].set("customString", results[i + 1].get("customString"));
          };
          results[i].set("scheduleType", nextScheduleType);
          array.push(results[i]);
        } else if (results[i].get("schoolDayID") === ID) {
          results[i].set("isActive", 0);
          results[i].set("isSnow", 1);
          results[i].save(null, {
            success: function(myObject) {
              //No response yet...
            },
            error: function(myObject, error) {
              response.error(error);
            }
          });
        };
      };
      /*for (var i = 0; i < array.length; i++) {
        console.log(array[i]);
      };
      response.success();*/
      Parse.Object.saveAll(array, {
        success: function() {
          Parse.Cloud.run("SDSgen", null, {
            success: function() {
              response.success("Done!");
            },
            error: function(error) {
              response.error(error);
            }
          });
        },
        error: function(objects, error) {
          response.error(error);
        }
      });
    },
    error: function (error) {
      response.error(error);
    }
  });
});

Parse.Cloud.define("SDSgen", function(request, response) {
  var query = new Parse.Query("SchoolDayStructure");
  query.descending("schoolDayID");
  query.first({
    success: function(object) {
      var ID = object.get("schoolDayID") + 1;
      var oldDate = object.get("schoolDate");
      var oldDateDate =  Moment(oldDate, "MM-DD-YYYY");
      var thatDay = oldDateDate.day();
      if (thatDay === 5) {
        var newDateDate = oldDateDate.add('days', 3);
        var newDate = newDateDate.format("MM-DD-YYYY");
        var oldType = object.get("scheduleType");
        var newType = "*";
        if (oldType.indexOf("A") > -1) {
          newType = "B1";
        } else if (oldType.indexOf("B") > -1) {
          newType = "C1";
        } else if (oldType.indexOf("C") > -1) {
          newType = "D1";
        } else if (oldType.indexOf("D") > -1) {
          newType = "E1";
        } else if (oldType.indexOf("E") > -1) {
          newType = "F1";
        } else if (oldType.indexOf("F") > -1) {
          newType = "G1";
        } else if (oldType.indexOf("G") > -1) {
          newType = "A1";
        };
        var SchoolDayStructure = Parse.Object.extend("SchoolDayStructure");
        var newDay = new SchoolDayStructure();
        newDay.save({
          "hasImage": 0,
          "imageString" : "None.",
          "messageString" : "No alerts yet.",
          "scheduleType" : newType,
          "schoolDate" : newDate,
          "imageUser" : "None.",
          "customSchedule" : "None",
          "imageUserFullString" : "None.",
          "schoolDayID" : ID,
          "isActive" : 1,
          "customString" : "",
          "breakfastString" : "No breakfast yet.",
          "lunchString" : "No lunch yet.",
          "isSnow" : 0
        }, {
          success: function(savedObject) {
            response.success("New day created.");
          },
          error: function(savedObject, error) {
            response.error(error.code + " - " + error.message);
          }
        });
      } else {
        var newDateDate = oldDateDate.add('days', 1);
        var newDate = newDateDate.format("MM-DD-YYYY");
        var oldType = object.get("scheduleType");
        var newType = "*";
        if (oldType.indexOf("A") > -1) {
          newType = "B";
        } else if (oldType.indexOf("B") > -1) {
          newType = "C";
        } else if (oldType.indexOf("C") > -1) {
          newType = "D";
        } else if (oldType.indexOf("D") > -1) {
          newType = "E";
        } else if (oldType.indexOf("E") > -1) {
          newType = "F";
        } else if (oldType.indexOf("F") > -1) {
          newType = "G";
        } else if (oldType.indexOf("G") > -1) {
          newType = "A";
        };
        var SchoolDayStructure = Parse.Object.extend("SchoolDayStructure");
        var newDay = new SchoolDayStructure();
        newDay.save({
          "hasImage": 0,
          "imageString" : "None.",
          "messageString" : "No alerts yet.",
          "scheduleType" : newType,
          "schoolDate" : newDate,
          "imageUser" : "None.",
          "customSchedule" : "None",
          "imageUserFullString" : "None.",
          "schoolDayID" : ID,
          "isActive" : 1,
          "customString" : "",
          "breakfastString" : "No breakfast data.",
          "lunchString" : "No lunch data.",
          "isSnow" : 0
        }, {
          success: function(savedObject) {
            response.success("New day created.");
          },
          error: function(savedObject, error) {
            response.error(error.code + " - " + error.message);
          }
        });
      };
    },
    error: function(error) {
//alert("Error: " + error.code + " " + error.message);
      response.error("No!");
    }
 });
});

Parse.Cloud.define("registerUser", function(request, response) {

  Parse.Cloud.useMasterKey();

  var username = request.params.username;
  var password = request.params.password;
  var email = request.params.email;
  var firstName = request.params.firstName;
  var lastName = request.params.lastName;
  var key = request.params.key;

  var theUser = new Parse.User();

  theUser.set("username", username);
  theUser.set("password", password.replace(/\0/g, ''));
  theUser.set("email", email);
  theUser.set("userType", "Faculty");
  theUser.set("ownedEC", new Array());
  theUser.set("firstName", firstName);
  theUser.set("lastName", lastName);
  theUser.set("verified", 0);
  theUser.set("key", key);

  theUser.signUp(null, {
    success: function(newUser) {
      var query = new Parse.Query("UserRegisterStructure");
      query.equalTo("username", username.toString());
      query.first({
        success: function(object) {
          object.destroy({
            success: function(object) {
              Mailgun.sendEmail({
                to: email,
                from: "WildcatConnect <team@wildcatconnect.org>",
                bcc: "WildcatConnect <team@wildcatconnect.org>",
                subject: "WildcatConnect Account Confirmation",
                text: firstName + ", \n\nYour new WildcatConnect account has been approved! With your faculty account, you will now be able to log in to both the WildcatConnect iOS App and our web portal at http://www.wildcatconnect.org. For your first login, you will be required to enter the following credentials...\n\nUsername = " + username + "\nRegistration Key = " + key +"\n\nNOTE: All usernames, passwords and keys are case-sensitive.\n\nEnjoy posting and sharing with students, faculty and families!\n\nBest,\n\nWildcatConnect Development Team\n\nWeb: http://www.wildcatconnect.org\nSupport: support@wildcatconnect.org\nContact: team@wildcatconnect.org\n\n---\n\nIf you did not register an account and are receiving this e-mail in error, please contact us immediately at support@wildcatconnect.org. For security purposes, your registration key will expire in 48 hours, at which time you will need to re-register your account.\n"
              }, {
                success: function(httpResponse) {
                  response.success("Email sent!");
                },
                error: function(httpResponse) {
                  console.error(httpResponse);
                  response.error("Uh oh, something went wrong");
                }
              });
            },
            error: function(error) {
              response.error(error);
            }
          })
        },
        error: function(error) {
          response.error(error);
        }
      });
    },
    error: function(user, error){
      response.error(error);
    }
  });

});

Parse.Cloud.define("deleteUser", function(request, response) {
  var username = request.params.username;

  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("User");
  query.equalTo("username", username);
  query.first().then(function(user) {
    return user.destroy();
  }).then(function(user) {
    response.success("User deleted!!!");
  }), function(error) {
    response.error(error);
  };
});

Parse.Cloud.define("updateType", function(request, response) {
  var username = request.params.username;
  var type = request.params.type;

  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("User");
  query.equalTo("username", username);
  query.first().then(function(user) {
    user.set("userType", type);
    return user.save();
  }).then(function(user) {
    response.success("User updated!!!");
  }), function(error) {
    response.error(error);
  };
});

Parse.Cloud.define("encryptPassword", function(request, response) {

  try {
    var str = '',
        i = 0,
        tmp_len = request.params.password.length,
        c;
 
    for (; i < tmp_len; i += 1) {
        c = request.params.password.charCodeAt(i);
        str += c.toString(16) + 'XABCWCENSPAP1357';
    }

    response.success(str.toString());

  } catch (error) {
    response.error(error);
  }

});

Parse.Cloud.define("decryptPassword", function(request, response) {

  try {
    var arr = request.params.password.split('XABCWCENSPAP1357'),
        str = '',
        i = 0,
        arr_len = arr.length,
        c;
 
    for (; i < arr_len - 1; i += 1) {
        c = String.fromCharCode( parseInt(arr[i], 16) );
        str += c;
    }

    response.success(str.toString());

  } catch (error) {
    response.error(error);
  }

});

Parse.Cloud.define("validateUser", function(request, response) {

  var count = 0;

  var username = request.params.username;
  var email = request.params.email;

  var query = new Parse.Query("User");
  query.equalTo("username", username);
  query.find().then(function(usersA) {
    count += usersA.length;
    var queryFour = new Parse.Query("User");
    queryFour.equalTo("email", email);
    return queryFour.find();
  }).then(function(usersB) {
    count += usersB.length;
    var queryTwo = new Parse.Query("UserRegisterStructure");
    query.equalTo("username", username);
    return query.find();
  }).then(function(usersC) {
    count += usersC.length;
    var queryThree = new Parse.Query("UserRegisterStructure");
    queryThree.equalTo("email", email);
    return queryThree.find();
  }).then(function(usersD) {
    count += usersD.length;
    response.success(count);
  }), function(error) {
    response.error(error);
  }

});

Parse.Cloud.define("recoverUser", function(request, response) {
  var email = request.params.email;
  Parse.User.requestPasswordReset(email, {
    success: function() {
      response.success();
    },
    error: function(error) {
      response.error(error.code + " - " + error.message);
    }
  });
});

Parse.Cloud.define("denyStructure", function(request, response) {
  var email = request.params.email;
  var name = request.params.name;
  var type = request.params.type;
  var message = request.params.message;
  var title = request.params.title;
  var admin = request.params.admin;
  if (type === "news") {
    Mailgun.sendEmail({
      to: email,
      from: "WildcatConnect <team@wildcatconnect.org>",
      subject: "Wildcat News Story Denial",
      text: name + ",\n\nUnfortunately, your recent Wildcat News Story has been denied by a member of administration. Please see below for details.\n\nArticle Title - " + title + "\nDenial Message - " + message + "\nAdministrative User - " + admin + "\n\nIf you would like, you can recreate the article and resubmit for approval. Thank you for your understanding.\n\nBest,\n\nWildcatConnect App Team"
    }, {
      success: function(httpResponse) {
        response.success("Email sent!");
      },
      error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
      }
    });
  } else if (type === "event") {
    Mailgun.sendEmail({
      to: email,
      from: "WildcatConnect <team@wildcatconnect.org>",
      subject: "Event Denial",
      text: name + ",\n\nUnfortunately, your recent event has been denied by a member of administration. Please see below for details.\n\nEvent Title - " + title + "\nDenial Message - " + message + "\nAdministrative User - " + admin + "\n\nIf you would like, you can recreate the event and resubmit for approval. Thank you for your understanding.\n\nBest,\n\nWildcatConnect App Team"
    }, {
      success: function(httpResponse) {
        response.success("Email sent!");
      },
      error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
      }
    });
  } else if (type === "comm") {
    Mailgun.sendEmail({
      to: email,
      from: "WildcatConnect <team@wildcatconnect.org>",
      subject: "Community Service Denial",
      text: name + ",\n\nUnfortunately, your recent community service opportunity has been denied by a member of administration. Please see below for details.\n\nOpportunity Title - " + title + "\nDenial Message - " + message + "\nAdministrative User - " + admin + "\n\nIf you would like, you can recreate the opportunity and resubmit for approval. Thank you for your understanding.\n\nBest,\n\nWildcatConnect App Team"
    }, {
      success: function(httpResponse) {
        response.success("Email sent!");
      },
      error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
      }
    });
  };
});

Parse.Cloud.afterSave("NewsArticleStructure", function(request) {
  if (request.object.get("articleID") != null && request.object.get("views") == 0 && request.object.get("isApproved") == 1) {
    Parse.Push.send({
        channels: [ "allNews" ],
        data: {
          title: "WildcatConnect",
          alert: "NEWS - " + request.object.get("titleString"),
          n: request.object.get("articleID"),
          badge: "Increment"
        }
      });
  };
});

Parse.Cloud.beforeSave("ExtracurricularUpdateStructure", function(request, response) {
    if (request.object.get("extracurricularID") >= 0) {
      response.success();
    } else {
      response.error();
    };
});

Parse.Cloud.afterSave("ExtracurricularUpdateStructure", function(request) {
  if (request.object.get("extracurricularUpdateID") != null) {
    var query = new Parse.Query("ExtracurricularStructure");
    query.equalTo("extracurricularID", request.object.get("extracurricularID"));
    query.first({
      success: function(structure) {
        var title = structure.get("titleString");
        var channelString = "E" + structure.get("extracurricularID").toString();
        Parse.Push.send({
          channels: [ channelString ],
          data: {
            alert: title + " - " + request.object.get("messageString"),
            e: "e",
            badge: "Increment"
          }
        });
      },
      error: function(error) {
        //Handle error
      }
    });
  };
});

Parse.Cloud.afterDelete("ExtracurricularStructure", function(request) {
  var ID = request.object.get("extracurricularID");
  var channelString = "E" + ID.toString();
  Parse.Cloud.useMasterKey();
  var query = new Parse.Query("_Installation");
  query.equalTo("channels", channelString);
  var finalArray = new Array();
  query.find({
    success: function(users) {
      console.log("HERE" + users.length);
      for (var i = 0; i < users.length; i++) {
        var theString = users[i].get("channels");
        var array = Object.keys(theString).map(function (key) {return theString[key]});
        var index = array.indexOf(channelString);
        if (index > -1) {
          array.splice(index, 1);
          users[i].set("channels", array);
          finalArray.push(users[i]);
        };
      }
      Parse.Object.saveAll(finalArray, {
        success: function(savedObjects) {
          //
        },
        error: function(error) {
          //
        }
      });
    }, error: function(error) {
      //
    }
  });
  var queryTwo = new Parse.Query("_User");
  queryTwo.equalTo("ownedEC", ID);
  var finalArray = new Array();
  queryTwo.find({
    success: function(users) {
      for (var i = 0; i < users.length; i++) {
        var theString = users[i].get("ownedEC");
        var array = Object.keys(theString).map(function (key) {return theString[key]});
        var index = array.indexOf(ID);
        if (index > -1) {
          array.splice(index, 1);
          users[i].set("ownedEC", array);
          finalArray.push(users[i]);
        };
      }
      Parse.Object.saveAll(finalArray, {
        success: function(savedObjects) {
          //
        },
        error: function(error) {
          //
        }
      });
    },
    error: function(error) {
      //
    }
  });

  var queryThree = new Parse.Query("ExtracurricularUpdateStructure");
  queryThree.equalTo("extracurricularID", ID);
  queryThree.find({
    success: function(updates) {
      Parse.Object.destroyAll(updates, {
        success: function(deletedObjects) {

        },
        error: function(error) {

        }
      })
    },
    error: function(error) {
      //
    }
  });

});

Parse.Cloud.afterSave("CommunityServiceStructure", function(request) {
  if (request.object.get("communityServiceID") != null && request.object.get("isApproved") == 1) {
    Parse.Push.send({
        channels: [ "allCS" ],
        data: {
          alert: "COMMUNITY SERVICE - " + request.object.get("commTitleString"),
          c: "c",
          badge: "Increment"
        }
      });
  };
});

Parse.Cloud.beforeSave("PollStructure", function(request, response) {
    //Not first save...sum responses from individual choices...
    var dictionary = request.object.get("pollMultipleChoices");
    var sum = 0;
    for (var key in dictionary) {
      sum += parseInt(dictionary[key], 10);
    }
    if (sum && sum > 0) {
      request.object.set("totalResponses", sum.toString());
    } else {
      request.object.set("totalResponses", "0".toString());
    };
    response.success();
});

Parse.Cloud.afterSave("PollStructure", function(request) {
  if (request.object.get("pollID") != null && request.object.get("totalResponses") === "0") {
    Parse.Push.send({
        channels: [ "allPolls" ],
        data: {
          title: "WildcatConnect",
          alert: "POLL - " + request.object.get("pollTitle"),
          p: request.object.get("pollID"),
          badge: "Increment"
        }
      });
  };
});

Parse.Cloud.job("alertStatusUpdatingNight", function(request, response) {
  var query = new Parse.Query("AlertStructure");
  var existingString = null;
  var pushSent = false;
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
            pushSent = true;
            currentStructure.set("isReady", 1);
            currentStructure.save(null, {
              success: function (currentStructure) {
                // Execute any logic that should take place after the object is saved.
                //alert('New object created with objectId: ' + gameScore.id);
                var query = new Parse.Query("SchoolDayStructure");
                query.equalTo("isActive", 1);
                query.ascending("schoolDayID");
                query.first({
                  success: function(structure) {
                    var messageString;
                    if (existingString != null) {
                      messageString = existingString;
                    } else {
                      messageString = structure.get("messageString");
                    }
                    if (messageString === "No alerts yet.") {
                      messageString = currentStructure.get("titleString");
                    } else {
                      messageString = messageString + "\n\n" + currentStructure.get("titleString");
                    };
                    existingString = messageString;
                    structure.set("messageString", messageString);
                    structure.save(null, {
                      success: function(structure) {
                        // Execute any logic that should take place after the object is saved.
                        //alert('New object created with objectId: ' + gameScore.id);
                        Parse.Push.send({
                          channels: [ "global" ],
                          data: {
                            alert: currentStructure.get("titleString"),
                            a: currentStructure.get("alertID"),
                            badge: "Increment",
                          },
                          push_time: currentStructure.get("alertTime")
                        });
                        if (i == structures.length - 1) {
                          if (pushSent === true) {
                            response.success("Push sent!!!");
                          }
                        };
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
              },
              error: function(currentStructure, error) {
                // Execute any logic that should take place if the save fails.
                // error is a Parse.Error with an error code and message.
                //alert('Failed to create new object, with error code: ' + error.message);
                response.error();
              }
            });
          } else if (i == structures.length - 1) {
            if (pushSent === false) {
              response.success("Done, no push sent!!!");
            }
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

Parse.Cloud.job("alertStatusUpdating", function(request, response) {
  var query = new Parse.Query("AlertStructure");
  var existingString = null;
  var pushSent = false;
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
            pushSent = true;
            currentStructure.set("isReady", 1);
            currentStructure.save(null, {
              success: function (currentStructure) {
                // Execute any logic that should take place after the object is saved.
                //alert('New object created with objectId: ' + gameScore.id);
                var query = new Parse.Query("SchoolDayStructure");
                query.equalTo("isActive", 1);
                query.ascending("schoolDayID");
                query.first({
                  success: function(structure) {
                    var messageString;
                    if (existingString != null) {
                      messageString = existingString;
                    } else {
                      messageString = structure.get("messageString");
                    }
                    if (messageString === "No alerts yet.") {
                      messageString = currentStructure.get("titleString");
                    } else {
                      messageString = messageString + "\n\n" + currentStructure.get("titleString");
                    };
                    existingString = messageString;
                    structure.set("messageString", messageString);
                    structure.save(null, {
                      success: function(structure) {
                        // Execute any logic that should take place after the object is saved.
                        //alert('New object created with objectId: ' + gameScore.id);
                        Parse.Push.send({
                          channels: [ "global" ],
                          data: {
                            alert: currentStructure.get("titleString"),
                            a: currentStructure.get("alertID"),
                            badge: "Increment",
                          },
                          push_time: currentStructure.get("alertTime")
                        });
                        if (i == structures.length - 1) {
                          if (pushSent === true) {
                            response.success("Push sent!!!");
                          }
                        };
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
              },
              error: function(currentStructure, error) {
                // Execute any logic that should take place if the save fails.
                // error is a Parse.Error with an error code and message.
                //alert('Failed to create new object, with error code: ' + error.message);
                response.error();
              }
            });
          } else if (i == structures.length - 1) {
            if (pushSent === false) {
              response.success("Done, no push sent!!!");
            }
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