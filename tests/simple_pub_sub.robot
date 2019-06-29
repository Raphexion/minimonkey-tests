*** Settings ***
Documentation     A minimal pub sub flow
Resource          ../variables/tokens.robot
Resource          ../keywords/subscriber.robot
Resource          ../keywords/publisher.robot

*** Variables ***
${room}     themeratures
${tag}      hallway
${msg}      1234

*** Test Cases ***
Valid Single Subscription
    ${publisher}=       Get Publisher
    Launch publisher    ${publisher}  ${GOD_TOKEN}  ${room}

    ${subscriber}=      Get Subscriber
    Launch subscriber   ${subscriber}  ${GOD_TOKEN}  ${room}  ${tag}

    Sleep               1  for proper launches

    Publish message     ${publisher}  ${msg}
    ${received}=        Get subscription message  ${subscriber}

    Stop Publisher      ${publisher}
    Stop Subscriber     ${subscriber}

    Should Be Equal As Strings  ${received}  ${msg}

Valid Tripple Subscription
    ${publisher}=       Get Publisher
    Launch publisher    ${publisher}  ${GOD_TOKEN}  ${room}

    ${subscriber1}=     Get Subscriber
    ${subscriber2}=     Get Subscriber
    ${subscriber3}=     Get Subscriber

    Launch subscriber   ${subscriber1}  ${GOD_TOKEN}  ${room}  ${tag}
    Launch subscriber   ${subscriber2}  ${GOD_TOKEN}  ${room}  ${tag}
    Launch subscriber   ${subscriber3}  ${GOD_TOKEN}  ${room}  ${tag}
    Sleep               1  for proper launches

    Publish message     ${publisher}  ${msg}

    ${received1}=       Get subscription message  ${subscriber1}
    ${received2}=       Get subscription message  ${subscriber2}
    ${received3}=       Get subscription message  ${subscriber3}

    Stop Publisher      ${publisher}
    Stop Subscriber     ${subscriber1}
    Stop Subscriber    	${subscriber2}
    Stop Subscriber    	${subscriber3}

    Should Be Equal As Strings  ${received1}  ${msg}
    Should Be Equal As Strings  ${received2}  ${msg}
    Should Be Equal As Strings  ${received3}  ${msg}

Valid Double Publish
    ${publisher1}=       Get Publisher
    ${publisher2}=       Get Publisher
    Launch publisher	 ${publisher1}  ${GOD_TOKEN}  ${room}
    Launch publisher	 ${publisher2}  ${GOD_TOKEN}  ${room}

    ${subscriber1}=     Get Subscriber
    ${subscriber2}=     Get Subscriber

    Launch subscriber   ${subscriber1}  ${GOD_TOKEN}  ${room}  ${tag}
    Launch subscriber   ${subscriber2}  ${GOD_TOKEN}  ${room}  ${tag}

    Sleep               1  for proper launches

    Publish message     ${publisher1}  ${msg}
    Publish message     ${publisher2}  ${msg}

    ${received1}=       Get subscription message  ${subscriber1}
    ${received2}=       Get subscription message  ${subscriber1}
    ${received3}=       Get subscription message  ${subscriber2}
    ${received4}=       Get subscription message  ${subscriber2}

    Stop Publisher      ${publisher1}
    Stop Publisher      ${publisher2}
    Stop Subscriber     ${subscriber1}
    Stop Subscriber    	${subscriber2}

    Should Be Equal As Strings  ${received1}  ${msg}
    Should Be Equal As Strings  ${received2}  ${msg}
    Should Be Equal As Strings  ${received3}  ${msg}
    Should Be Equal As Strings  ${received4}  ${msg}
