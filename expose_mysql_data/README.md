# Expose MySQL DB data via Ballerina

## Files

- ### Config.toml
Doc URL: https://ballerina.io/learn/by-example/configurable.html

configurable variables allow configuration of module-level variables **at the program execution**. This enables initializing variables with externally provided values. These values for configurable variables can be provided in a file named `Config.toml`.  
All MySQL DB related key value pairs required for this sample are stored in this file.
```
[expose_mysql_data]
dbHost = "localhost"
dbUser = "root"
dbPassword = "password"
dbName = "bal_sample_db"
dbPort = 3306
```
---
> _Note:_ You can still use `bal encrypt` to encrypt your values in `Config.toml` file. However in Ballerina `2.x.x` path you cannot simply access these values. Please use the following method to access the decrypted value inside the program.
```
config:decryptString(dbPassword)
```

> However it is discouraged to use this encrypt concept since in near future this support will be removed from Ballerina as it is thought to be a responsibility of deployment teams and the sensitive information/secrets/keys are supposed to be stored inside these deployment platforms. e.g. Kubernetes secrets, etc...

---  

- ### db_queries.bal
Since we are using [parameterized queries](https://ballerina.io/learn/by-example/jdbc-parameterized-query.html), we have defined the queries inside functions. In the long run it will help to easily manage all DB queries from a single location.
```
import ballerina/sql;

function getPersonInfoQuery(string department) returns sql:ParameterizedQuery{
return  `
        SELECT id, first_name, last_name
        FROM person 
        WHERE department = ${department}
    `;
}
```

- ### db_functions.bal
MySQL client initialization and functions which are querying data from MySQL DB are stored in this file.

- ### db_type_records.bal
Relevant record types that are used in `db_functions.bal` file are stored in this file.  
In this sample we have created an open type [record](https://ballerina.io/learn/by-example/records).
```
type personRecord record {
    int id;
    string first_name;
};
```

> Note: How ever due to an issue, this open record type concept is not working with the result stream.   
> Note that the `last_name` field is defined in the query but not defined in the open record type above.  
> - https://github.com/ballerina-platform/ballerina-standard-library/issues/1174

> Therefore from the following code (supposed to be),  
```
stream<record{}, error> resultStream = mysqlClient->query(GET_PERSON_INFO_QUERY, personRecord);
personRecord["last_name"]
```

> changed the code to the following as a workaround,  
```
// Workaround - part 1 of 2
stream<record{}, error> resultStream = mysqlClient->query(GET_PERSON_INFO_QUERY);

error? e = resultStream.forEach(function(record { } result) {
        // Workaround - part 2 of 2
        personRecord cloneWithType = checkpanic result.cloneWithType(personRecord);
        personRecordClonedWithType["last_name"]
```

- ### service.bal
All service endpoints represented by the resources in this sample are stored here.
```
import ballerina/http;

[# Description  
service / on new http:Listener(9090) {

    # Description
    # + return - Return Value Description  
    resource function get personjson/info/[string series]() returns json | error {
        return check getPersonInfo(series);
    }
}
```

- ### main.bal (commented out)

## References

- https://ballerina.io/learn/by-example/jdbc-parameterized-query.html
- https://docs.central.ballerina.io/ballerinax/mysql/0.7.0-alpha5
- https://docs.central.ballerina.io/ballerina/sql/0.6.0-alpha5
- https://docs.central.ballerina.io/ballerina/http/1.1.0-alpha5/http/records/Ok
- https://github.com/ballerina-platform/ballerina-distribution/tree/master/examples