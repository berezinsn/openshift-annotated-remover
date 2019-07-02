# Remover of unpaid OpenShift projects 

**Preparing OpenShift environment**:

1. Choosing of default project
`#oc project default` <br />

2. Creating of service account such'll provide access to cluster and permissions for oc commands
`#oc create sa unpaid` 

3. Set permissions for SA
`#oc adm policy add-cluster-role-to-user cluster-admin -z unpaid -n default` 

4. Describe sa to determine token name
`#oc describe sa unpaid` 

5. Determine token-string
`#oc describe secret unpaid-token-<from-output-of-previous-command>` 

6. Place token-key inside the script using command: 
`#oc login https://<link_to_oc>:8443 --insecure-skip-tls-verify=true --token`*

7. Determine full path to oc bin in variable 
 `$oc\_path`

<br />

***Example of token:** 

> eyJhbGciOiJS<--very-long-string-->9jaXBdGVsDDapRXC3bp4Ix1rZVTGw

---
**Script start with CLI**:

Just start bash script when all requirements are meet the conditions
`#./delete.sh` 

If you'd like to try script in new environment you may modify command inside `'out'` variable form `'oc delete project'` to `'oc get project'`
