[![Build Status](https://travis-ci.org/DukkhaLess/DukkhaLessClient.svg?branch=master)](https://travis-ci.org/DukkhaLess/DukkhaLessClient)
[![Known Vulnerabilities](https://snyk.io/test/github/MySelfCare/MySelfcareClient/badge.svg?targetFile=package.json)](https://snyk.io/test/github/MySelfCare/MySelfcareClient?targetFile=package.json)

# Dukkhaless Self-Care Client

A safe place to write your thoughts, and track the progress of mental health recovery.

## Planned Features

1. Secure Diaries
2. Configurable Calendars with support for mood/diet logging.
3. Secure Tagging of items for searching/filtering. The tags will be stored in a hashed format so they can be queried and searched without recording their text.
4. Secure sharing of diaries/calendars with explicitly whitelisted parties.
5. Support for creating and visualising timelines of events.
6. DBT Template for analysing pros/cons of a possible decision
7. CBT ABCD template with saving
X. More to come, this is just the initial steps. User feedback and information will play a major role in where we go in the future.


## Privacy System

#### The Dukkhaless Self-Care platform identifies three key security concerns.

1. The user must be able to encrypt data for themselves and only themselves to read.
  - `Secretbox` algorithm is used to secure user data for their own viewing
  - `Secretbox` makes use of your `symmetric key`.

2. The user must be able to send data to a specific individual (ie. their physician such that only that individual can read it.)
  - `Box` algorithm is used to send data between users.
  - `Box` makes use of your `private key` and the recipient's `public key`

3. The user data should be sent only be possible to be changed by its owner.
  - This goal is achieved via typical sign-in credentials, ie username and password.

#### Technical notes on addressing these concerns

- The program uses the `tweetnacl-js` library to handle client-side encryption
- The program introduces a concept of a `keyring`, a block of text which the user must keep private and secure
  - The `keyring` is what is used to send data privately to specific individuals (like your physician) AND to encrypt your data so that ONLY you can read it.
  - Even the Dukkhaless Self-Care servers cannot read the contents of your data except for the minimum metadata to make sure it only gets sent to you. (Ie the username that goes with a diary entry, and the info needed to sort them by most recent.)
- The `keyring` has three keys within it.
  - A public key which the server keeps a copy of so that people can encrypt their data for only you to read it. A `public key` is safe to share without reducing privacy.
  - The `private key` that is paired to the public key. This is used to read messages that are sent to you.
  - The `symmetric key` that is used to encrypt your data for you to read. This key should be treated as securely as the private key as it represents your personal access to your data. 


### Problems That Still Require Solving

- User password recovery without invading user privacy (ie. demanding an email address)
- Risk of user data loss when they key is lost.

## Software Licensing
This program is licensed under the GNU General Public License Version 3. For details consult the LICENSE file.

Some source files are special cases and licensed under more permissive licenses such as Apache Version 2. This is done where
the code is copied whole or in part from another individual who has licensed the software as such. Licenses are preserved so that authorship and rights
do not be confused, and to protect and thank those authors who made this work possible. Such special files will have a license notice at the top of each file clearly demarking them as licensed differently from GPLv3.

## Setting Up Your Development Environment

- Download latest stable nodejs from [here](https://nodejs.org/en/)
- `npm install --global yarn purescript pulp bower`
- From the project directory: `yarn install && bower install`
- Run the program in dev mode: `yarn dev`
- Addition scripts for it can be found in `package.json`'s scripts object.
- To create a new feature branch to do development, use `git checkout -b MYBRANCHNAME`
- To contribute your feature back, please simply create a pull request with a description of its intent.


## Getting oriented.
- The project uses [purescript-halogen](https://github.com/slamdata/purescript-halogen) For rendering
- It's important to note that the documentation for halogen on [pursuit](https://pursuit.purescript.org/packages/purescript-halogen/) are not up to date.

## Contributing

- Submit a pull request with the feature you wish to add and a short description of intent for the PR.
- I'm not super particular about it, I'll read the code anyway to see what it does, after all.
- When adding issues, please try to describe as much as possible the state that application needs to be in to replicate the issue, if appropraite.


## Working with the bulma design stuff

- Once set up, run `yarn dev` to load the auto-reloading browser.
- Edit `styles/styles.scss` to define appropriate style sheets to be used in the application, and configure bulma variables
- View the work on `localhost:3000/designPage.html`
