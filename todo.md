#To do

* Stop all views from rendering when the application starts. Currently a set of test results is being un necessarily rendered using the default webpage. Render each view only when it's required.
* Wrap the **h1** tag in its own view. Consider giving it a model that holds the current content of the h1 and fires an event when the content is change. Then the view can listen for that event and update itself accordingly. Also another function can listen for the same event and change the document title as the h1 changes.
* Disable the textbox and button that allow the page being tested to be changed in the middle of a test.
* Use **coffee* to convert **backend/main.js** from CoffeeScript to JavaScript, and tweak the **deploy.sh** shell script to run this using nodejs instead.