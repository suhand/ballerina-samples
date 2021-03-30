import ballerina/http;

# Description  
service / on new http:Listener(9090) {

    # Description
    # + return - Return Value Description  
    resource function get person/info/[string series]() returns http:Ok | http:BadRequest | error {
        json[] data = check getPersonInfo(series);
        http:Ok | error res = {body: data};
        return res;
    }

    # Description
    # + return - Return Value Description  
    resource function get personjson/info/[string series]() returns json | error {
        return check getPersonInfo(series);
    }
}