** Settings ***
Documentation        Criar Empresa

Library        RequestsLibrary
Library        String
Library        Collections
Library        ../libs/get_fake_company.py

*** Variables ***
${BASE_URL}         https://quality-eagles.qacoders.dev.br/api/
#${TOKEN}          eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmRiNWU0MGU1YTAwMTU2MzRmMTM3ZTYiLCJmdWxsTmFtZSI6IlFhLUNvZGVycy1TWVNBRE1JTiIsIm1haWwiOiJzeXNhZG1pbkBxYWNvZGVycy5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRqcGFsRGFZUlYuQlpTVndqM0xPYS8uQ2FxWC9CTVFzelFmNDdDZmp6dWJBTzVrRXA2anA2SyIsImFjY2Vzc1Byb2ZpbGUiOiJTWVNBRE1JTiIsImNwZiI6IjExMTExMTExMTExIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjExMTExMTExMTExMTExMTExMSIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoic2V4dGEtZmVpcmEsIDA2LzA5LzIwMjQsIDE2OjU1OjQ0IEJSVCIsInJlZ2lzdHJhdGlvbk51bWJlciI6IjAxIiwiY29tcGFueUlkIjoiUWEuQ29kZXJzIiwiX2lkIjoiNjZkYjVlNDBlNWEwMDE1NjM0ZjEzN2U3In1dLCJfX3YiOjAsImlhdCI6MTc0MDc2ODg5NCwiZXhwIjoxNzQwODU1Mjk0fQ.c1zcK6uPMdMaD_Co76ky-NiG-NC2jsdhG80JDW2BcsE
${ID_EMPRESA}         67d3109b11d5ff7629057667


*** Test Cases
CT01 - Realizar Login 
    ${resposta}    Realizar Login     email=sysadmin@qacoders.com    senha=1234@Test   
    Status Should Be    200    ${resposta}
CT02 - Criar Empresa com sucesso
    ${resposta}    Realizar Login     email=sysadmin@qacoders.com    senha=1234@Test   
    Status Should Be    200    ${resposta}

CT03 - Deletar Empresa com sucesso
    ${ID_EMPRESA}        Criar Empresa com sucesso
    ${resposta}       Delete empresa    ID_EMPRESA=${ID_EMPRESA}
    
    

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
    ${resposta}    POST On Session    alias=qualityeagles    expected_status=any    url=/login    json=${body}    timeout=60
    RETURN    ${resposta} 

Criar Empresa com sucesso
    [Tags]    criacao    positivo
    ${companyFake}    Get Fake Company
    ${token}          Pegar Token
    ${headers}    Create Dictionary
    ...    accept=application/json
    ...    content-type=application/json
    ...    Authorization=Bearer ${token}
    Create Session    qualityeagles    ${BASE_URL}    headers=${headers}
    
    ${body}    Create Dictionary
    ...    corporateName=${companyFake}[name]
    ...    registerCompany=${companyFake}[cnpj]
    ...    mail=${companyFake}[email]
    ...    responsibleContact=${companyFake}[responsavel]
    ...    phone=${companyFake}[phone]
    ...    serviceDescription=${companyFake}[descricao]
    ...    zipCode=${companyFake}[zipCode]
    ...    city=${companyFake}[city]
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[district]
    ...    street=${companyFake}[street]
    ...    number=${companyFake}[number]

    ${response}    POST On Session    qualityeagles    /company    json=${body}    timeout=60
    Status Should Be    201    ${response}
    ${resposta}    POST On Session    qualityeagles    /company    json=${body}    timeout=60
    Status Should Be    201    ${resposta}
    RETURN    ${resposta.json()["company"]["_id"]}   # retorna a resposta e o id


Cadastro Sucesso
    ${ID_EMPRESA}    Criar Empresa com sucesso
    Get empresa    id_empresa=${ID_EMPRESA}
Get empresa
    [Arguments]    ${ID_EMPRESA}
    ${token}    Pegar Token
    ${resposta}    GET On Session    alias=qualityeagles    url=/company/${ID_EMPRESA}?token=${token}
    RETURN    ${resposta}

Delete Empresa
    [Arguments]    ${ID_EMPRESA}
    ${token}     Pegar Token
    ${headers}    Create Dictionary
    ...    accept=application/json
    ...    content-type=application/json
    ...    Authorization=Bearer ${token}
    Create Session    alias=qualityeagles    url=${BASE_URL}    headers=${headers}    verify=false    disable_warnings=True
    ${resposta}    DELETE On Session    alias=qualityeagles    url=/company/${ID_EMPRESA}
    RETURN    ${resposta} 

