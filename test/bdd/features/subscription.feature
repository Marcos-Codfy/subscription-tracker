# Arquivo de feature BDD escrito em linguagem Gherkin.
#
# O QUE É BDD (Behavior Driven Development)?
# BDD é uma técnica de desenvolvimento guiado por comportamento.
# A ideia é descrever o comportamento do sistema em linguagem natural,
# usando o padrão: Dado (Given) / Quando (When) / Então (Then)
#
# Isso permite que desenvolvedores, testers e clientes entendam os testes.
# Os arquivos .feature são a "especificação executável" do sistema.

Feature: Gerenciamento de Assinaturas
  Como um usuário do app Subscription Tracker
  Eu quero gerenciar minhas assinaturas mensais
  Para que eu possa controlar meus gastos

  # ── Cenário 1: Adicionar primeira assinatura ────────────────────────────────
  Scenario: Adicionar a primeira assinatura e ver o total atualizado
    Given a lista de assinaturas está vazia
    When o usuário adiciona "Netflix" com o valor "40.00"
    Then o valor total gasto por mês deve ser "R$ 40,00"
    And a lista deve conter "1" assinatura

  # ── Cenário 2: Adicionar múltiplas assinaturas ──────────────────────────────
  Scenario: Somar corretamente múltiplas assinaturas
    Given a lista de assinaturas está vazia
    When o usuário adiciona "Netflix" com o valor "40.00"
    And o usuário adiciona "Spotify" com o valor "21.90"
    Then o valor total gasto por mês deve ser "R$ 61,90"
    And a lista deve conter "2" assinaturas

  # ── Cenário 3: Remover uma assinatura ───────────────────────────────────────
  Scenario: Remover uma assinatura e atualizar o total
    Given a lista de assinaturas está vazia
    And o usuário adiciona "Netflix" com o valor "40.00"
    And o usuário adiciona "Spotify" com o valor "21.90"
    When o usuário remove a assinatura "Netflix"
    Then o valor total gasto por mês deve ser "R$ 21,90"
    And a lista deve conter "1" assinatura

  # ── Cenário 4: Lista vazia com total zero ───────────────────────────────────
  Scenario: Total deve ser zero quando não há assinaturas
    Given a lista de assinaturas está vazia
    Then o valor total gasto por mês deve ser "R$ 0,00"
    And a lista deve conter "0" assinaturas

  # ── Cenário 5: Validação de nome vazio ─────────────────────────────────────
  Scenario: Não deve permitir adicionar assinatura com nome vazio
    Given a lista de assinaturas está vazia
    When o usuário tenta adicionar uma assinatura com nome vazio e valor "40.00"
    Then a lista deve continuar vazia
    And o total deve permanecer "R$ 0,00"
