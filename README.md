# Vagrant: Puppet autosign

## Table of Contents

1. [Description](#description)
1. [Requirements](#requirements)
1. [Usage](#usage)
1. [Reference](#reference)
1. [Authors](#authors)
1. [License](lLicense)

## Description

Vagrant environment for testing autosign.

## Requirements

The following tools are needed to use this environment:

* vagrant >= 2.0.3
* vagrant-hostmanager >= 1.8.7
* vagrant-vbguest >= 0.15.1
* librarian-puppet >= 2.2.3

## Usage

Fetch the Puppet modules with librarian-puppet.

```
cd environments/production/
librarian-puppet install --verbose
```

Start the puppetmaster

```
vagrant up puppetmaster
```

ssh to the puppet master and generate an autosign token:

```
vagrant ssh puppetmaster
sudo /opt/puppetlabs/puppet/bin/autosign --config=/etc/autosign.conf generate -r -t 31556926 *.example.local
```

The output should look something like this:

```
$ sudo /opt/puppetlabs/puppet/bin/autosign --config=/etc/autosign.conf generate -r -t 31556926 *.example.local
INFO  -- Autosign : generated token for: *.example.local
Autosign token for: *.example.local, valid until: 2019-04-17 16:14:31 +0000
To use the token, put the following in ${puppet_confdir}/csr_attributes.yaml prior to running puppet agent for the first time:

custom_attributes:
  challengePassword: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJkYXRhIjoie1wiY2VydG5hbWVcIjpcIiouZXhhbXBsZS5sb2NhbFwiLFwicmVxdWVzdGVyXCI6XCJwdXBwZXRtYXN0ZXJcIixcInJldXNhYmxlXCI6dHJ1ZSxcInZhbGlkZm9yXCI6MzE1NTY5MjYsXCJ1dWlkXCI6XCI1YjU4OGFlYS1lMDUxLTQyNGYtOTVjZS0wMjYxNjQ0N2ViYThcIn0iLCJleHAiOiIxNTU1NTE3NjcxIn0.K0KQyD2A5V2iPX_7OHJiibLQFOzk4anDD_5bk-m66eyd1Yq0-UYdQtgR1rLPTXUaVJH4iozTDf5HnFfrVQ9ENw"
```

If you want you can tail the log file

```
sudo tail -f /var/log/autosign.log
```

Next start the node and pass the challenge password:

```
CHALLENGEPASSWORD="" vagrant up node
```

For example:

```
CHALLENGEPASSWORD="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJkYXRhIjoie1wiY2VydG5hbWVcIjpcIiouZXhhbXBsZS5sb2NhbFwiLFwicmVxdWVzdGVyXCI6XCJwdXBwZXRtYXN0ZXJcIixcInJldXNhYmxlXCI6dHJ1ZSxcInZhbGlkZm9yXCI6MzE1NTY5MjYsXCJ1dWlkXCI6XCI1YjU4OGFlYS1lMDUxLTQyNGYtOTVjZS0wMjYxNjQ0N2ViYThcIn0iLCJleHAiOiIxNTU1NTE3NjcxIn0.K0KQyD2A5V2iPX_7OHJiibLQFOzk4anDD_5bk-m66eyd1Yq0-UYdQtgR1rLPTXUaVJH4iozTDf5HnFfrVQ9ENw" vagrant up node
```

ssh into the node and run puppet

```
vagrant ssh node
sudo /opt/puppetlabs/puppet/bin/puppet agent -t --waitforcert 60
```

The puppet certificate signing request should automatically be signed and puppet run should complete successfully.

## Reference

* <https://github.com/danieldreier/autosign>
* <https://github.com/danieldreier/puppet-autosign>

## Author(s)

sirhopcount   <github@goodfellasonline.nl>

## License & Authors

```text
Copyright:: Copyright (c) 2018 sirhopcount
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
