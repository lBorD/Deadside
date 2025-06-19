#Requires AutoHotkey v2.0

;=====================================================
; SCRIPT ANTI-RECOIL COM GUI - DEADSIDE
;=====================================================

;-----------------
; CONFIGURAÇÕES GLOBAIS
;-----------------
antiRecoilAtivo := false    ; Começa desativado
sensibilidade := 0.4        ; Multiplicador de sensibilidade (ajuste conforme necessário)
armaAtual := "Fasam"        ; Arma inicial selecionada
teclaAtivacao := "F1"       ; Tecla para ativar/desativar o anti-recoil
tipoMira := "1x"            ; Tipo de mira sendo usada (1x, 1.5x, 2x, 3.5x, 4x, 4.5x)

; Tabela de armas com RPM (Rate Per Minute)
armasRPM := Map(
    ; "AK-SU", 600,
    "AK-SM", 625,
    ; "AK-mod", 600,
    ; "AR4", 650,
    ; "AR4-M", 650,
    ; "Skar", 600,
    ; "Grom", 650,
    ; "UAG", 700,
    "Fasam", 750
)

; Calcula o intervalo inicial com base na arma padrão
rpm := armasRPM[armaAtual]
calculatedInterval := Round((60 / rpm) * 1000)
intervaloTiro := Round(calculatedInterval / 12)  ; Converte para um valor prático

; Tabela de multiplicadores de sensibilidade por tipo de mira
miraSensibilidade := Map(
    "Sem Mira", 0.1,
    "1x", 0.85,
    ; "1.5x", 0.9,
    ; "2x", 0.95,
    ; "3.5x", 0.98,
    "4x", 1.0,
    ; "4.5x", 1.05
)

;-----------------
; PADRÕES DE RECOIL
;-----------------
; Cada padrão é uma lista de movimentos [X, Y] que serão aplicados em sequência
; X positivo = direita, X negativo = esquerda
; Y positivo = baixo, Y negativo = cima
famasPattern := [
    ; Fase inicial - primeiros tiros (valores aumentados para mira 4x)
    [0, 8],     ; Primeiro tiro - compensação vertical inicial mais forte
    [0, 8],     ; Segundo tiro
    [-1, 9],    ; Terceiro tiro - começa a puxar levemente para esquerda
    [-1, 9],
    [-2, 10],   ; Aumenta gradualmente a compensação
    ; Fase média - recoil aumenta (valores mais altos para mira 4x)
    [-2, 9],
    [-3, 10],
    [-3, 10],
    [-4, 10],   ; Recoil mais forte no meio do spray
    [-4, 10],
    ; Fase estável - mantém compensação forte
    [-4, 10],
    [-4, 10],
    [-3, 9],
    [-3, 9],
    [-3, 9],
    ; Fase prolongada - mantém padrão para tiros adicionais
    [-3, 9],
    [-3, 9],
    [-2, 8],
    [-2, 8],
    [-2, 8],
    ; Fase final - estabilização com compensação contínua
    [-3, 9],
    [-3, 9],
    [-3, 9],
    [-3, 8],
    [-3, 8],
    ; Tiros extras - primeira parte (pente estendido)
    [-4, 9],
    [-4, 9],
    [-3, 8],
    [-3, 8],
    [-4, 9],
    ; Tiros extras - segunda parte
    [-4, 9],
    [-3, 8],
    [-3, 8],
    [-4, 9],
    [-4, 9],
    ; Tiros adicionais para pente estendido (40 balas)
    [-3, 8],
    [-3, 8],
    [-4, 9],
    [-4, 9],
    [-3, 8],
    [-3, 8],
    [-4, 9],
    [-4, 9],
    [-3, 8],
    [-3, 8]
]

aksmPattern := [
    ; Fase inicial - primeiros tiros (valores aumentados para mira 4x)
    [0, 8],     ; Primeiro tiro - compensação vertical inicial mais forte
    [0, 8],     ; Segundo tiro
    [-1, 9],    ; Terceiro tiro - começa a puxar levemente para esquerda
    [-1, 9],
    [-2, 10],   ; Aumenta gradualmente a compensação
    ; Fase média - recoil aumenta (valores mais altos para mira 4x)
    [-2, 9],
    [-3, 10],
    [-3, 10],
    [-3, 10],   ; Recoil mais forte no meio do spray
    [-3, 10],
    ; Fase estável - mantém compensação forte
    [-3, 10],
    [-3, 10],
    [-3, 9],
    [-3, 9],
    [-3, 9],
    ; Fase prolongada - mantém padrão para tiros adicionais
    [-3, 9],
    [-3, 9],
    [-2, 8],
    [-2, 8],
    [-2, 8],
    ; Fase final - estabilização com compensação contínua
    [-3, 9],
    [-3, 9],
    [-3, 9],
    [-3, 8],
    [-3, 8],
    ; Tiros extras - primeira parte (pente estendido)
    [-4, 9],
    [-4, 9],
    [-3, 8],
    [-3, 8],
    [-4, 9],
    ; Tiros extras - segunda parte
    [-4, 9],
    [-3, 8],
    [-3, 8],
    [-4, 9],
    [-4, 9],
    ; Tiros adicionais para pente estendido (40 balas)
    [-3, 8],
    [-3, 8],
    [-4, 9],
    [-4, 9],
    [-3, 8],
    [-3, 8],
    [-4, 9],
    [-4, 9],
    [-3, 8],
    [-3, 8]
]

