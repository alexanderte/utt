# User Testing Tool

User Testing Tool is the working name of a tool that aims to test websites more completely by providing website owners an open source tool covering a broad rage of tests. While the initial release focuses on accessibility aspects, later releases will include tests about usability and user experience, as well as more technical things.

A primary objective is to integrate with automated testing services, grab test cases that cannot be verified automatically—such as if the alternative text associated with an image is appropriate—and have real users do the testing. The testers will be able to test any site using any device. The accumulated testing data will be analyzed, and used to improve existing tests and/or create new tests.

## Setup

### Dependencies

-  Node.js
-  CoffeeScript

        npm install -g coffee-script

### Backend

    cd backend
    npm install
    cd ..
    ./compile_backend.sh
    node backend/main.js

### Frontend

    ./compile_frontend.sh

## Running

### Backend

    sudo nohup node backend/main.js&!

### Frontend

Serve the frontend directory using any web server.
