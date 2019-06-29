*** Settings ***
Library      	  PublisherFactory

*** Keywords ***
Launch publisher
    [Arguments]    ${publisher}  ${token}  ${room}
    Set Publisher Host   ${publisher}  localhost
    Set Publisher Token  ${publisher}  ${token}
    Set Publisher Room   ${publisher}  ${room}
    Start Publisher      ${publisher}
