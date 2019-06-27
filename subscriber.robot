*** Settings ***
Library      	  SubscriberFactory

*** Keywords ***
Launch subscriber
    [Arguments]    ${subscriber}  ${token}  ${room}  ${tag}
    Set Subscriber Host   ${subscriber}  localhost
    Set Subscriber Token  ${subscriber}  ${token}
    Set Subscriber Room   ${subscriber}  ${room}
    Set Subscriber Tag    ${subscriber}  ${tag}
    Start Subscriber      ${subscriber}
