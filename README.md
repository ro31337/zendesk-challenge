## Challenge

See `Zendesk Coding Challenge.pdf` (not included).

## Demo

[![asciicast](https://asciinema.org/a/6KstAGdGUZLKB9hGoCf1sTwxI.svg)](https://asciinema.org/a/6KstAGdGUZLKB9hGoCf1sTwxI)

## Research

Organization and User are in one-to-many relationship. Proof:

```
$ cat users.json | jq '.[].organization_id'
```

(result is the non-distinct list of organization ids on users "table")

![image](https://user-images.githubusercontent.com/1477672/51815662-6c9a1280-2277-11e9-87b4-64247224ce8e.png)

Shell commands to confirm the point (total number of unique entities for each type):

```
$ cat organizations.json | jq '.[]._id' | wc -l
      26
$ cat users.json | jq '.[]._id' | wc -l
      75
$ cat tickets.json | jq '.[]._id' | wc -l
     200
```

## Run

```
$ bundle
$ ruby app.rb
```

or with Docker:

```
TODO
```

## Tests

Run `rspec` to run tests

## How to use

Keep json files in the same directory. 

* Tab to autocomplete
* `..` - go to one level app
* `exit` (or `quit`) - exit the program

## Design decisions

The following relationships were modeled:

```ruby
class User < Model
  include BelongsTo
  include HasMany

  def as_text
    super + \
      has_many('submitter_id', 'tickets', 'ticket (submitter)', %w[_id subject]) + \
      has_many('assignee_id', 'tickets', 'ticket (assignee)', %w[_id subject]) + \
      belongs_to('organization_id', 'organizations', 'organization')
  end
end

class Organization < Model
end

class Ticket < Model
  include BelongsTo

  def as_text
    super + \
      belongs_to('organization_id', 'organizations', 'organization') + \
      belongs_to('submitter_id', 'users', 'submitter') + \
      belongs_to('assignee_id', 'users', 'assignee')
  end
end
```

Search by tag name is supported. Type 'tags' as search term and type tag name.

## Caveats

1) For simplicity, searchable fields are defined only by the first record. For example, if first user record is missing `email` field, tool will not allow to search over other records by email, even email is present. This can be easily improved.

2) Program assumes all files are present. Cases without missing files are not covered.

3) Program assumes all json files are valid.

4) Program relies on certain json schema when specifying relationships.

5) There are 10 tests only, some classes were not covered with tests (need more time).

## Notes

> The user should also be able to search for empty values, e.g. where description is empty

There are no "empty" values in any of json files, but there are missing properties. For example, user with id 11 has missing "email" field. Since technically it's not initialized, search will not produce any results. Definition of "empty" usually means "initialized with empty value". Search over _initialized_ empty values is supported by implementation. For example, add empty `email` field to `users.json` to see results:

```
Select one of the following tables (press Tab for autocomplete):
---
organizations
tickets
users
> users
Enter search term (press Tab for autocomplete):
users> email
Enter search value:
users.email>
========================================
_id             : 11
url             : http://initech.zendesk.com/api/v2/users/11.json
external_id     : f844d39b-1d2c-4908-8719-48b5930bc6a2
name            : Shelly Clements
alias           : Miss Campos
created_at      : 2016-06-10T06:50:13 -10:00
active          : true
verified        : true
shared          : true
locale          : zh-CN
timezone        : Moldova
last_login_at   : 2016-02-28T04:06:24 -11:00
phone           : 9494-882-401
signature       : Don't Worry Be Happy!
organization_id : 103
tags            : ["Camptown", "Glenville", "Harleigh", "Tedrow"]
suspended       : false
role            : agent
email           :
...
```

## Author

Author: Roman Pushkin

Contacts: roman.pushkin@gmail.com
