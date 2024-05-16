# Power-Notify

Dispatch notifications when battery power is out of user specified range.

## Installation

Just download the `power-notify.sh` bash script.

```bash
wget https://raw.githubusercontent.com/Hephaestus14089/Power-Notify/main/power-notify.sh
```

And make it executable.

```bash
chmod +x power-notify.sh
```

## Usage

Provide the lower limit and upper limit while executing the script.

```bash
./power-notify.sh <lower_limit> <upper_limit>
```

A single argument will be treated as the lower_limit.

```bash
./power-notify.sh <lower_limit>
```

***The limits are interpreted as battery charge percentages.***

## Tips

A nice practice is making the script run as soon as the diplay server is started.  
This can be achieved by putting the script execution command in a file such as `.xinitrc`.
