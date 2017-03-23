Bimbly
===================

A Ruby library for interacting with Nimble Storage devices using ReST and RPC calls, as well as navigating the API documentation

# Table of Contents
------------------------------

* [Mission Statement](#mission-statement)
* [How to Install](#how-to-install)
* [Available Methods](#available-methods)
    * [New Connection](#new-connection)
    * [Menu](#menu)
    * [Doc](#doc)
    * [Parameters](#parameters)
    * [Request](#request)
    * [Data Types](#data-types)
    * [Details](#details)
    * [Reset](#reset)    
    * [Call](#call)
    
# Mission Statement
------------------

nnWhen first searching through the API docs before setting down to write the code, I realized just how vast and thorough the docs were. And then I realized I could leverage this. As a user of my own library, I wanted a way to ask the library what my options were when interacting with a Nimble Storage device rather than just try to memorize all of my options.

Imagine sitting at a Nimble Storage restaurant wanting to order...something to do with a device:

A waiter/waitress comes by and hands you a menu.

You decide you want to create_volumes.

The waiter/waitress then asks, "What kind of parameters do you want?"

As a user, I want to be able to ask, "What do you got?"

This is what lead me to parse the API docs into 4 yaml files that could be used to generate methods and also be interacted with in order to talk to Nimble Storage devices on another level - knowing exactly what you want before sending potentially dangerous commands or getting ambiguous replies and deciphering error codes.

# How to Install
-------------

Bimbly generates 164 methods when instantiated, all of which are based off of data parsed from the API documentation. These methods can be seen with the `.menu` method as described below. The methods that are generated are used to prep the library for ReST calls to a nimble device. To use the library, you can install the gem with:

```
gem install bimbly
```

Then you can load the library either in a script or using irb with the line:

```
require 'bimbly'
```

The rest of this documentation will be focused on the *interactive* aspect of this library to show the extent of its usefullness, though the library is just as powerful in scripts as well. To remove some unwanted clutter in `irb` that happens because of the returned objects during use, you can turn off the echo in `irb` with:

```
conf.echo = false
```

# Available Methods
---------------------------

Most of the available methods are generated at runtime based on information pulled from the API docs. These methods are the ones used to prep the library for a call to the nimble array. The remaining methods are used to initialize the connection, navigate the documentation or to see what the library is capable of on top of the ReST calls.

## New Connection
------------------

You can either pass the connection information when you instantiate the class or when 

```
nimble = Bimbly.new( array:    array_name,
                     cert      cert_name,
                     port:     port,	   #default - 5392
                     user:     username,
                     password: password )
```

OR

```
nimble = Bimbly.new
nimble.new_connection( array:    array_name,
                       cert:     cert_name,
                       port:     port,	
                       user:     username,
                       password: password )
```

The `new_connection` method can be used at any time to switch between devices as well.

Connection information can also be loaded with a yaml file using the :file option.

```
nimble.new_connection(file: 'array_info.yml')
```

If you'd like to have one file with a bunch of arrays information, you can set up connections based on a selection from the file using :file_select

```
nimble = Bimbly.new(file: 'array_info.yml')
nimble.new_connection(file_select: 'array1')
```

A sample configuration .yml file can be set up as follows:

```
---
array1: 
  name: "Nimble API"
  cert: "CA.crt"
  user: "username"
  password: "password"
  array: "array_name"
  port: "5392"
```

## Menu
----------

Methods that are generated at runtime store their names in an array that can be accessed with:

```
nimble.menu
=> puts nimble.menu
create_access_control_records
delete_access_control_records_by_id
read_access_control_records
read_access_control_records_detailed
read_access_control_records_by_id
create_active_directory_memberships
read_active_directory_memberships
read_active_directory_memberships_detailed
read_active_directory_memberships_by_id
remove_active_directory_memberships_by_id
report_status_active_directory_memberships_by_id
test_group_active_directory_memberships_by_id
test_user_active_directory_memberships_by_id
update_active_directory_memberships_by_id

...
```

Or narrowed down with

```
nimble.menu.grep /volume/
nimble.menu.grep /read/
```

I have menu returning the underlying Array data structure so that it can be operated on. If you'd like it more readable you can print it cleanly using `puts` in front.

Each method that has been generated will load information about the call into the `nimble` object. We can inspect the information loaded before making a call to the Nimble device using the following methods.

## Doc
-----------

If you'd like to see the actual documentation about the ReST call that's been selected you use the `doc` method to produce a YaML formatted version of it.

```
nimble.read_volumes.doc
```

OR

```
nimble.read_volumes
nimble.doc
```

## Parameters
------------

Nimble allows a great deal of parameters to be available for its ReST calls. To see what parameters are available for a particular call you can use:

```
nimble.read_volumes.parameters
```

## Request
----------------

The `request` method will return the documentation on all of the available attributes and their details for the method that's been selected. This is a good resource for when you are sending a PUT or POST and want to know what you can change and what default values are. Mandatory attributes will be alerted when you try to load a method, but you can see the details of those attributes here as well.

```
nimble.update_users_by_id(id: 'USER_ID', payload: payload)

nimble.request
=> [Lots of data available about each possible attribute]
```

## Data Types
------------------

Each parameter has a data type associated with it. Information about each data type is available using:

```
nimble.read_volumes.data_types
```

OR inspected individually with:

```
nimble.data_type('NsTime')
```

## Details
------------------

Details about the ReST variables that have been generated can be viewed using the `details` method

```
params = { 'startRow' = '0', 'endRow' = '5' }
nimble.read_volumes(params: params)
nimble.details
=>
  URI: https://NIMBLE_ARRAY:5392/v1/volumes?startRow=0&endRow=5
  Verb: get
  Payload: n/a
```

## Reset
------------

If you don't like the method that's been loaded you can `reset` it.

```
nimble.reset
```

This method is called after each use of `call` and clears the environment

## Call
-------------

This is the method that tells the library to send the ReST call to the Nimble device. 

```
nimble.read_volumes_by_id(id: 'id_of_volume').call
```

There are 3 types of options that can be passed to a ReST method.

```
id:      This is substituted into the URI when a `_by_id` method is called
params:  This is a hash variable that is attached to the end of the URI for the call
payload: Either a hash or json object to be passed with POST or PUT calls to the device
```

Examples of what each type of call look like:

```
GET

nimble.menu.grep /read/
=> [Array of 'read' options]

nimble.read_volumes.details
=>
Method Selected: read_volumes
URI: https://NIMBLE_ARRAY:5392/v1/volumes
Verb: get
Payload: n/a

nimble.call
=> [Metric butt-load of information]
```

```
POST

nimble.menu.grep /create/
=> [Array of 'create' options]

nimble.create_users
=>
ArgumentError: Must supply :payload with attributes ["name", "description", "role", "password", "inactivity_timeout", "full_name", "email_addr", "disabled"] on create_users

nimble.doc
=> [To check out the sweet, sweet options]

payload = { 'name' => 'hello' }
=> {"name"=>"hello"}

nimble.create_users(payload: payload)
=>
ArgumentError: 'description' is a mandatory attribute in the payload for create_users: Please supply ["name", "description", "role", "password", "inactivity_timeout", "full_name", "email_addr", "disabled"]

nimble.details
=>
Method Selected: create_users
URI: https://NIMBLE_ARRAY:5392/v1/users
Verb: post
Payload: {"name"=>"hello"}

(When payload is set up correctly)
nimble.call
```

```
PUT

nimble.menu.grep /update/
...

nimble.update_users_by_id(id: 'USER_ID')
=>
ArgumentError: Must supply :payload with attributes ["id", "name", "description", "role", "password", "auth_password", "inactivity_timeout", "full_name", "email_addr", "disabled"] on update_users_by_id

payload = { id: 'id', name: 'name', description: 'desc', role: 'role', password: 'pass', auth_password: 'auth_pass', inactivity_timeout: "out_time", full_name: 'nimbly', email_addr: 'nimbly@bimbly.org', disabled: 'nope' }

nimble.update_users_by_id(id: 'USER_ID', payload: payload)

nimble.details
=>
Method Selected: update_users_by_id
URI: https://NIMBLE_ARRAY:5392/v1/users/USER_ID
Verb: put
Payload:
{:id=>"id",
 :name=>"name",
 :description=>"desc",
 :role=>"role",
 :password=>"pass",
 :auth_password=>"auth_pass",
 :inactivity_timeout=>"out_time",
 :full_name=>"nimbly",
 :email_addr=>"nimbly@bimbly.org",
 :disabled=>"nope"}
```

```
DELETE

irb(main):014:0> nimble.details
Method Selected: delete_users_by_id
URI: https://NIMBLE_ARRAY:5392/v1/users/NEW_ID
Verb: delete
Payload: n/a
```

This Code is Still Under Heavy Construction
--------------------------------

Right now it only prints out the information it will send to a Nimble Storage device, but once I've got a good testing environment I will make sure this portion works as well. 

TODO
- [x] Finish way to navigate documentation
- [x] Implement parameter querying
- [x] Implement error querying
- [x] Check parameters passed to those that are available for the method
- [x] Implement data type querying
- [x] Check payload against mandatory attributes
- [x] Check payload against available attributes
- [ ] Finish the Interactive Shell portion
- [ ] Update library to load API docs v4.1 and be interchangeable
