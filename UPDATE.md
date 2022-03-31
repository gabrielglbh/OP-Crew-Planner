# Updating OP Crew Planner

The following document is for updating the OP Crew Planner app for new batches of units, aliases or ships. The upload to the App Store and Google Play is granted to be known.

This project is built with two different, yet closely related, databases: Firebase and SQLite on device. The Firebase onw is for maintaining all data available right away and for keeping the heavy data away from the main app. The SQLite is for storing the downloaded data from Firebase in order for users to see it offline. Let's see every part of them.

## Firebase

### Cloud Firestore

Divided in three ways: collections that serve as automatic data to check for updates, collections available always and that are for version checking and details that are always available and untouchable collections.

Be aware that there are Firebase Rules implemented.

#### Automatic Update Collections

- ALIASES: holds all the aliases for all available units. They are differentiated by a unique `id`. `unitId` is mandatory to be consisted of exactly 4 characters.

        Alias(int id, String alias, String unitId)

- RECENT: holds a list of the last added units. This list contains the `unitId` for the new units and this is directly reflected on the app in the "Recent List".

- SHIPS: holds all the ships available in the game. They are differentiated by a unique `pk`. `id` corresponds to the ship ID, also mandatory to be consisted of exactly 4 characters.

        Ship(int pk, String id, String name, String url)

- UNITS: holds all the units available in the game. They are differentiated by a unique `pk`. `id` corresponds to the unit ID, also mandatory to be consisted of exactly 4 characters.

        Unit(int pk, String id, String name, String type, String url) 

__It is VERY IMPORTANT that every time new units, aliases or ship are inserted in their respective collection, the `id` or `pk` must be incremented by 1 for each added document__. This will be used for faster querying and for saving reads on Firebase when checking for updates. 

The update is done __locally__ by the developer in [update_queries.dart](https://github.com/gabrielglbh/OP-Crew-Planner/blob/main/lib/core/firebase/queries/update_queries.dart) on the function `uploadNewData`. Read the comments to get more information on it.

In order to check for in-app updates, a query is sent to UNITS, ALIASES and SHIPS, retrieving the last added document (ordered by `id` or `pk`). This will get us the total number of units, aliases or ships currently in Firebase. This will be contrasted with the total number of units, aliases or ships in the SQLite database. __If Firebase has more documents than the SQLite DB in any collection, then an update is needed, meaning there are some new units, aliases or ships.__

The UNITS and SHIPS `url` must be constant upon insertion. You cannot change it right away if the image is not valid (will lead to inconsistency). If you are not sure if the image is valid, leave the `url` field empty. When the url of the thumbnail is correct and valid, you can put it in, app will look for empty `url` fields and track them. If, by any chance, you need to change the `url`, you must updated it in Firebase __and__ in the SQLite DB.

These 4 collections are used for updating new units, aliases or ships. For every new unit, alias or ship, __you will have to insert them in Firebase by hand and the app update system will handle the insertion of these new documents in the SQLite DB__. If the update of the documents are not performed maintaining the `pk` or `id` constantly incrementing, the current system of update checks will not work.

#### Rearranging Units in both SQLite and Firebase

If there is need to rearrange units in database and firebase follow this instructions:

- 1. Copy the schema from the _version36to37_ function on migrations.dart and replace the data of the units as needed: old ids, new ids and names. (This rearrange should be done only once per device and this is why it is being done in migrations)
- 2. Update ids from ALIASES and UNITS to refer to the new ones for new installs
- 3. Remove from DETAILS the old ids references and insert the new data with the new ids. (The update script from firebaseUtils will not trigger as it checks for majority not minority)

#### Version Checking and Static Data Collections

- DETAILS: holds all the units' details: `full art`, `special`, `special name`, `captain action`, `supertype`, `PvP actions`, `VS actions`, `support abilities`, `sailor abilities` and `potential abilities`. Each document is identified by the `unitId`. Again, it is mandatory to be consisted of exactly 4 characters. It has a somehow complex structure but can be checked in the [unitInfo.dart](https://github.com/gabrielglbh/OP-Crew-Planner/blob/main/lib/core/database/models/unitInfo.dart) file. __These documents can be changed whenever as the data is retrieved as it is requested in the app.__

- VERSION: holds the actual version of the app and the version notes for when a new release is uploaded. __The `version` must be updated whenever a new release is launched in both App Store and Google Play to the same build name.__ This way, the users that are in previous versions, will receive a notification in-app telling them to update it. Notes can be changed whenever but logically should be changed when a new release is launched.

#### Untouchable Collections

- USERS: holds the backup data for all the users that have made one at any given time. Identified by the `Auth Token` that Firebase Authentication grants. When updating the SQLite DB, __it is very important to merge these changes in-device with the backups__, as some of them may not have the changes. In the code you will say specific definitions of new fields that are added to the backup JSON in case they are not there.

### Firebase Storage

Contains various unit thumbnails that were not available. And also contains a `ships` folder for storing the ships thumnails.

Be aware that there are Firebase Rules implemented.

### Firebase Authentication

For handling the users. Users are free to use the app without signing up, but if they do, they will be granted access to perform the backup operations to maintain their data accross any devices.

Be aware that the email validation is active.

## SQLite DB

The whole query system of the app goes through here. All the database handling is in the [database.dart](https://github.com/gabrielglbh/OP-Crew-Planner/blob/main/lib/core/database/database.dart) file. You need to maintain consistency between the Firebase fields and SQLite fields as they are mirrored.

For upgrading the current database with new tables, fields, field updates or insertions (anything really), you will need to increase the `version` number in the `openDatabase()` method. When this number is changed, `_onUpgrade()` will be triggered. This method will check the current version of the database with the new one and apply the necessary changes. All specific version changes are located in the [migrations.dart](https://github.com/gabrielglbh/OP-Crew-Planner/blob/main/lib/core/database/migrations.dart) file.
