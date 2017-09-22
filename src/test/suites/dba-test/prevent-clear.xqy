import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare function local:testcaseClearDB()
{
  xdmp:invoke-function(
    function() {
        let $forestName := $c:disposable-forest-name
        let $forestIDs := xdmp:forest($forestName)

        return xdmp:forest-clear($forestIDs)
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

test:assert-throws-error(xdmp:function(xs:QName("local:testcaseClearDB")), "SEC-PRIV")

(: test is very slow when it can successfully clear and fails :)