xquery version "1.0-ml";

import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

(: run after tests :)

let $config := admin:get-configuration()
  
let $newConfig := admin:database-delete($config, admin:database-get-id($config, "testDatabaseForDBA"))

return 
  try{
    admin:save-configuration-without-restart($newConfig)
  } catch($exception) {
  }
,
xdmp:document-delete("/test/documentForPermissionsTest.xml")