//View that displays a table of test results and a pass/fail/verify summary
(function() {
  define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
    return Backbone.View.extend({
      //'el' is the element that will contain this view//'el' is the element that will contain this view
	  el: '#result-view',
      events: {
		'click #showAutomatedResults': 'clickShowAutomatedResults'
      },
      initialize: function() {
	    //If this is false, only show verified results
	    this.showAutomated = false;
        this.options.router.bind('all', function(route) {
		  //Only show this view if page = 'results'
          if (route === 'route:result') {
		    this.render();
            return this.$el.show();
          } else {
            return this.$el.hide();
          }
        }, this);
		//If the user changes the page language, re-render this view
        this.options.locale.on('change:locale', this.render, this);
		return this;
      },
      render: function() {
        var checked, test, tests, verifyTests, summary, _i, _len, _ref, _cat;

        if (this.options.testRun.get('state') === 'error') {
		  //Compile and render the HTML template for this view
	      //All templates are held in the 'index.html' file
          return this.$el.html(_.template($('#result-template-error').html(), {
            webPage: this.options.testRun.get('webPage')
          }));
        } else if (this.options.testRun.get('state') === 'loading') {
          return this.$el.html(_.template($('#result-template-loading').html(), {
            webPage: this.options.testRun.get('webPage')
          }));
        } else {
		//This array will contain all of the test results
          tests = [];
		  //This object contains the numbers of pass/fail/verify tests
		  summary = new Object();
		  //This one holds the tests to be verified
          verifyTests = this.options.testRun.getVerifyTests();
		  //These are the results sent back from eGovMon. They need cleaning up
          _ref = this.options.testRun.get('tests').models;
		  //Loop through the eGovMon results and extract only the info we need
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            test = _ref[_i];
			_cat = test.get('category');
			//Increase the number of the appropriate category in the summary: pass/fail/verify
			if (_cat in summary) {
			summary[_cat] = summary[_cat] + 1;
			} else {
			  summary[_cat] = 1;
			}
			//Add the cleaned up result data to the 'tests' array
            tests.push(this.transformResult(test, verifyTests));
          }
		            tests.sort(function(a, b) {
            if (a.index > b.index) {
              return 1;
            } else {
              return -1;
            }
          });

          return this.$el.html(_.template($('#result-template').html(), {
            tests: tests,
			summary: summary,
                        _resultsForWebPage: this.options.locale.translate('result_results_for_web_page', this.options.testRun.get('webPage')),
            _hideAutomated: this.options.locale.translate('result_hide_automated'),
            _category: this.options.locale.translate('result_category'),
            _line: this.options.locale.translate('result_line'),
            _column: this.options.locale.translate('result_column'),
            _testId: this.options.locale.translate('result_test_id'),
            _testResultId: this.options.locale.translate('result_test_result_id'),
            _testTitle: this.options.locale.translate('result_test_title'),
            _answer: this.options.locale.translate('result_answer'),
            _answer_auto: this.options.locale.translate('result_answer_auto')
          }));
        }
      },
      transformResult: function(result, verifyTests) {
        var index;

        index = _.indexOf(verifyTests, result);
        if (result.get('category') === 'verify') {
		//Create a link to this test so the user can change the answer they gave
          if (index !== -1) {
            result.set('testTitle', '<a href="' + window.location.href.split('#')[0] + '#test/' + index + '">' + result.get('testTitle') + '</a>');
            result.set('index', index);
          } else {
            result.set('index', 5000);
          }
        } else {
          result.set('index', 10000);
        }
        if (result.get('line') === 0) {
          result.set('line', '–');
        }
        if (result.get('column') === 0) {
          result.set('column', '–');
        }
        if (result.get('category') !== 'verify') {
		//If the test type isn't 'verify' there's no 'yes' or 'no' answer so set the answer to 'auto'
          result.set('_answer', this.options.locale.translate('result_answer_auto'));
		  //If automated tests should be hidden then set a class on the <tr> that'll hide them
          if (this.shouldHideAutomatedCheckerResults()) {
            result.set('dimClass', 'automated dim');
          } else {
            result.set('dimClass', 'automated');
          }
        } else {
          if (!result.get('answer')) {
            result.set('_answer', '–');
          } else {
            result.set('_answer', this.options.locale.translate('test_answer_' + result.get('answer')));
          }
        }
        result.set('_category', this.options.locale.translate('result_category_' + result.get('category')));
        return result.toJSON();
      },
          shouldHideAutomatedCheckerResults: function() {
        return !(this.showAutomated);
      },
	  clickShowAutomatedResults: function(event) {
	    //Toggle the state of show automated results
	  	this.showAutomated = !(this.showAutomated);
		//change the text written on the button as it is toggled:
    event.currentTarget.value = (this.showAutomated ? "Hide automated results" : "Show automated results");

	//Now set the CSS class on the results table rows depending on  whether the automated results are shown or hiddden
	$("tr.automated").toggleClass("dim");

        //return this.render();
      }
    });
  });

}).call(this);
