## Overview

Google’s Page Speed Insights is a web service that rates website performance.
This Rails API application uses that service to test if a website meets specified
performance criteria. The performance criteria to be evaluated are:

**Time to First Byte (TTFB)**\
The time it takes for the web server to start responding with data

**Time to First Meaningful Paint (TTFP)**\
The time it takes for the browser to paint the page on the screen

**Time to Interactive (TTI)**\
The time it takes for all JavaScript to be downloaded, parsed, and executed

**Speed Index**\
Google’s speed rating for the site

Get an API key on this page to use Google’s Page Speed Insights:
https://developers.google.com/speed/docs/insights/v5/get-started
<br/>
<br/>

When you run tests, optionally specify an interval to rerun tests in background.
The app will email provided recipients details of failed tests.
It's that simple :sunglasses:

P.S. Check out [rspec](https://github.com/rspec/rspec-rails)'s job and mailer
tests. See how ease to request third parties with Ruby and build JSON responses
with [ActiveModel::Serializer](https://github.com/rails-api/active_model_serializers).
<br/>
<br/>

### Dependencies
Ruby 2.6.5\
Rails 5.2.4.1\
PostgresSQL database

### Getting Started
1. Clone the repo
1. `cd perf-monitor`
1. Save following environment variables with their values in `.env.development` file
    ```
    POSTGRESQL_USERNAME=<your psql username here>
    POSTGRESQL_PASSWORD=<psql password>

    PAGE_SPEED_API_KEY=<Google’s Page Speed Insights API KEY>

    MAILER_DEFAULT_FROM=<the email address to send test failure emails from>
    RECEIVER_EMAILS=<recipients emails separated by comma>
    ```
1. `rails db:setup`
1. `rails s` to start the server

#### Run tests
`bundle exec rspec`
<br/>
<br/>

## API endpoints
### Make a test
**Endpoint**: `/tests`\
**Request method**: `POST`\
**Request header**: `Content-Type: application/json`\
**Request parameters**: with example values
```
{
  "url": "https://rubylabs.am",    // required - the website URL to run test against
  "max_tti": 700,                  // required - the max time to interactive to allow in milliseconds
  "max_ttfb": 700,                 // required - the max time to first byte to allow in milliseconds
  "max_ttfp": 700                  // required - the max time to meaningful paint to allow in milliseconds
  "max_speed_index": 700,          // required - the max speed index to allow in milliseconds
  "rerun_in_mins": 30              // optional - the interval to rerun the test in minutes
}
```
**Response**:
```
{
  "passed": true,
  "tti": 646,
  "ttfb": 79,
  "ttfp": 646,
  "speed_index": 646
}
```
**CURL example of the request**:
```bash
curl -X POST  -H 'Content-Type: application/json' -d '{"url":"https://rubylabs.am","max_ttfb":700,"max_tti":700,"max_speed_index":700,"max_ttfp":700}' http://localhost:3000/tests
```
<br/>

### Get the last test result of a specific website
**Endpoint**: `/tests/last`\
**Request method**: `GET`\
**Request parameter**: `url` - required\
**Response**:
```
{
  "passed": true,
  "ttfb": 79,
  "ttfp": 646,
  "tti": 646,
  "speed_index": 646,
  "url": "https://rubylabs.am",
  "max_ttfb": 700,
  "max_ttfp": 700,
  "max_tti": 700,
  "max_speed_index": 700,
  "created_at": "2020-02-08 01:13:03 UTC"
}
```
**CURL example of the request**:
```bash
curl -X GET http://localhost:3000/tests/last?url=https://rubylabs.am
```
<br/>


### List all test results of a specific website
**Endpoint**: `/tests`\
**Request method**: `GET`\
**Request parameter**: `url` - required\
**Response**:
```
[
  {
    "passed": true,
    "ttfb": 83,
    "ttfp": 660,
    "tti": 660,
    "speed_index": 588,
    "url": "https://rubylabs.am",
    "max_ttfb": 700,
    "max_ttfp": 700,
    "max_tti": 700,
    "max_speed_index": 700,
    "created_at": "2020-02-08 01:10:16 UTC"
  },
  ...
]
```
**CURL example of the request**:
```bash
curl -X GET http://localhost:3000/tests?url=https://rubylabs.am
```
