import std.net.curl, std.json;
import std.algorithm.searching : canFind;
import std.json;
import std.stdio, std.conv : to; //debugging
class Database {
    ///Used for visual purposes and organization.
    public string name;
    ///The client used for making POST and GET requests to the API.
    public HTTP client;
    ///The anon or service_role key
    protected string key;
    ///The API URL endpoint that the client uses to access the database.
    protected string endpoint;
    protected string restEndpoint;
    ///The constructor for the Database class, but it is recommended to use the init() function. Remember to use the service_role key for the keyy variable if you have RLS enabled with no policies.
    this(string endpointt, string keyy, string namee) {
        key = keyy;
        auto temp_endpoint = endpointt;
        if (!endpointt.canFind(".supabase.co")) {
            temp_endpoint = temp_endpoint ~ ".supabase.co";
        }
        if (!endpointt.canFind("https://")) {
            temp_endpoint = "https://" ~ temp_endpoint;
        }
        endpoint = endpointt;
        restEndpoint = endpoint ~ "/rest/v1/";
        name = namee;
        client = HTTP(); //remove endpointt, find a way to manipulate url afterwards
    }
    protected void setGetHeaders() {
        client.clearRequestHeaders();
        client.addRequestHeader("apikey", key);
        client.addRequestHeader("Authorization",  "Bearer " ~ key);
    }
    ///Returns all rows and columns
    @property auto getRows(string table) {
        //client.method = HTTP.Method.get;
        setGetHeaders();
        auto x = get(restEndpoint ~ table ~ "?select=*", client);
        auto json = parseJSON(x).array();
        return json;
        //client.perform(endpoint ~ "/rest/v1/" ~ name ~ "?select=*", client);
    }
    ///Gets a specific column and all of its values in a map
    @property auto getColumn(string table, string column) {
        setGetHeaders();
        auto x = get(restEndpoint ~ table ~ "?select=" ~ column, client);
        auto json = parseJSON(x).array();
        return json;
    }
    ///Gets a specific row and all of its values in a map
    @property auto getRow(string table, int row) {
        setGetHeaders();
        auto json = get(restEndpoint ~ table ~ "?select=*", client);
        auto x = parseJSON(json)[row - 1].object();
        return x;
    }
}
///The same as Database, but the member functions return the naked JSONValue instead of a modified
/*class LLDatabase : Database {
    this(string endpointt, string keyy, string namee) {
        key = keyy;
        auto temp_endpoint = endpointt;
        if (!endpointt.canFind(".supabase.co")) {
            temp_endpoint = temp_endpoint ~ ".supabase.co";
        }
        if (!endpointt.canFind("https://")) {
            temp_endpoint = "https://" ~ temp_endpoint;
        }
        endpoint = endpointt;
        restEndpoint = endpoint ~ "/rest/v1/";
        name = namee;
        client = HTTP(); //remove endpointt, find a way to manipulate url afterwards
    }
    @property auto getRows(string table) {
        //client.method = HTTP.Method.get;
        setGetHeaders();
        auto x = get(restEndpoint ~ table ~ "?select=*", client);
        auto json = parseJSON(x);
        string[string] ret;
        return ret;
        //client.perform(endpoint ~ "/rest/v1/" ~ name ~ "?select=*", client);
    }
    ///Gets a specific column and all of its values in a map
    @property auto getColumn(string table, string column) {
        setGetHeaders();
        auto x = get(restEndpoint ~ table ~ "?select=" ~ column, client);
        auto json = parseJSON(x).array();
        string[string] ret;
        return json[1];
    }
    ///Gets a specific row and all of its values in a map
    @property auto getRow(string table, int row) {
        setGetHeaders();
        auto json = get(restEndpoint ~ table ~ "?select=*", client);
        auto x = parseJSON(json)[row];
        string[string] ret;
        return ret;
    }
}*/
///Initializes and returns a Database class. You may omit the "https://" or ".supabase.co" section of the endpoint for readability.
Database init(string key, string endpoint, string name = "db") {
    auto xyz = new Database(endpoint, key, name);
    return xyz;
}

void main() {
    auto x = init("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTY0MjA0MTQ0MSwiZXhwIjoxOTU3NjE3NDQxfQ.THriT1EqLkizCHPVaHb1Y1I6i2J-MuDQybYujVm6T2I", "https://ogkklizgscwqlkrfndpv.supabase.co");
    writeln(to!string(x.getRow("hello_world", 1))); //WORKS!!!!! prints a map with the key and values of all of the columns of the specific rows
}