xquery version "1.0-ml";

import module namespace c = "http://marklogic.com/roxy/test-config" at "/test/test-config.xqy";
import module namespace test="http://marklogic.com/roxy/test-helper" at "/test/test-helper.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare function local:testcaseDisableForest()
{ 
  xdmp:invoke-function(
    function() {
      try{
        let $forestName := $c:disposable-forest-name
        let $config := admin:get-configuration()
            
        let $config := admin:forest-set-enabled($config, admin:forest-get-id($config, $forestName),fn:false())
        
        return admin:save-configuration-without-restart($config),
        test:success()
      } catch ($ex){
        test:fail($ex)
      }
    }
    , <options xmlns="xdmp:eval">
        <transaction-mode>update-auto-commit</transaction-mode>
        <isolation>different-transaction</isolation>
        <prevent-deadlocks>true</prevent-deadlocks>
        <user-id>{xdmp:user($c:TEST-DBA)}</user-id>
      </options>
  )
};

declare function local:testcaseEnableForest()
{ 
  xdmp:invoke-function(
    function() {
      try{
        let $forestName := $c:disposable-forest-name
        let $config := admin:get-configuration()
            
        let $config := admin:forest-set-enabled($config, admin:forest-get-id($config, $forestName),fn:true())
        
        return admin:save-configuration-without-restart($config),
        test:success()
      } catch ($ex){
        test:fail($ex)
      }
    }
    , <options xmlns="xdmp:eval">
        <transaction-mode>update-auto-commit</transaction-mode>
        <isolation>different-transaction</isolation>
        <prevent-deadlocks>true</prevent-deadlocks>
        <user-id>{xdmp:user($c:TEST-DBA)}</user-id>
      </options>
  )
};

local:testcaseDisableForest()
,
local:testcaseEnableForest();





