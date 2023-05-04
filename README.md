# Glb

Create and delete Google Load Balancer components.

Pros:

* The tool wraps gcloud commands. This helps those who are familiar with gcloud commands and are referencing google cloud docs.

Cons/Limitations:

* The tool assumes that the source of truth is the configuration. It does not detect and will update and overwrite any manual changes that does not match the configuration.
* This is notably different from terraform which will perform a diff calculation, which can provide a diff in the plan.
* The `gcloud compute [RESOURCE] update` will not run if there are no attributes in the command, else `gcloud` reports an error.

## Usage

Commands:

    glb plan APP
    glb up APP
    glb down APP
    glb show APP

APP is your app name. IE: demo

## Docs

* [External Load Balancer (Global)](docs/external.md)
* [Internal Load Balancer (Region)](docs/internal.md)

## Resources

The tool creates these resources:

* firewall rule
* health check
* backend service
* url map
* target http proxy
* forwarding rule

If SSL is enabled it'll also create a

* target https proxy (associated with the same url map)
* forwarding rule (associated with the target https proxy)

The same url map is used because that's what shows up as a Load Balancer in the Google console.

## Installation

    gem install glb
