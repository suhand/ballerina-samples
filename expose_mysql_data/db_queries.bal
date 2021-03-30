import ballerina/sql;

function getPersonInfoQuery(string department) returns sql:ParameterizedQuery{

return  `
        SELECT id, first_name, last_name
        FROM person 
        WHERE department = ${department}
    `;

}