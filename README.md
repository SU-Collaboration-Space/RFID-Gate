# RFID-Gate
RFID Gate

The SQL file provides a basic structure for the RFIDs to be kept.

The PHP file is to be placed on a web server where it can be reached from the network.

The Python script will query the received data from the RFID antenna reader against a database via the PHP file.

Three scenarios are covered where an RFID tag is allowed to leave, where it is not and a capture via camera is made. In both scenarios registered RFID are logged to the database.

The last scenario cover unknown RFID tags. In such a case no action is taken.
