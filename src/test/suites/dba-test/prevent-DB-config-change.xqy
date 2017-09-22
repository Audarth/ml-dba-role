xquery version "1.0-ml";

import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare function local:testcaseChangeDBSettings()
{ 
  xdmp:invoke-function(
    function() {
          let $config := admin:get-configuration()
          
          let $newConfig := admin:database-set-fast-element-phrase-searches($config, xdmp:database("testDatabaseForDBA"), fn:true())

          return admin:save-configuration-without-restart($newConfig)
    }
      , <options xmlns="xdmp:eval">
          <transaction-mode>update-auto-commit</transaction-mode>
          <isolation>different-transaction</isolation>
          <prevent-deadlocks>true</prevent-deadlocks>
          <user-id>{xdmp:user($c:test-dba)}</user-id>
        </options>
  )
};

test:assert-throws-error(xdmp:function(xs:QName("local:testcaseChangeDBSettings")), "SEC-PRIV")

