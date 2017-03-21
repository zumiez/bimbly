Bimbly
===================

A Ruby library for interacting with Nimble Storage devices using ReST and RPC calls, as well as navigating the API documentation

# Table of Contents
------------------------------

* [Mission Statement](#mission-statement)
* [How to Install](#how-to-install)
* [Available Methods](#available-methods)
    * [New Connection(#new-connection)
    * [Menu](#menu)
    * [Details](#details)
    * [Reset](#reset)
    * [Doc](#doc)
    * [Parameters](#parameters)

# Mission Statement
------------------

When first searching through the API docs before setting down to write the code, I realized just how vast and thorough the docs were. And then I realized I could leverage this. As a user of my own library, I wanted a way to ask the library what my options were when interacting with a Nimble Storage device rather than just try to memorize all of my options.

Imagine sitting at a Nimble Storage restaurant wanting to order something to do with a device:

A waiter/waitress comes by and hands you a menu.

You decide you want to create_volumes.

The waiter/waitress then asks, "What kind of parameters do you want?"

As a user, I want to be able to ask, "What do you got?"

This is what lead me to parse the API docs into 4 yaml files that could be used to generate methods and also be interacted with in order to talk to Nimble Storage devices on another level - knowing exactly what you want before sending potentially dangerous commands or getting ambiguous replies and deciphering error codes.

# How to Install
-------------

Most of the methods in the library are generated at run-time, but they are based off of the underlying API documentation. To use the library in its current form, you can install the gem with:

```
gem install bimbly
```

Then you can load the library either in a script or using irb with the line:

```
require 'bimbly'
```

# Available Methods
---------------------------

The rest of this documentaiton will be focused on the *interactive* aspect of this library to show the extent of its usefullness. 

You can either pass the connection information when you instantiate the class or when 

```
nimbly = Bimbly.new( array:    array_name,
                     cert      cert_name,
                     port:     port,	   #default - 5392
                     user:     username,
                     password: password )
```

OR

```
nimbly = Bimbly.new
nimbly.new_connection( array:    array_name,
                       cert:     cert_name,
                       port:     port,	
                       user:     username,
                       password: password )
```

The `new_connection` method can be used at any time to switch between devices as well.

Connection information can also be loaded with a yaml file using the :file option.

```
nimbly.new_connection(file: 'array_info.yml')
```

If you'd like to have one file with a bunch of arrays information, you can set up connections based on a selection from the file using :file_select

```
nimbly = Bimbly.new(file: 'array_info.yml')
nimbly.new_connection(file_select: 'array1')
```

Once a connection is set up, then the available methods can be seen by using:

```
nimbly.menu
```

Or narrowed down with

```
nimbly.menu.grep /volumes/
nimbly.menu.grep /read/
```

I have menu returning the underlying Array data structure so that it can be operated on. If you'd like it more readable you can print it cleanly using `puts`

Once an appropriate method has been selected, you can then call it on the `nimbly` Object

```
nimbly.read_volumes
```

When one of rest methods are called it loads the necessary instance variables to be operated on. If you'd like to see the details of what

params = { 'startRow': '0', 'endRow': '5' }
nimbly.read_volumes(params: params)
=> get
=> https://domain.something.com:12345/v1/volumes?startRow=0&endRow=5

```

This Code is Still Under Heavy Construction
--------------------------------

Right now it only prints out the information it will send to a Nimble Storage device, but once I've got a good testing environment I will make sure this portion works as well. 

TODO
- [ ] Finish way to navigate documentation
- [ ] Implement parameter querying
- [ ] Implement error querying
- [ ] Implement data type querying
- [ ] Finish the Interactive Shell portion