;-----------------
; INTERFACE GRÁFICA
;-----------------
; Cria a janela principal
mainGui := Gui(, "Deadside Anti-Recoil")
mainGui.SetFont("s10")
mainGui.MarginX := 15
mainGui.MarginY := 15

; Seção de Status
mainGui.AddText("section w300", "Status do Anti-Recoil:")
statusText := mainGui.AddText("xs y+5 w300 h20 vStatusText", "DESATIVADO")
statusText.SetFont("s11 bold cRed")

; Informações da arma atual
mainGui.AddText("xs y+10 w300", "Informações da Arma:")
armaInfoText := mainGui.AddText("xs y+5 w300 h60 vArmaInfo", "Arma: `nRPM: `nIntervalo: `nSensibilidade: ")
armaInfoText.SetFont("s9")

; Seção de Controles
mainGui.AddText("xs y+15 w300", "Controles:")

; Tecla de ativação
mainGui.AddText("xs y+10 w120", "Tecla de Ativação:")
hotkeyCtrl := mainGui.AddHotkey("x+10 yp-3 w150 vTeclaAtivacao", teclaAtivacao)

; Arma selecionada
mainGui.AddText("xs y+15 w120", "Arma:")
armaDropdown := mainGui.AddDropDownList("x+10 yp-3 w150 vArmaAtual Choose9",
    [
        ;"AK-SU",
        "AK-SM",
        ;  "AK-mod",
        ;  "AR4",
        ;  "AR4-M",
        ;  "Skar",
        ;  "Grom",
        ;  "UAG",
        "Fasam"])
armaDropdown.OnEvent("Change", OnArmaChange)

; Sensibilidade
mainGui.AddText("xs y+15 w120", "Sensibilidade:")
sensiEdit := mainGui.AddEdit("x+10 yp-3 w70 vSensibilidade", sensibilidade * 10)  ; Multiplicamos por 10 para exibição
mainGui.AddUpDown("Range1-100", sensibilidade * 10)  ; Usando valores inteiros

; Opção de mira
mainGui.AddText("xs y+15 w120", "Tipo de Mira:")
; miraDropdown := mainGui.AddDropDownList("x+10 yp-3 w150 vTipoMira Choose6",
    ; [
    ;     "Sem Mira",
    ;     "1x (OET/D-Point/MSR)",
    ;     ;"1.5x (Tricon/Halosun)",
    ;     ;"2x (Hunting)",
    ;     ;"3.5x (PU)",
    ;     "4x (POS-1/COD/HMR)",
    ;     ;"4.5x (ELCN)"
    ; ])

; Botões de ação
mainGui.AddButton("xs y+20 w140 h30", "Aplicar Configurações").OnEvent("Click", AplicarConfig)
toggleBtn := mainGui.AddButton("x+20 yp w140 h30 vToggleBtn", "Ativar Anti-Recoil").OnEvent("Click", ToggleAntiRecoil)

; Informações
mainGui.AddText("xs y+20 w300", "Atalhos de Teclado:")
mainGui.AddText("xs y+5 w300", "• F6 - Mostrar Status")
mainGui.AddText("xs y+5 w300", "• F12 - Sair do Script")

; Dicas de uso
mainGui.AddText("xs y+15 w300 cBlue", "Dicas:")
mainGui.AddText("xs y+5 w300", "• Padrão calibrado para mira 4x")
mainGui.AddText("xs y+5 w300", "• Intervalo ajustado automaticamente pelo RPM")
mainGui.AddText("xs y+5 w300", "• Sensibilidade ajustada pelo tipo de mira")

