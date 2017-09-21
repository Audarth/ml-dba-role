import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare function local:testcaseDeleteDB()
{
  xdmp:invoke-function(
    function() {
        let $config := admin:get-configuration()
        return
        admin:database-delete($config, admin:database-get-id($config, "testDatabaseForDBA"))
    }
      , <options xmlns="xdmp:eval">
          <transaction-mode>update-auto-commit</transaction-mode>
          <isolation>different-transaction</isolation>
          <prevent-deadlocks>true</prevent-deadlocks>
          <database>{xdmp:database($c:database)}</database>
          <user-id>{xdmp:user($c:TEST-DBA)}</user-id>
        </options>
  )
};

test:assert-throws-error(xdmp:function(xs:QName("local:testcaseDeleteDB")), "SEC-PRIV")