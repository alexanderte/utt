//View that displays a question relating to a test that needs to be verified
(function() {
  define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
    return Backbone.View.extend({
	  //'el' is the element that will contain this view
      el: '#test-view',
      events: {
        'click button.answer': 'clickAnswer'
      },
      initialize: function() {
	  this.h1 = "";
        this.render();
        this.options.router.bind('all', function(route, currentTest) {
          if (route === 'route:test') {
		    //Set the 'currentTest' property of the testRun model to match the test number in the URL
            this.options.testRun.set('currentTest', currentTest === void 0 ? 0 : parseInt(currentTest));
            if (this.options.testRun.get('currentTest') === 0) {
			  //If if's the first question then scroll it down the page
			  //May be an accessibility issue
			  $("#mainHeading").html(this.h1).focus();
              return this.$el.slideDown();
            } else {
			  //Just show the question - might be preferable for accessibility
			  //Display this view if we're on the 'test' page
			  $("#mainHeading").html(this.h1).focus();
              return this.$el.show();
            }
          } else {
		    //If we're not on the 'test' page then hide this view
            return this.$el.hide();
          }
        }, this);
		//If the user changes thepage language then re-render this view
        this.options.locale.on('change:locale', this.render, this);
		//If the test running state changes (can be 'loading', 'error', 'ready' etc), re-render this view
        this.options.testRun.bind('change:state', this.render, this);
		//If the question number changes then re-render this view with the new question
        return this.options.testRun.bind('change:currentTest', this.render, this);
      },
      render: function() {
        var answers, test, that;

		//Calculate which template to render based on the outcome of the test run (error, ready etc)
        switch (this.options.testRun.get('state')) {
          case 'error':
		    this.h1 = "Error - page not found";
            return this.$el.html(_.template($('#test-error').html(), {
              'webPage': this.options.testRun.get('webPage')
            }));
          case 'loading':
		    this.h1 = "Page loading - please wait...";
            return this.$el.html(_.template($('#test-loading').html(), {
              'webPage': this.options.testRun.get('webPage')
            }));
          default:
            if (!this.options.testRun.getCurrentTest()) {
			this.h1 = "Error - nothing to test";
              this.$el.html(_.template($('#test-nothing-to-test').html(), {
                'webPage': this.options.testRun.get('webPage')
              }));
              return;
            }
            test = this.options.testRun.getCurrentTest();
            that = this;
            answers = _.map(test.get('answers'), function(a) {
              return {
                value: a,
                _value: that.options.locale.translate('test_answer_' + a)
              };
            });
			this.h1 = this.options.locale.translate('test_question_x_of_y', (this.options.testRun.get('currentTest') + 1)) + parseInt(this.options.testRun.getVerifyTestsCount());
			//Here we're rendering 2 templates, the progress bar and the next question
            this.$el.html(_.template($('#test-progress').html(), {
              'progress': this.options.testRun.progress()
            }) + _.template($(test.get('template')).html(), {
              '_question': this.options.locale.translate('test_question_' + test.get('testId') + '-' + test.get('testResultId'), test.get('questionValues')),
              '_previousTest': this.options.locale.translate('test_previous_test'),
              '_skipTest': this.options.locale.translate('test_skip_test'),
              'testNumber': (this.options.testRun.get('currentTest') + 1),
              'testsToVerify': this.options.testRun.getVerifyTestsCount(),
              'answers': answers,
              'nextUrl': this.nextUrl(),
              'previousUrl': this.previousUrl(),
              'isAtFirst': this.options.testRun.isAtFirst()
            }));

			$('#questionHeading').focus();
            //There was an animation here but it's been removed for accessibility purposes
        }
      },
      previousExtraClass: function() {
        if (this.options.testRun.isAtFirst() === true) {
          return 'disabled';
        }
      },
      previousUrl: function() {
        if (this.options.testRun.isAtFirst() === true) {
          return '#test/' + (this.options.testRun.get('currentTest'));
        } else {
          return '#test/' + (this.options.testRun.get('currentTest') - 1);
        }
      },
      nextUrl: function() {
        if (this.options.testRun.isAtLast() === true) {
          return '#result';
        } else {
          return '#test/' + (this.options.testRun.get('currentTest') + 1);
        }
      },
	        clickAnswer: function(el) {
        this.options.testRun.setAnswer(el.currentTarget.value);
        if (this.options.testRun.isAtLast()) {
          return this.options.router.navigate('result', {
            trigger: true
          });
        } else {
		//Navigate to the next question and let all event listeners know it's happened
          return this.options.router.navigate('test/' + (this.options.testRun.get('currentTest') + 1), {
            trigger: true
          });
        }
      }
    });
  });

}).call(this);
