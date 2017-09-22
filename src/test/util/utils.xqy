xquery version "1.0-ml";

module namespace util = "http://marklogic.com/roxy/test-util";

import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
  
declare function util:get-user($name)
{
  xdmp:invoke-function(
  function() {
    sec:uid-for-name($name)
    }
      , <options xmlns="xdmp:eval">
          <transaction-mode>update-auto-commit</transaction-mode>
          <isolation>different-transaction</isolation>
          <prevent-deadlocks>true</prevent-deadlocks>
          <database>{xdmp:database("Security")}</database>
        </options>
  )
};


