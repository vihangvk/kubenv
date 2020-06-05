# kubenv - Work on multiple Kubernetes clusters/namespaces in interactive shell

kubenv enables working on different Kubernetes clusters/namespaces by setting separate contexts for each interactive shell sessions.

## Using

Source the script or add to Bash profile like:

```bash
source <checkout-directory>/kubenv.sh
```

Then you can set/view kubectl context/namespace as below:

```bash
$ kubenv
kubenv allows to set kubectl context/namespace for current shell session.
You can also persist changes using 'save' command.
Remember to 'save' changes if you add new context (i.e. connect to new cluster).

Usage:
      kubenv [use [on|off]]|save|reload
      kubenv [(contexts|ctx)|(namespaces|ns)] [(cur|current)|all|-|<value-to-set>]

Sub-commands:

use
      - on - enables kubenv
      - off - disables kubenv
      - (no argument) - toggles kubenv

contexts | ctx
      - With no argument | all - lists all contexts
      - cur | current - lists current context
      - - (hyphen) - switch to previous context
      - any other argument sets context to that value

namespaces | ns
      - With no argument | all - lists all namespaces
      - cur | current - lists current namespaces
      - - (hyphen) - switch to previous namespace
      - any other argument sets namespace to that value

save
      - persists changes to ${HOME}/.kube/config

reload
      - reloads kubectl config from ${HOME}/.kube/config
```

You need to enable `kubenv` before you can use it:

```bash
kubenv use
```

You may also use it to show current context/namespace in your Bash prompt like:

```bash
PS1='\W [$(kubenv ctx cur)|$(kubenv ns cur)]\$'
```

## Limitations

This script is currently only designed and tested for Bash shell. PRs welcome!