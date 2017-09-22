xquery version "1.0-ml";

import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare function local:testcaseAccessDoc()
{ 
  xdmp:invoke-function(
    function() {
        doc("/test/documentForPermissionsTest.xml")
    }
      , <options xmlns="xdmp:eval">
          <transaction-mode>update-auto-commit</transaction-mode>
          <isolation>different-transaction</isolation>
          <prevent-deadlocks>true</prevent-deadlocks>
          <user-id>{xdmp:user($c:test-dba)}</user-id>
        </options>
  )
};

let $doc := local:testcaseAccessDoc()
return test:assert-not-exists($doc)