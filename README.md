# terraform-aws-alert #

Summary: AWS Lambda function written in python post slack message when there is an ERROR in cloudwatch logs.  This uses log subscription filter and lambda resources automated with Terraform.

![ci](https://github.com/conventional-changelog/standard-version/workflows/ci/badge.svg)
[![version](https://img.shields.io/badge/version-1.x-yellow.svg)](https://semver.org)

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#Features)
* [Usage](#usage)
* [Project Status](#project-status)

## General Information
- automate setup of terraform-aws-alert

## Technologies Used
- terraform
- github actions
- python script using slack api
- lambda
- AWS Cloudwatch log subscription filter

## Features

* create log subscription filter
* lambda function that parses cloudwatch logEvents
* POST slack message
    * message includes console link to log stream error
    * link filter using timestamp
    * account
    * log group
    * log stream 
    * error 

## Usage

* look at examples/basic/main.tf for example

## Project Status
Project is: _in_progress_ 
