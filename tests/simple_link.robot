*** Settings ***
Documentation     A minimal pub sub flow
Resource          ../variables/tokens.robot
Resource          ../keywords/admin.robot
Resource          ../keywords/subscriber.robot
Resource          ../keywords/publisher.robot

*** Variables ***
${original_room1}     temp11
${original_room2}     temp22
${linked_room}        factory
${tag}                hallway
${msg1}               temp1abc
${msg2}               temp2abc

*** Test Cases ***
Valid Single Link
    ${admin}=           Get admin
    Launch Admin        ${admin}  ${GOD_TOKEN}  ${original_room1}

    ${publisher}=       Get Publisher
    Launch publisher    ${publisher}  ${GOD_TOKEN}  ${original_room1}

    ${subscriber}=      Get Subscriber
    Launch subscriber   ${subscriber}  ${GOD_TOKEN}  ${linked_room}  ${tag}

    Sleep               1  for proper launches

    Link Rooms           ${admin}  ${original_room1}  ${linked_room}

    Publish message     ${publisher}  ${msg1}
    ${received}=        Get subscription message  ${subscriber}

    Stop Admin          ${admin}
    Stop Publisher      ${publisher}
    Stop Subscriber     ${subscriber}

    Should Be Equal As Strings  ${received}  ${msg1}

Valid Single Destination Link
    ${admin}=           Get admin
    Launch Admin        ${admin}  ${GOD_TOKEN}  ${original_room1}

    ${publisher1}=      Get Publisher
    Launch publisher    ${publisher1}  ${GOD_TOKEN}  ${original_room1}

    ${publisher2}=      Get Publisher
    Launch publisher    ${publisher2}  ${GOD_TOKEN}  ${original_room2}

    ${subscriber}=      Get Subscriber
    Launch subscriber   ${subscriber}  ${GOD_TOKEN}  ${linked_room}  ${tag}

    Sleep               1  for proper launches

    Link Rooms          ${admin}  ${original_room1}  ${linked_room}
    Link Rooms          ${admin}  ${original_room2}  ${linked_room}

    Publish message     ${publisher1}  ${msg1}
    Publish message     ${publisher2}  ${msg2}

    ${received1}=       Get subscription message  ${subscriber}
    ${received2}=       Get subscription message  ${subscriber}

    Stop Admin          ${admin}
    Stop Publisher      ${publisher1}
    Stop Publisher      ${publisher2}
    Stop Subscriber     ${subscriber}

    Should Be Equal As Strings  ${received1}  ${msg1}
    Should Be Equal As Strings  ${received2}  ${msg2}
