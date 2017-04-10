Introducing Nimble Playbook
------------------

I've built a script that digests yaml config files to automate agaist a Nimble Storage device using Rest calls. I pulled some inspiration from Ansible Playbook and it functions as if given a list of tasks. 

To use:

gem install bimbly

<go to nimble_playbook script location>

./nimble_playbook config.yml playbook.yml

Here you'll need a config.yml file with information on how to access the Nimble array along with a yaml playbook to operate on. There are examples of each file in the /bin folder on the Bimbly project on Github. Along with the two yaml files you'll need a CA cert of the array you are trying to access in order to make calls against it. This CA cert is pointed at in the config.yml file.

The data in the yaml file is broken down for each call as follows:

[operation]:
  [object_set]:
    [id]: value
    [params]:
      key: value
    [request]:
      key: value

You first have to declare an operation, which directly correlates with the operations declared on an object set in the API documentation. You may call an operation on a list of object sets (if the operation is applicable) which is why the object sets are delimited with a '-' in the playbook file.

ex.
---
- create:
  - volumes:
    request:
      name: <volume_name>
      size: <volume_size>
      
  - volumes:
    request:
      name: <second_volume_name>
      size: <second_volume_size>

- update:
  - volumes:
    id: <volume_id>
    request:
      id: <volume_id>
      size: <new_size>

- delete:
  - volumes:
    id: <volume_id>

- move:
  - volumes:
    id: <volume_id>
    request:
      id: <volume_id>
      dest_pool_id: <pool_id>

- restore:
  - volumes:
    id: <volume_id>
    request:
      id: <volume_id>
      base_snap_id: <snapshot_id>

- bulk_move:
  - volumes:
    request:
      vol_ids: <array_of_vol_ids>
      dest_pool_id: <pool_id>

- create:
  - users:
    request:
      name: <name>
      password: <password>

  - users:
    request:
      name: <second_name>
      password: <second_pass>

- update:
  - users:
    id: <user_id>
    request:
      id: <user_id>
      name: <new_name>
      
  - users:
    id: <second_user_id>
    request:
      id: <second_user_id>
      role: 'administrator'

- delete:
  - users:
    id: <user_id>

  - users:
    id: <second_user_id>

Changes to the Bimbly library help facilitate the creation of a Nimble playbook for use by this script. Please check out the README to see how the library can be used, specifically the methods Save, Review, and Create_Playbook.

https://github.com/zumiez/bimbly/blob/master/bin/nimble_playbook

Please reference the API documentation or the Bimbly library to help construct the yaml files.

##Comments##

As can be seen in some of the 'Update' operations above there is an <id> attribute which is usually present in the <request> map as well. I've thought about combining the two to reduce how much to type and possible confusion, but I'm not sure if the <id> will always match <request[id]>. They are used for two seperate parts of the operation and I'm adhering to the documentation until I know that the two variables will be the same across all calls.

Special thanks to Nimble SE Alex Lawrence for suggesting a script to digest yaml files would be very useful and by helping me test out the script before releasing for public consumption. As with any automation tools, use at your own risk.

