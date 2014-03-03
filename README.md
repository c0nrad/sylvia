Sylvia
=========

![Sylvia Screeny](https://raw.github.com/c0nrad/sylvia/master/public/images/screeny.png)

Project Sylvia was my foolish attempt to beat the [turing test](http://en.wikipedia.org/wiki/Turing_test) during a 20 hour hackathon.

The idea behind Sylvia was that no single source of information or algorithm would be enough. So instead she would grab from different types of sources and do different types of analysis and combine them from a final result.

In the makes there are few times of anlaysis

* **BaseIntel** Sylvia scrapes wikipedia and creates a graph of the words and their relations.
* **Expereiences** Sylvia reads her book *The Bell Jar* to learn who she is. Also I added a self-aware component. She related everything to herself.
* **Language Semantics** Sylvia reads movie scripts to learn how to speak. She also will be preprogramed with general sentence structure forms. Like Subject-verb-object.

Originally I only did BaseIntel, but, no one wants to talk to a wikipedia. We look for relations and connections to other people. That's why I made her self aware, she tried to relate things to herself personally. Now with this information she needs a way to communicate with us through english, not a graph. This is where sylvia is now, learning how to speak about her expereinces and herself.

Installation
-

Prerequisites
  * NodeJS (I use v0.10.25)
  * npm
  * MongoDB

Installation
  * git clone https://github.com/c0nrad/sylvia.git
  * cd sylvia
  * npm install
  * npm install -g nodemon

Run
  * nodemon app.coffee

Questions/Comments
-
Please contact Stuart Larsen at (sclarsen@mtu.edu)