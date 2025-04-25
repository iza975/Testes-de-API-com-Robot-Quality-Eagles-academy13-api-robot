*** Settings ***

Library      RequestsLibrary
Library      String
Library      Collections
Library      ../libs/get_fake_company.py

*** Variables ***

${baseUrl}    https://quality-eagles.qacoders.dev.br/api/
${user_ID}    661c585d14ff021dc447c556


*** Test Cases ***
Criar usuário com sucesso
    [Tags]    User
    Cadastro Sucesso

Pegar um usuário por ID
    ${user_ID}    Create User
    Get User    ${user_ID}


Listagem de usuários com sucesso
    [Tags]    Smoke
    ${list_users}    List Users
    # Log To Console    ${list_users}
    Should Be String     ${list_users[0]['_id']}
    Should Not Be Empty    ${list_users}

Contagem de usuários com sucesso
    [Tags]    Smoke
    ${count_users}    Count Users
    Should Not Be Empty    ${count_users}

Atualizar Status para False
    [Tags]    Status
    ${user_ID}    Create User
    ${resposta}    Put Status    ${user_ID}    status=false
    # Log To Console    message=${resposta["msg"]}
    Should Be Equal    Status do usuario atualizado com sucesso para status false.    ${resposta["msg"]}
    Delete User    user_ID=${user_ID}

Atualizar Status para True
    [Tags]    Status
    ${user_ID}    Create User
    ${resposta}    Put Status    ${user_ID}    status=true
    Should Be String    msg=Status do usuario atualizado com sucesso para status true.    item=${resposta["msg"]}
    # Log To Console    message=${resposta["msg"]}
    Delete User    user_ID=${user_ID}




*** Keywords ***
Criar Sessao
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=qualityeagles    url=${baseUrl}    headers=${headers}    verify=true

Pegar Token
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com    
    ...    password=1234@Test
    # Log    ${body}
    Criar Sessao
    ${resposta}    POST On Session    alias=qualityeagless    url=/login    json=${body}
    Status Should Be    200    ${resposta}
    RETURN                    ${resposta.json()["token"]}
List Users
    [Documentation]    Retorna a listagem de usuários
    ${token}    Pegar Token
    ${resposta}    GET On Session    alias=qualityeagles   url=/user/?token=${token}
    Status Should Be    200    ${resposta}
    RETURN                     ${resposta.json()}
Create User
    ${person}    Get Fake Person
    ${token}    Pegar Token
    ${body}    Create Dictionary
    ...    fullName=${person}[name]    
    ...    mail=${person}[email]
    ...    password=1234@Test
    ...    accessProfile=ADMIN
    ...    cpf=${person}[cpf]
    ...    confirmPassword=1234@Test
    ${resposta}    POST On Session    alias=qualityeagles    url=/user/?token=${token}    json=${body}
    Status Should Be    201    ${resposta}
    RETURN    ${resposta.json()["user"]["_id"]}

Count Users
    ${token}    Pegar Token
    ${resposta}    GET On Session    alias=qualityeagles    url=/user/count?token=${token}
    RETURN                     ${resposta.json()}

Get User    
    [Arguments]    ${user_ID}
    ${token}    Pegar Token
    ${resposta}    GET On Session    alias=qualityeagles    url=/user/${user_ID}?token=${token}
    # Log To Console    ${resposta.json()["_id"]}

Delete User
    [Arguments]    ${id_user}
    ${token}    Pegar Token
    DELETE On Session    alias=qualityeagles    url=/user/${id_user}?token=${token}

Put Status
    [Arguments]    ${user_ID}    ${status}
    ${token}    Pegar Token
    ${body}    Create Dictionary    status=${status}
    ${resposta}    PUT On Session    alias=qualityeagles    url=/user/status/${id_user}?token=${token}    json=${body}
    RETURN                     ${resposta.json()}

Cadastro Sucesso
    ${user_ID}    Create User
    Get User    ${user_ID}
    Delete User    id_user=${user_ID}