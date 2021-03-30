import ballerina/io;
import ballerina/log;
import ballerinax/mysql;

configurable string dbHost = ?;
configurable string dbUser = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbPort = ?;

mysql:Client mysqlClient = check new (host = dbHost,
                                        user = dbUser,
                                        password = dbPassword,
                                        database = dbName,
                                        port = dbPort);

# Description
#
# + department - Parameter Description
# + return - Return Value Description  
public function getPersonInfo(string department) returns json[]|error {

    json[] resultJSON = [];
    // Workaround - part 1 of 2
    stream<record{}, error> resultStream = mysqlClient->query(getPersonInfoQuery(department));

    error? e = resultStream.forEach(function(record { } result) {
            // Workaround - part 2 of 2
            personRecord | error personRecordClonedWithType = result.cloneWithType(personRecord);
            if personRecordClonedWithType is personRecord {
                resultJSON.push(result.toJson());
                // io:println("ID: ", personRecordClonedWithType["id"]);
                // io:println("First Name: ", personRecordClonedWithType["first_name"]);
                // io:println("Last Name: ", personRecordClonedWithType["last_name"]);
                // io:println("----------------------------------------------");
            } else {
                log:printError("Type Cast Error!", 'error = personRecordClonedWithType);
            }
        });

    if (e is error) {
        io:println("ForEach operation on the stream failed!", e);
    }
    return resultJSON;
}