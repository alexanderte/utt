(function() {
  define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
    return Backbone.View.extend({
      el: '#result-view',
      events: {
        //'change #hideAutomatedCheckerResults': 'clickDim'
		'click #showAutomatedResults': 'clickShowAutomatedResults'
      },
      initialize: function() {
	  	  this.showAutomated = false;
        //this.render();
        this.options.router.bind('all', function(route) {
          if (route === 'route:result') {
		  this.render();
            return this.$el.show();
          } else {
            return this.$el.hide();
          }
        }, this);
        this.options.locale.on('change:locale', this.render, this);
        //this.options.testRun.bind('change:state', this.render, this);
        //return this.options.testRun.on('change:answer', this.render, this);
		return this;
      },
      render: function() {
        var checked, test, tests, verifyTests, summary, _i, _len, _ref, _cat;

        if (this.options.testRun.get('state') === 'error') {
          return this.$el.html(_.template($('#result-template-error').html(), {
            webPage: this.options.testRun.get('webPage')
          }));
        } else if (this.options.testRun.get('state') === 'loading') {
          return this.$el.html(_.template($('#result-template-loading').html(), {
            webPage: this.options.testRun.get('webPage')
          }));
        } else {
          tests = [];
		  summary = new Object();
          verifyTests = this.options.testRun.getVerifyTests();
          _ref = this.options.testRun.get('tests').models;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            test = _ref[_i];
			_cat = test.get('category');
			if (_cat in summary) {
			summary[_cat] = summary[_cat] + 1;
			} else {
			  summary[_cat] = 1;
			}
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
          result.set('_answer', this.options.locale.translate('result_answer_auto'));
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
	  	      this.showAutomated = !(this.showAutomated);

//change the aria-pressed value as the button is toggled:
    event.target.setAttribute("aria-pressed", this.showAutomated ? "true" : "false");

	//Now toggle whether the automated results are shown or hiddden
	$("tr.automated").toggleClass("dim");

        //return this.render();
      }
    });
  });

}).call(this);
