*** Settings ***
Documentation        Login de Usuario/Api

Library        RequestsLibrary
Library        ../libs/get_fake_company.py

*** Variables ***
${BASE_URL}     https://quality-eagles.qacoders.dev.br/api/ 

*** Test Cases *** 
CT01 - Realizar Login com sucesso
    ${resposta}    Realizar Login     email=sysadmin@qacoders.com    senha=1234@Test   
    RequestsLibrary.Status Should Be    200    ${resposta}

CT02 - Realizar Login com senha invalida 
    ${resposta}    Realizar Login     email=sysadmin@qacoders.com    senha=1234@Tes   
    RequestsLibrary.Status Should Be    400    ${resposta}
    
CT03 - Realizar Login com email invalido
    ${resposta}    Realizar Login     email=sysadmin@qacoders.com.br    senha=1234@Test 
    RequestsLibrary.Status Should Be    400    ${resposta}
    BuiltIn.Log To Console    message=${resposta}             # vem debugando a response 400
    BuiltIn.Log To Console    message=${resposta.json()}      # imprime todo o objeto
    BuiltIn.Log To Console    message=${resposta.json()["alert"]}  # imprime somente a mensagem
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${resposta.json()["alert"]}
    
CT04 - Realizar Login com email e senha em branco
    ${resposta}    Realizar Login     email=''    senha=''
    RequestsLibrary.Status Should Be    400    ${resposta}
    BuiltIn.Log To Console    message=${resposta}             # vem debugando a response 400
    BuiltIn.Log To Console    message=${resposta.json()}      # imprime todo o objeto
    BuiltIn.Log To Console    message=${resposta.json()["alert"]}  # imprime somente a mensagem
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${resposta.json()["alert"]}
  
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
    POST On Session    alias=qualityeagles    url=/login    json=${body}
 
Realizar Login
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}   # essa função define o que obrigatoriamente tem que reseber
    ${body}    Create Dictionary    
    ...    mail=${email}
    ...    password=${senha}
    Criar Sessao
    ${resposta}    POST On Session    alias=qualityeagles    expected_status=any    url=/login    json=${body}
    RETURN    ${resposta}    

# essa resposta  que vai retornar do realizar 
#login e capturada na variavel local do  test case realiza login na linha 
# numero 15  (expectes_status=ane faz o ajuste automatico do status code )