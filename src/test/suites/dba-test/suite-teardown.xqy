xquery version "1.0-ml";

if (fn:exists(doc("/test/documentForPermissionsTest.xml")))
  then xdmp:document-delete("/test/documentForPermissionsTest.xml")
  else ()
;

import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

(: our dbname and forestname :)
let $dbName := $c:disposable-db-name
  
let $config := admin:get-configuration()
(: Delete the database from the configuration :)
let $config := if(admin:database-exists($config,  $dbName))
  then admin:database-delete($config, admin:database-get-id($config, $dbName))
  else $config

return admin:save-configuration($config);

(: delete the forest in a seperate transaction :)
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";

let $forestName := $c:disposable-forest-name

(: Get the configuration with the deleted database :)
let $config := admin:get-configuration()
(: Delete the forest from the configuration :)
let $config := if(admin:forest-exists($config,  $forestName))
  then admin:forest-delete($config, admin:forest-get-id($config, $forestName), fn:true())
  else $config
  
(: Save the configuration :)
return admin:save-configuration($config)