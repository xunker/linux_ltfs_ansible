# ltfs-tape-watcher

Watch for tape to be inserted, and automatically mount tape if LTFS-formatted

## FLOW

* --START--
  * Check if tape already mounted, or something is mounted in /mnt/ltfs
    * If already mounted, goto --SLEEP--
  * Check if tape is inserted
    * If no tape, goto --SLEEP--
  * Get tape info and log it
  * Check if inserted tape is in LTFS format
    * If tape not in LTFS format, goto --SLEEP--
  * mount tape in /mnt/ltfs
    * If mounting returns error, goto --ERROR-
    * Verify mounted by parsing mount(1) or mtab(1) output
    * Check that /mnt/ltfs doesn't contain only our ".keep" file
    * Log the free space
    * if any of the return an error, goto --ERROR-
* --SLEEP--
  * sleep for XX seconds
* goto --START--
* --ERROR--
  * log last error and exit with status <> 0


---

# ls

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/ls/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Matthew Nielsen](https://github.com/your-github-user) - creator and maintainer