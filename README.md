
# Lab42Console

[![Build Status](https://travis-ci.org/RobertDober/lab42_console.svg?branch=master)](https://travis-ci.org/RobertDober/lab42_console)
[![Gem Version](https://badge.fury.io/rb/lab42_console.svg)](http://badge.fury.io/rb/lab42_console)
[![Code Climate](https://codeclimate.com/github/RobertDober/lab42_console/badges/gpa.svg)](https://codeclimate.com/github/RobertDober/lab42_console)
[![Issue Count](https://codeclimate.com/github/RobertDober/lab42_console/badges/issue_count.svg)](https://codeclimate.com/github/RobertDober/lab42_console)
[![Test Coverage](https://codeclimate.com/github/RobertDober/lab42_console/badges/coverage.svg)](https://codeclimate.com/github/RobertDober/lab42_console)

Intrusive Ruby Tools for the Console Only

## Applying operations to collections

By using `by` we create what one could call a _compaignon_ collection which can be transformed, at the end
we can use finders and filters on these compagnon collection to access the original data

Let us for example suppose that we have the following data

```ruby :include
    let(:data) {
      (0..9).map{ |n|
        OpenStruct.new(id: n, name: "name #{n}", content: (0..n).map{ |k| "data #{k}" })
      }
    }

```
Now we can filter the **original** data by selecting on some transformations on the compagnon collection, firstly we create a compagnon collection which
contains only the names:

```ruby :include
  let(:compagnon){ data.by(:name) }
```

Now we can access the original for example as follows

```ruby :example Find original by means of a compagnon
    expect(compagnon.fnd("name 1")).to eq(data[1])
```

We can chain `by` as much as we want

```ruby :include
    let(:children_count) { data.by(:content).by(:size) }
```

And select on children count

```ruby :example Select by count of children
    expect(children_count.sel(:>, 8)).to eq(data[8..9])
```


## Author

Copyright © 2019,20 Robert Dober
mailto: robert.dober@gmail.com

# LICENSE

Same as Elixir -- ;) --, which is Apache License v2.0. Please refer to [LICENSE](LICENSE) for details.

SPDX-License-Identifier: Apache-2.0

