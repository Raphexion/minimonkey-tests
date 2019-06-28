*** Settings ***
Documentation     A minimal pub sub flow
Resource          tokens.robot
Resource          subscriber.robot
Resource          publisher.robot

*** Variables ***
${room}     themeratures
${tag}      hallway
${msg}      1234

*** Test Cases ***
Incorrect Token
    ${publisher}=       Get Publisher
    Launch publisher    ${publisher}  ${BAD_TOKEN}  ${room}

    ${last_error}=	Last Publisher Error  ${publisher}

    Should Be Equal As Strings  ${last_error}  failed to log in

    Stop publisher     ${publisher}
