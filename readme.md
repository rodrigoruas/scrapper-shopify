## Usage

Clone this repository:

In `run.rb` , set the files names :

```
data_file = "my_csv_file.csv"

```

In terminal, run:

```
gem install httparty
gem install threads
gem install nokogiri
mkdir emails
```

In `run.rb` , write the interval you want to search. From 0 to 192.000
```
start_index = 0
end_index = 500

```

If for some reason, you are being blocked, you can slow down the speed of search in methods.rb file. 
Change the number between 100 and 500.

```
pool = Thread.pool(200)

```

And run :

```
ruby run.rb
```

