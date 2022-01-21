# awsswitch

An **aws-vault** helper

***

## Synopsis

If you are using **[aws-vault](https://github.com/99designs/aws-vault)** to manage several accounts with different roles then you probably are tired of always write *aws-vault exec profile --- aws \<something\>*

This simple script avoid the direct use of *aws-vault exec* and allows you to simply run awscli commands like *aws s3 ls* instead.

***

## Assumptions

This script only works on top of *aws-vault* so you need first to get your copy of *aws-vault* installed and configured with all your AWS profiles working properly.

## Install

1. Download a copy of this repository:

```

cd ${HOME}

git clone https://github.com/emanuelpsilva/awsswitch.git

```

2. Install the script into some path folder (in this example we'll use /usr/local/bin)

```

cp ${HOME}/awsswitch/awsswitch.sh /usr/local/bin/

chmod +x /usr/local/bin/awsswitch.sh

```

> Case you want remove some profiles from the menu list, edit **awsswitch.sh** file and add them to the **IGNORE_PROFILES** variable.

3. Run the script for first configuration (follow directions)

```

awsswitch.sh

```

4. Add an alias to your shell profile (in this example we'll use .zprofile)

```

printf "\n#alias to use awsswitch\nalias aws=awsswitch.sh\n" >> ${HOME}/.zprofile

```

> Don't forget to restart your shell terminal to make the alias active

## How to use

- Any time you need to change current AWS profile (account), just run:

```

aws

```

The choosed profile will stay active until you run again above command

- Any time you want to run some aws command, just run:

```

aws <your parameters here, i.e.: s3 ls>

```
- Case you want use inside a script, because alias are not available, you need to use like this:
```
awsswitch.sh <your parameters i.e.: s3 ls>
```

## References

  

*  [aws-vault](https://github.com/99designs/aws-vault)

***
## Contributors
Thanks @MASNathan for the kickstarter push in this great ideia :)
