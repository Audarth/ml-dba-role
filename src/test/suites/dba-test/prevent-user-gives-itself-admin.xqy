xquery version "1.0-ml";

import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
import module namespace util = "http://marklogic.com/roxy/test-util" at  "/test/util/utils.xqy";

declare function local:giveMeAdmin()
{ 
  xdmp:invoke-function(
    function() {
          sec:user-set-roles($c:test-dba, ("admin"))
    }
      , <options xmlns="xdmp:eval">
          <transaction-mode>update-auto-commit</transaction-mode>
          <isolation>different-transaction</isolation>
          <prevent-deadlocks>true</prevent-deadlocks>
          <user-id>{util:get-user($c:test-dba)}</user-id>
        </options>
  )
};

test:assert-throws-error(xdmp:function(xs:QName("local:giveMeAdmin")), "SEC-PRIV")