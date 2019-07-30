*** Settings ***
Documentation     A minimal pub sub flow
Library      	  Instructions
Resource          ../variables/tokens.robot

*** Variables ***
${original_room1}     temp11
${original_room2}     temp22
${linked_room}        factory
${tag}                hallway
${msg1}               temp1abc
${msg2}               temp2abc

*** Test Cases ***
Valid Single Link
    Link Rooms          ${original_room1}  ${linked_room}  ${GOD_TOKEN}
    ${promise}=         Subscribe Promise  ${linked_room}  ${tag}  ${GOD_TOKEN}
    Publish             ${msg1}  ${original_room1}  ${GOD_TOKEN}
    ${received}=        Subscribe Get  ${promise}

    Should Be Equal As Strings  ${received}  ${msg1}

Valid Single Destination Link
    Link Rooms          ${original_room1}  ${linked_room}  ${GOD_TOKEN}
    Link Rooms          ${original_room2}  ${linked_room}  ${GOD_TOKEN}

    ${promise}=         Subscribe Promise  ${linked_room}  ${tag}  ${GOD_TOKEN}

    Publish             ${msg1}  ${original_room1}  ${GOD_TOKEN}
    Publish             ${msg2}  ${original_room2}  ${GOD_TOKEN}

    ${received1}=        Subscribe Get  ${promise}  False
    ${received2}=        Subscribe Get  ${promise}

    Should Be Equal As Strings  ${received1}  ${msg1}
    Should Be Equal As Strings  ${received2}  ${msg2}
