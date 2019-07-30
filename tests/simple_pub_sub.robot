*** Settings ***
Documentation     A minimal pub sub flow
Library      	  Instructions
Resource          ../variables/tokens.robot
Resource          ../keywords/subscriber.robot
Resource          ../keywords/publisher.robot

*** Variables ***
${room}     themeratures
${tag}      hallway
${msg1}     1234
${msg2}     5678

*** Test Cases ***
Valid Single Subscription
    ${promise}=         Subscribe Promise  ${room}  ${tag}  ${GOD_TOKEN}
    Publish             ${msg1}  ${room}  ${GOD_TOKEN}
    ${received}=        Subscribe Get  ${promise}

    Should Be Equal As Strings  ${received}  ${msg1}

Valid Tripple Subscription
    ${promise1}=         Subscribe Promise  ${room}  ${tag}  ${GOD_TOKEN}
    ${promise2}=         Subscribe Promise  ${room}  ${tag}  ${GOD_TOKEN}
    ${promise3}=         Subscribe Promise  ${room}  ${tag}  ${GOD_TOKEN}

    Publish             ${msg1}  ${room}  ${GOD_TOKEN}

    ${received1}=        Subscribe Get  ${promise1}
    ${received2}=        Subscribe Get  ${promise2}
    ${received3}=        Subscribe Get  ${promise3}

    Should Be Equal As Strings  ${received1}  ${msg1}
    Should Be Equal As Strings  ${received2}  ${msg1}
    Should Be Equal As Strings  ${received3}  ${msg1}

Valid Double Publish
    ${promise1}=         Subscribe Promise  ${room}  ${tag}  ${GOD_TOKEN}
    ${promise2}=         Subscribe Promise  ${room}  ${tag}  ${GOD_TOKEN}

    Publish             ${msg1}  ${room}  ${GOD_TOKEN}
    Publish             ${msg2}  ${room}  ${GOD_TOKEN}

    ${received1}=        Subscribe Get  ${promise1}  False
    ${received2}=        Subscribe Get  ${promise1}
    ${received3}=        Subscribe Get  ${promise2}  False
    ${received4}=        Subscribe Get  ${promise2}

    Should Be Equal As Strings  ${received1}  ${msg1}
    Should Be Equal As Strings  ${received2}  ${msg2}
    Should Be Equal As Strings  ${received3}  ${msg1}
    Should Be Equal As Strings  ${received4}  ${msg2}
