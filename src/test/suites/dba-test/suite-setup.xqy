xquery version "1.0-ml";

(: run before tests :)

xdmp:document-insert("/test/documentForPermissionsTest.xml", <root/>);

import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $dbName := $c:disposable-db-name
let $forestName := $c:disposable-forest-name

let $config := admin:get-configuration()

let $config := if(admin:forest-exists($config,  $forestName))
  then $config
  else admin:forest-create($config, $forestName, xdmp:host(), ())
  
return 
  try{
    admin:save-configuration($config)
  }catch($exception) {
  }
;

import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()

let $ExistingDatabases :=
    for $id in admin:get-database-ids($config)
       return admin:database-get-name($config, $id)

(: our dbname and forestname :)
let $dbName := $c:disposable-db-name
let $forestName := $c:disposable-forest-name
(: Add new database to the configuration :)


let $config := 
if ($dbName = $ExistingDatabases) 
    then $config
    else  admin:database-create($config, $dbName, xdmp:database("Security"), xdmp:database("Schemas"))

(: Obtain the database ID of 'testDatabaseForDBA' :)
let $database := admin:database-get-id($config, $dbName)

(: Get all of the forests attached to 'testDatabaseForDBA' :)
let $AttachedForests :=
    admin:forest-get-name($config, (admin:database-get-attached-forests($config, $database) ))
    
(: Check to see if "testDatabaseForDBA-forest" is already attached. If not, attach the forest to the database :)
let $config :=
    if ($forestName = $AttachedForests) 
    then $config
    else
       admin:database-attach-forest(
          $config,
          $database,
          xdmp:forest($forestName))
let $config := admin:database-attach-forest($config, $database, xdmp:forest($forestName))

return 
  try{
    admin:save-configuration($config)
  } catch($exception) {
  }

;

(: create temp dba user :)
import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

xdmp:invoke-function(
  function() {
    sec:create-user($c:test-dba,"temorary user that will be deleted when test is finished", "tempPasswordThatShouldntExistVeryLong", $c:dba-rolename, (), ())
    }
      , <options xmlns="xdmp:eval">
          <transaction-mode>update-auto-commit</transaction-mode>
          <isolation>different-transaction</isolation>
          <prevent-deadlocks>true</prevent-deadlocks>
          <database>{xdmp:database("Security")}</database>
        </options>
  )

