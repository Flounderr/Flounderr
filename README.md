# Flounder
Flounder is an app which allows users to click pictures of flyers and detects the date and details of the event, adding them to calendar and Google calender.

## User stories
-The following are **required** functionalities

 - [x] Users can log in 
 - [x] Users can take a picture of a flyer
 - [x] App can detect the date and event name on the flyer as well as the location with some accuracy
 - [ ] Users can edit the event details after the details are detected
 - [ ] App adds the event to the calendar and google calendar

-The following are **optional** functionalities

 - [ ] Ability to post events to the app
 - [ ] Carpool button allows user to send carpool requests to event poster
 - [ ] User can choose how many carpool requests they'd like to allow
 - [ ] Carpool button greys out after 1-5 carpool requests are accepted

## Deliverables
Columns in Parse:
 - Username within the app
 - Username for Google account
 
APIs we are using:
 - Parse
 - Google Calendar
 - Tesseract
 
Model classes we need so far:
 - User

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/mmfDzqY.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## Things that need to be done from 4/1/2016 ~
 - Somehow detect event names, dates, places from the recognized text
 - Integrate Google Calendar
 - Be able to display event details when clicking on the days on the calendar
 - Possibly add some more training data for Tesseract
 - Improve UI

## License

       Copyright [2016] []

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
