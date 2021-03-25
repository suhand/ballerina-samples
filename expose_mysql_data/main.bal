import ballerina/io;
import ballerina/sql;
import ballerinax/mysql;

configurable string dbHost = ?;
configurable string dbUser = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbPort = ?;

function getPersonInformation(mysql:Client mysqlClient) {
    io:println("------ Start Fetching Person Information -------");
    
    // Issue: Open record type does not append additional fields in the resultStream
    // https://github.com/ballerina-platform/ballerina-standard-library/issues/1174

    // stream<record{}, error> resultStream = mysqlClient->query(GET_PERSON_INFO_QUERY, personRecord);

    // Workaround - part 1 of 2
    stream<record{}, error> resultStream = mysqlClient->query(GET_PERSON_INFO_QUERY);

    error? e = resultStream.forEach(function(record { } result) {
            // Workaround - part 2 of 2
            personRecord cloneWithType = checkpanic result.cloneWithType(personRecord);
            io:println("ID: ", cloneWithType["id"]);
            io:println("First Name: ", cloneWithType["first_name"]);
            io:println("Last Name: ", cloneWithType["last_name"]);
            io:println("----------------------------------------------");
        });

    if (e is error) {
        io:println("ForEach operation on the stream failed!", e);
    }
    io:println("------ End Fetching Person Information -------");
}

public function main() {

        mysql:Client|sql:Error mysqlClient = new (host = dbHost, 
                                                  user = dbUser, 
                                                  password = dbPassword,
                                                  database = dbName, 
                                                  port = dbPort);

        if (mysqlClient is mysql:Client) {
            getPersonInformation(mysqlClient);
            io:println("Queried the database successfully!");

            sql:Error? e = mysqlClient.close();

        } else {
            io:println("MySQL Client initialization for " +
                "querying data failed!", mysqlClient);
        }
}