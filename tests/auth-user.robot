*** Settings ***
Documentation        Testes  Auth/Users/Api

Library        RequestsLibrary
Library        String
Library        Collections


*** Variables ***
${BASEURL}            https://quality-eagles.qacoders.dev.br/api/
${ID_USER}            67cb624811d5ff76297e1170
${MSG_ERRO}           No token provided.
${fullName}           John Doe 
${mailUser}           johndoe@exemple.com
${cpf}                12345678901
${passUser}           password123
${tokenUser}
${Novo_Usuario_ID}    670595c1c0a70bc9391dd6f5
${JSON_RESPONSE}      {"status":false}
${new_full_name}      Ana Gomes
${id_user_delete}     67cb56b811d5ff76297c8858
${id_não_encontrado}  670595c1c0a70bc9391dd6f7
${id_invalido}        67ccc44611d5ff7629a136b2
${token_invalido}     abc123xyz

*** Test Cases ***  
Listar Usuarios
    Listar usuarios
Listar Usuario por ID
    Listar usuario por ID com sucesso
Listar usuario por ID acesso negado 
    Listar usuario por ID acesso negado
Listar Usuario por ID não encontrado
    Listar Usuario por ID não encontrado
Contar Usuarios
    Contar usuarios
Mostrar Usuario por ID
    Mostrar Usuario por ID
Atualizar Status de usuario para false
    Atualizar Status False
Atualizar Status de usuario para true
    Atualizar Status True
Atualizar email por ID
    Atualizar email
Atualizar nome por ID
    Atualizar Nome

Delelar usuario com id invalido
    Delelar usuario com id invalido

*** Keywords ***
Criar Sessao
    ${headers}    Create Dictionary    
    ...    accept=application/json    
    ...    content-type=application/json
    Create Session    alias=qualityeagles    url=${BASEURL}    headers=${headers}    verify=true     
Pegar Token
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com
    ...    password=1234@Test
    #Log    ${body}
    Criar Sessao
    ${resposta}    POST On Session    alias=qualityeagles    url=/login    json=${body}
    Status Should Be    200    ${resposta}
    RETURN                     ${resposta.json()["token"]}   


Listar usuarios    
    ${TOKEN}    Pegar Token
    GET On Session    alias=qualityeagles    url=/user/?token=${TOKEN}
    Status Should Be    200
Listar usuario por ID com sucesso
    ${TOKEN}    Pegar Token   
    GET On Session    alias=qualityeagles    url=/user/${ID_USER}?token=${TOKEN}
    Status Should Be    200 
Listar usuario por ID acesso negado 
    ${TOKEN}    Pegar Token
    ${response}    GET On Session    alias=qualityeagles    url=/user/?${token_invalido}    expected_status=any
    Status Should Be    403   
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings    ${response.json()["errors"][0]}     No token provided.
Listar Usuario por ID não encontrado
    ${TOKEN}    Pegar Token   
    ${response}    GET On Session    alias=qualityeagles   url=/user/${id_não_encontrado}?token=${TOKEN}    expected_status=Any
    Status Should Be    404
    Should Be Equal As Strings   ${response.json()["alert"][0]}   Esse usuário não existe em nossa base de dados.
Contar usuarios
    ${TOKEN}    Pegar Token
    GET On Session    alias=qualityeagles    url=/user/count?token=${TOKEN}
    Status Should Be    200
    #Should Contain Any    3203
Mostrar Usuario por ID
    ${TOKEN}    Pegar Token
    GET On Session    alias=qualityeagles    url=/user/${Novo_Usuario_ID}?token=${TOKEN}
    Status Should Be    200
    Should Be Equal As Strings   ${new_full_name}    Ana Gomes
Atualizar Status False
    ${TOKEN}    Pegar Token
    ${body}     Create Dictionary    status=false
    PUT On Session    alias=qualityeagles    url=/user/status/${ID_USER}?token=${TOKEN}    json=${body}
    Status Should Be    200
Atualizar Status True 
    ${TOKEN}    Pegar Token
    ${body}     Create Dictionary    status=true 
    PUT On Session    alias=qualityeagles    url=/user/status/${ID_USER}?token=${TOKEN}    json=${body}
    Status Should Be    200
Atualizar email 
    ${TOKEN}    Pegar Token
    ${body}     Create Dictionary    email=testes@test.com
    PUT On Session    alias=qualityeagles    url=/user/status/${ID_USER}?token=${TOKEN}    json=${body}
    Status Should Be    200
Atualizar Nome
    ${TOKEN}    Pegar Token
    ${body}     Create Dictionary    email=testes@test.com
    PUT On Session    alias=qualityeagles    url=/user/status/${ID_USER}?token=${TOKEN}    json=${body}
    Status Should Be    200

Delelar usuario com id invalido
    ${TOKEN}    Pegar Token
    ${response}    DELETE On Session    alias=qualityeagles    url=/user/${id_invalido}?token=${token}     expected_status=any
    Status Should Be    400
    Should Be Equal As Strings   ${response.json()["alert"][0]}   Esse usuário não existe em nossa base de dados.
