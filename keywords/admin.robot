*** Settings ***
Library      	  AdminFactory

*** Keywords ***
Launch Admin
    [Arguments]    ${admin}  ${token}  ${room}
    Set Admin Host   ${admin}  localhost
    Set Admin Token  ${admin}  ${token}
    Set Admin Room   ${admin}  ${room}
    Start Admin      ${admin}

