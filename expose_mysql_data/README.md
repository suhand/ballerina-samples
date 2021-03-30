# Expose MySQL DB data via Ballerina

- ## main.bal

In this sample we have created an open type [record](https://ballerina.io/learn/by-example/records),
```
type personRecord record {
    int id;
    string first_name;
};
```

and fetching data from number of fields more than that is defined in the type record,
```
string GET_PERSON_INFO_QUERY = string `
    SELECT id, first_name, last_name
    FROM person 
`;
```

Our `main()` method is as follows.
```
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
```

Following is the `getPersonInformation(mysql:Client)` method. This is how it is supposed to be.
```
function getPersonInformation(mysql:Client mysqlClient) {
    io:println("------ Start Fetching Person Information -------");
    
    stream<record{}, error> resultStream = mysqlClient->query(GET_PERSON_INFO_QUERY, personRecord);

    error? e = resultStream.forEach(function(record { } result) {
            io:println("ID: ", personRecord["id"]);
            io:println("First Name: ", personRecord["first_name"]);
            io:println("Last Name: ", personRecord["last_name"]);
            io:println("----------------------------------------------");
        });

    if (e is error) {
        io:println("ForEach operation on the stream failed!", e);
    }
    io:println("------ End Fetching Person Information -------");
}
```

How ever due to an issue, this open record type concept is not working with the result stream.
- https://github.com/ballerina-platform/ballerina-standard-library/issues/1174

Therefore as a workaround following is suggested for the `getPersonInformation(mysql:Client)` method, until the issue is fixed.
```
function getPersonInformation(mysql:Client mysqlClient) {
    io:println("------ Start Fetching Person Information -------");

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
```