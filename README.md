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

Usage: kubenv (context|ctx)|(namespace|ns)|save|reload [(cur|current)|all|<value-to-set>]

Sub-commands:

context | ctx
      - With no argument | all - lists all contexts
      - cur | current - lists current context
      - any other argument sets context to that value

namespace | ns
      - With no argument | all - lists all namespaces
      - cur | current - lists current namespaces
      - any other argument sets namespace to that value

save
      - persists changes to ${HOME}/.kube/config

reload
      - reloads kubectl config from ${HOME}/.kube/config
```

You may also use it to show current context/namespace in your Bash prompt like:

```bash
PS1='\W [$(kubenv ctx cur)|$(kubenv ns cur)]\$'
```

## Limitations

This script is currently only designed and tested for Bash shell. PRs welcome!