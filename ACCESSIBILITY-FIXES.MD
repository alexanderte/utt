#Accessibility fixes

##Accessible progress bar

(frontend/index.html, lines 164-168)

The progress bar now has an **aria-live** value of **polite** and a hidden span containing the progress percentage as a textual number.

This progress bar isn't strictly required on the test page where there's an alternative "Qestion X of Y" progress indicator, but it will come in very useful when operations are taking a long time to complete and user needs to be informed.

##Question X of Y

(frontend/views/test/js, line 74)

This H1 heading receives focus each time a change occurs, so screen reader users are always aware how many questions there are and how far they've progressed through the set.

##Button rather than checkbox to show/hide automated results

(frontend/index.html, line 79)

Semantically, this needs to be a button rather than a checkbox, and its text should change from "Show automated results" to "Hide automated results" depending on the toggle state.

##Automated results hidden rather than dimmed

(frontend/views/result.js, lines 128-138)

In the previous iteration, automated results were dimmed rather than hidden, most likely for debugging purposes, and it wasn't possible for a screenreader user to tell which was an automated and which a verifiable result. Now all rows containing automated results are completely hidden.

##Results summary

Just above the results table there's now a summary that displays the number of pass, fail and verify results. This is more of a usability than an accessibility issue, but it has the added benefit that screenreader users, who can't see the  colour scheme and get an over-all idea  of how the page performed, can have access to those numbers without trying to interact with the table.

##Animation removed

When a new question was displayed, a jQuery **scroll-top** animation was firing off, which caused screenreaders to think the page had totally refreshed and triggered their "read this whole page" mechanism. This animation has been remived.

< hr />

#Fixes still required

##HTML LANG attribute

When the language is switched between English and Norwegian, only parts of the page are translated, and the **lang** attribute isn't changed in the HTML. This needs to be fixed.

##Language menu

The **language** widget is coded as a nested list of links, but one or other of the attached attributes is causing the options to be rendered to the browser's accessibility API as plain text. This needs to be investigated.
