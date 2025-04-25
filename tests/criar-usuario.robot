*** Settings ***
Documentation        Criar Usuario

Library        RequestsLibrary
Library        String
Library        Collections
Library        ../libs/get_fake_company.py

*** Variables ***
${BASEURL}         https://quality-eagles.qacoders.dev.br/api/
#${TOKEN}          eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmRiNWU0MGU1YTAwMTU2MzRmMTM3ZTYiLCJmdWxsTmFtZSI6IlFhLUNvZGVycy1TWVNBRE1JTiIsIm1haWwiOiJzeXNhZG1pbkBxYWNvZGVycy5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRqcGFsRGFZUlYuQlpTVndqM0xPYS8uQ2FxWC9CTVFzelFmNDdDZmp6dWJBTzVrRXA2anA2SyIsImFjY2Vzc1Byb2ZpbGUiOiJTWVNBRE1JTiIsImNwZiI6IjExMTExMTExMTExIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjExMTExMTExMTExMTExMTExMSIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoic2V4dGEtZmVpcmEsIDA2LzA5LzIwMjQsIDE2OjU1OjQ0IEJSVCIsInJlZ2lzdHJhdGlvbk51bWJlciI6IjAxIiwiY29tcGFueUlkIjoiUWEuQ29kZXJzIiwiX2lkIjoiNjZkYjVlNDBlNWEwMDE1NjM0ZjEzN2U3In1dLCJfX3YiOjAsImlhdCI6MTc0MDc2ODg5NCwiZXhwIjoxNzQwODU1Mjk0fQ.c1zcK6uPMdMaD_Co76ky-NiG-NC2jsdhG80JDW2BcsE
${ID_USER}         67d3109b11d5ff7629057667


*** Test Cases
CT01 - Realizar Login 
    ${resposta}    Realizar Login     email=sysadmin@qacoders.com    senha=1234@Test   
    Status Should Be    200    ${resposta}
CT02 - Criar Uuario
    ${resposta}    Realizar Login     email=sysadmin@qacoders.com    senha=1234@Test   
    Status Should Be    200    ${resposta}

CT03 - Deletar usuario com sucesso
    ${ID_USER}        Criar usuario
    ${resposta}       Delete User    ID_USER=${ID_USER}
    
    

*** Keywords ***
Criar Sessao
    [Documentation]    Criando sessao inicial para usar nas proximas requests
    ${headers}    Create Dictionary    accept=application/json    content-type=application/json
    Create Session    alias=qualityeagles    url=${BASE_URL}    headers=${headers}    verify=true
Pegar Token
    [Documentation]    Request usada para pegar o token do admin 
    ${body}    Create Dictionary    #objeto json
    ...    mail=sysadmin@qacoders.com
    ...    password=1234@Test
    Criar Sessao   # ele define qual request tenho que enviar 
    ${resposta}    POST On Session    alias=qualityeagles    url=/login    json=${body}
    RETURN    ${resposta.json()["token"]}   # retorna o Token
Realizar Login
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}   # essa função define o que obrigatoriamente tem que reseber
    ${body}    Create Dictionary    
    ...    mail=${email}
    ...    password=${senha}
    Criar Sessao
    ${resposta}    POST On Session    alias=qualityeagles    expected_status=any    url=/login    json=${body}
    RETURN    ${resposta} 

Criar usuario 
    [Documentation]    Keyword para criar usuario 
    ${person}    Get Fake Person
    ${token}     Pegar Token
    ${body}      Create Dictionary    
    ...    fullName=${person}[name]    
    ...    mail=${person}[email]    
    ...    password=1234@Test     
    ...    accessProfile=ADMIN    
    ...    cpf=${person}[cpf]    
    ...    confirmPassword=1234@Test

    ${resposta}    POST On Session    
    ...    alias=qualityeagles      
    ...    url=/user/?token=${token}    
    ...    json=${body}
    Status Should Be    201    ${resposta}
    RETURN    ${resposta.json()["user"]["_id"]}   # retorna a resposta e o id


Cadastro Sucesso
    ${ID_USER}    Criar usuario
    Get User    id_user=${ID_USER}
Get User
    [Arguments]    ${ID_USER}
    ${token}    Pegar Token
    ${resposta}    GET On Session    alias=qualityeagles    url=/user/${ID_USER}?token=${token}
    RETURN    ${resposta}

Delete User
    [Arguments]    ${ID_USER}
    ${token}     Pegar Token   
    ${resposta}    DELETE On Session    alias=qualityeagles    url=/user/${ID_USER}?token=${token}
    RETURN    ${resposta}

