#!/usr/bin/uv run
# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "roku>=4.1.0",
# ]
# ///
from roku import Roku

def main(tries=0) -> None:
    devs = Roku.discover()
    if not devs:
        print('No devices found')
        if tries > 5:
            print('Gave up')
        print('Trying again...')
        return main(tries+1)

    dev = devs[0]
    print(f'Found device {dev.host}')
    dev.poweroff()

if __name__ == "__main__":
    main()