; Inicializa as informações da arma
rpm := armasRPM.Has(armaAtual) ? armasRPM[armaAtual] : "N/A"
try mainGui["ArmaInfo"].Value := "Arma: " . armaAtual .
    "`nRPM: " . rpm .
    "`nIntervalo: " . intervaloTiro . " ms" .
    "`nSensibilidade: " . sensibilidade

; Atualiza o campo de intervalo na interface para mostrar o valor calculado
try mainGui["IntervaloTiro"].Value := intervaloTiro

; Mostra a GUI
mainGui.Show()

;-----------------
; FUNÇÕES DA GUI
;-----------------
AplicarConfig(*) {
    global sensibilidade, intervaloTiro, teclaAtivacao, armaAtual, tipoMira, armasRPM

    ; Obtém os valores da GUI
    valores := mainGui.Submit(false)

    ; Atualiza as variáveis globais
    if (valores.Sensibilidade > 0)
        sensibilidade := valores.Sensibilidade / 10  ; Converte o valor da interface para o valor real

    ; Atualiza as informações da arma na interface
    rpm := armasRPM.Has(armaAtual) ? armasRPM[armaAtual] : "N/A"
    try mainGui["ArmaInfo"].Value := "Arma: " . armaAtual .
        "`nRPM: " . rpm .
        "`nIntervalo: " . intervaloTiro . " ms" .
        "`nSensibilidade: " . sensibilidade

    ; Atualiza o tipo de mira
    ; Extrai o tipo de mira do texto selecionado (pega apenas a parte antes do espaço)
    miraTexto := 'valores.TipoMira' ;QUANDO APLICAR A FUNCIONALIDADE DE MUDAR A SENSI MUDAR PARA O TIPO DE MIRA
    if (InStr(miraTexto, " "))
        miraTexto := SubStr(miraTexto, 1, InStr(miraTexto, " ") - 1)

    ; Define o tipo de mira
    if (miraTexto = "Sem")
        tipoMira := "Sem Mira"
    else
        tipoMira := miraTexto

    ; Atualiza a tecla de ativação se foi alterada
    if (valores.TeclaAtivacao != teclaAtivacao && valores.TeclaAtivacao != "") {
        ; Remove o hotkey antigo
        try Hotkey teclaAtivacao, "Off"

        ; Define o novo hotkey
        teclaAtivacao := valores.TeclaAtivacao
        try Hotkey teclaAtivacao, ToggleAntiRecoil
    }

    ; Atualiza a arma selecionada
    armaAtual := valores.ArmaAtual

    ; Atualiza o intervalo com base no RPM da arma ou usa o valor manual
    if (armasRPM.Has(armaAtual)) {
        rpm := armasRPM[armaAtual]
        ; Calcula o intervalo em ms (milissegundos)
        calculatedInterval := Round((60 / rpm) * 1000)

        ; Converte para um valor mais utilizável (o RPM é muito alto para usar diretamente)
        ; Dividimos por um fator para obter um valor prático para o script
        intervaloTiro := Round(calculatedInterval / 12)
    } else {
        ; Se a arma não estiver na tabela, usa o valor inserido manualmente
        intervaloTiro := 50
    }

    ; Atualiza o campo na interface sem disparar eventos
    try mainGui["IntervaloTiro"].Value := intervaloTiro

    ; Mostra mensagem de confirmação com informações detalhadas
    ToolTip("Configurações aplicadas!`nArma: " . armaAtual .
        "`nMira: " . tipoMira .
        "`nSensibilidade: " . sensibilidade .
        "`nIntervalo: " . intervaloTiro . "ms")
    SetTimer () => ToolTip(), -1500
}

ToggleAntiRecoil(*) {
    global antiRecoilAtivo, mainGui, armaAtual, armasRPM, intervaloTiro, sensibilidade

    ; Inverte o estado
    antiRecoilAtivo := !antiRecoilAtivo

    ; Atualiza a interface
    if (antiRecoilAtivo) {
        mainGui["StatusText"].Value := "ATIVADO"
        mainGui["StatusText"].SetFont("s11 bold cGreen")
        mainGui["ToggleBtn"].Text := "Desativar Anti-Recoil"

        ; Atualiza as informações da arma na interface com status ativo
        rpm := armasRPM.Has(armaAtual) ? armasRPM[armaAtual] : "N/A"
        try mainGui["ArmaInfo"].Value := "Arma: " . armaAtual .
            "`nRPM: " . rpm .
            "`nIntervalo: " . intervaloTiro . " ms" .
            "`nSensibilidade: " . sensibilidade .
            "`nStatus: ATIVO"
        try mainGui["ArmaInfo"].SetFont("s9 bold cGreen")
    }
    else {
        mainGui["StatusText"].Value := "DESATIVADO"
        mainGui["StatusText"].SetFont("s11 bold cRed")
        mainGui["ToggleBtn"].Text := "Ativar Anti-Recoil"

        ; Atualiza as informações da arma na interface com status inativo
        rpm := armasRPM.Has(armaAtual) ? armasRPM[armaAtual] : "N/A"
        try mainGui["ArmaInfo"].Value := "Arma: " . armaAtual .
            "`nRPM: " . rpm .
            "`nIntervalo: " . intervaloTiro . " ms" .
            "`nSensibilidade: " . sensibilidade
        try mainGui["ArmaInfo"].SetFont("s9")
    }
}

