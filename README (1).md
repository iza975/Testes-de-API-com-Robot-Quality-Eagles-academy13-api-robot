# 🤖 Testes de API com Robot Framework | Quality Eagles - Academy #13

![Robot Tests](https://github.com/iza975/Testes-de-API-com-Robot-Quality-Eagles-academy13-api-robot/actions/workflows/robot-tests.yml/badge.svg)

Este projeto faz parte do programa de formação **QA Coders Academy #13** da QAcoders, com foco na criação e execução de testes de API utilizando o **Robot Framework**.

---

## 🚀 Sobre o Projeto

O objetivo é validar os endpoints da API através de testes automatizados com Robot Framework. Os testes foram organizados por funcionalidades, incluindo autenticação, operações com usuários e empresas.

---

## 🔐 Autenticação

- Login com dados válidos  
- Login com campos vazios ou inválidos  
- Validação de status code e mensagens de erro  

---

## 👤 Usuário (User)

- Listar usuários  
- Buscar usuário por ID  
- Criar, editar e excluir usuário  
- Testes com dados inválidos e campos obrigatórios ausentes  

---

## 🏢 Empresa (Company)

- Criar empresa  
- Listar e contar empresas  
- Buscar, atualizar e excluir empresa por ID  
- Validações de formato de e-mail e status de cadastro  

---

## ✅ Validações Realizadas

- Códigos de status HTTP esperados (`200`, `201`, `403`)  
- Mensagens específicas no corpo da resposta  
- Validação de estrutura JSON  
- Verificação de campos obrigatórios e dados inválidos  

---

## 📁 Estrutura do Projeto

```
Testes-de-API-com-Robot/
├── tests/
│   ├── login.robot
│   ├── get.robot
│   ├── post.robot
│   ├── put.robot
│   ├── delete.robot
├── resources/
│   └── resource.robot
├── .github/
│   └── workflows/
│       └── robot-tests.yml
├── README.md
```

---

## ▶️ Como Executar os Testes

### Pré-requisitos:
- Python 3.12 ou superior  
- Robot Framework instalado  

### Comandos:
```bash
pip install robotframework
robot tests/
```

---

## 📦 Execução Automática com GitHub Actions

A cada push na branch `master`, os testes são executados automaticamente via GitHub Actions.  
Confira o status pelo badge no topo do README ou [clique aqui para ver a execução](https://github.com/iza975/Testes-de-API-com-Robot-Quality-Eagles-academy13-api-robot/actions).

---

## 👩‍💻 Desenvolvido por

**Sônia Izabel Wicki**  
Aluna QA Coders Academy #13  
📍 Almirante Tamandaré - PR  

💡 Acredito que a tecnologia transforma, a qualidade sustenta e o aprendizado contínuo impulsiona a evolução.
