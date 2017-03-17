Nimble Interactive Shell and ReST Client (NaRC)
===================

A Ruby library for interacting with Nimble Storage devices using ReST and RPC calls, as well as navigating the API documentation

Mission Statement
------------------

When first searching through the API docs before setting down to write the code, I realized just how vast and thorough the docs were. And then I realized I could leverage this. As a user of my own library, I wanted a way to ask the library what my options were when interacting with a Nimble Storage device rather than just try to memorize all of my options.

Imagine sitting at a Nimble Storage restaraunt wanting to order something to do with a device:

A waiter/waitress comes by and hands you a menu.

You decide you want to create_volumes.

The waiter/waitress then asks, "What kind of parameters do you want?"

As a user, I want to be able to ask, "What do you got?"

This is what lead me to parse the API docs into 4 yaml files that could be used to generate methods and also be interacted with in order to talk to Nimble Storage devices on another level - knowing exactly what you want before sending potentially dangerous commands or getting ambiguous replies and deciphering error codes.

How to Use
-------------

Most of the methods in the library are generated at run-time, but they are based off of the underlying API documentation. To use the library in its current form, you load the library either in a script or using irb with the line:

```
require "./lib/narc.rb"
```

You can either put the connection information in the /lib/client_data.yml file which will be loaded at start up, or you can input the information yourself either by:

```
nimble = Narc.new( array:    'array_name',
                   cert:     'cert_name',
                   port:     'port',	   #default - 5392
                   user:     'username',
                   password: 'password' )
```

OR

```
nimble.new_connection( array:    'array_name',
       	               cert:     'cert_name',
                       port:     'port',	   #default - 5392
                       user:     'username',
                       password: 'password' )
```

the `new_connection` method can be used at any time to switch between devices as well

Once a connection is set up, then the available methods can be seen by using:

```
nimble.available_methods
```

Or narrowed down with

```
nimble.available_methods.grep /volumes/
nimble.available_methods.grep /read/
```

(I plan on fleshing out this piece a bit more)

Once an apropriate method has been selected, you can then call it on the `nimble` Object

```
nimble.read_volumes
=> get
=> https://domain.something.com:12345/v1/volumes

params = { 'startRow': '0', 'endRow': '5' }
nimble.read_volumes(params: params)
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