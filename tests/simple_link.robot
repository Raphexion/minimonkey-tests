*** Settings ***
Documentation     A minimal pub sub flow
Resource          ../variables/tokens.robot
Resource          ../keywords/admin.robot
Resource          ../keywords/subscriber.robot
Resource          ../keywords/publisher.robot

*** Variables ***
${original_room1}     temp1
${original_room2}     temp2
${linked_room}        factory
${tag}                hallway
${msg1}               temp1abc
${msg2}               temp2abc

*** Test Cases ***
Valid Single Link
    ${admin}=           Get admin
    Launch Admin        ${admin}  ${GOD_TOKEN}  ${original_room1}
    Link Rooms           ${admin}  ${original_room1}  ${linked_room}

    ${publisher}=       Get Publisher
    Launch publisher    ${publisher}  ${GOD_TOKEN}  ${original_room1}

    ${subscriber}=      Get Subscriber
    Launch subscriber   ${subscriber}  ${GOD_TOKEN}  ${linked_room}  ${tag}

    Sleep               1  for proper launches

    Publish message     ${publisher}  ${msg1}
    ${received}=        Get subscription message  ${subscriber}

    Stop Admin          ${admin}
    Stop Publisher      ${publisher}
    Stop Subscriber     ${subscriber}

    Should Be Equal As Strings  ${received}  ${msg1}

