*** Settings ***
Documentation     A minimal pub sub flow
Library      	  Publisher  WITH NAME  Pub
Resource          tokens.robot
Resource          subscriber.robot
Test Teardown     Stop subscriber and publisher

*** Variables ***
${room}     themeratures
${tag}      hallway
${msg}      1234

*** Keywords ***
Stop subscriber and publisher
    Pub.Stop

Launch publisher
    [Arguments]    ${token}  ${room}
    Pub.Set Host   localhost
    Pub.Set Token  ${token}
    Pub.Set Room   ${room}
    Pub.Start

Publish message
    [Arguments]  ${msg}
    Pub.Publish  ${msg}

Check received message
    [Arguments]  ${msg}
    Sub.Check received  ${msg}

*** Test Cases ***
Valid Single Subscription
    ${subscriber}=     Get Subscriber
    Launch publisher   ${GOD_TOKEN}  ${room}
    Launch subscriber  ${subscriber}  ${GOD_TOKEN}  ${room}  ${tag}
    Sleep              1  for proper launches
    Publish message    ${msg}
    ${received}=       Get subscription message  ${subscriber}
    Stop Subscriber    ${subscriber}
    Should Be Equal As Strings  ${received}  ${msg}

Valid Tripple Subscription
    ${subscriber1}=     Get Subscriber
    ${subscriber2}=     Get Subscriber
    ${subscriber3}=     Get Subscriber

    Launch publisher   ${GOD_TOKEN}  ${room}
    Launch subscriber  ${subscriber1}  ${GOD_TOKEN}  ${room}  ${tag}
    Launch subscriber  ${subscriber2}  ${GOD_TOKEN}  ${room}  ${tag}
    Launch subscriber  ${subscriber3}  ${GOD_TOKEN}  ${room}  ${tag}

    Sleep              1  for proper launches
    Publish message    ${msg}

    ${received1}=       Get subscription message  ${subscriber1}
    ${received2}=       Get subscription message  ${subscriber2}
    ${received3}=       Get subscription message  ${subscriber3}

    Stop Subscriber    ${subscriber1}
    Stop Subscriber    ${subscriber2}
    Stop Subscriber    ${subscriber3}

    Should Be Equal As Strings  ${received1}  ${msg}
    Should Be Equal As Strings  ${received2}  ${msg}
    Should Be Equal As Strings  ${received3}  ${msg}