OnArmaChange(*) {
    global armasRPM, intervaloTiro, armaAtual, mainGui, sensibilidade

    ; Obtém a arma selecionada
    valores := mainGui.Submit(false)
    armaAtual := valores.ArmaAtual

    ; Calcula o intervalo com base no RPM da arma
    if (armasRPM.Has(armaAtual)) {
        rpm := armasRPM[armaAtual]

        ; Calcula o intervalo em ms (milissegundos)
        calculatedInterval := Round((60 / rpm) * 1000)

        ; Converte para um valor mais utilizável
        intervaloTiro := Round(calculatedInterval / 10)

        ; Atualiza o campo de intervalo na interface com try para evitar erros
        try mainGui["IntervaloTiro"].Value := intervaloTiro

        ; Atualiza as informações da arma na interface
        try mainGui["ArmaInfo"].Value := "Arma: " . armaAtual .
            "`nRPM: " . rpm .
            "`nIntervalo: " . intervaloTiro . " ms" .
            "`nSensibilidade: " . sensibilidade

        ; Mostra mensagem de confirmação
        ToolTip("Arma alterada para " . armaAtual . " (" . rpm . " RPM, " . intervaloTiro . "ms)")
        SetTimer () => ToolTip(), -1500
    }
}

; Define a tecla de ativação inicial
Hotkey teclaAtivacao, ToggleAntiRecoil

; Mostrar status atual
F6::
{
    global antiRecoilAtivo, sensibilidade, intervaloTiro, armaAtual, tipoMira
    status := "Status Anti-Recoil:`n"
        . "- Ativo: " . (antiRecoilAtivo ? "Sim" : "Não") . "`n"
        . "- Arma: " . armaAtual . "`n"
        . "- Mira: " . tipoMira . "`n"
        . "- Sensibilidade: " . Round(sensibilidade, 1) . "`n"
        . "- Intervalo: " . intervaloTiro . "ms"

    ToolTip(status)
    SetTimer () => ToolTip(), -3000  ; Remove após 3 segundos
}

;-----------------
; FUNÇÃO PRINCIPAL DO ANTI-RECOIL
;-----------------
~LButton::
{
    global antiRecoilAtivo, sensibilidade, intervaloTiro, armaAtual, famasPattern, tipoMira

    ; Se o anti-recoil estiver desativado, não faz nada
    if (!antiRecoilAtivo)
        return

    ; Seleciona o padrão correto com base na arma atual
    padraoAtual := famasPattern  ; Por enquanto só temos a FAMAS

    ; Ajusta a sensibilidade com base no tipo de mira usando a tabela de multiplicadores
    multiplicadorMira := 1.0  ; Valor padrão para mira 4x

    ; Usa o multiplicador da tabela se disponível
    if (miraSensibilidade.Has(tipoMira))
        multiplicadorMira := miraSensibilidade[tipoMira]

    ; Aplica o padrão de compensação em loop contínuo
    index := 1
    totalMovimentos := padraoAtual.Length

    ; Loop contínuo enquanto o botão do mouse estiver pressionado
    while (GetKeyState("LButton", "P")) {
        ; Calcula o índice atual no padrão (loop circular)
        currentIndex := Mod(index - 1, totalMovimentos) + 1
        movimento := padraoAtual[currentIndex]

        ; Calcula o movimento com base na sensibilidade e tipo de mira
        moverX := movimento[1] * sensibilidade * multiplicadorMira
        moverY := movimento[2] * sensibilidade * multiplicadorMira

        ; Move o mouse para compensar o recoil
        ; UINT 1 = MOUSEEVENTF_MOVE (movimento relativo do mouse)
        DllCall("mouse_event", "UInt", 1, "Int", moverX, "Int", moverY, "UInt", 0, "UInt", 0)

        ; Usa um intervalo constante para o loop contínuo
        Sleep(intervaloTiro)

        ; Incrementa o índice
        index++
    }
}

; Sair do script
F12:: ExitApp